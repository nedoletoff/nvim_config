-- Индикатор активной AI-модели в statusline.
--
-- Показывает провайдера и модель, которая сейчас реально поедет в API:
--   DeepSeek · deepseek-chat
--   OpenCode Zen · big-pickle
--
-- Бесплатные модели (Zen) подсвечиваются зелёным, платные — обычным.
-- Цвет берётся из активной темы и пересчитывается на ColorScheme.
--
-- Модель меняется на лету через <leader>cm / <leader>cM, статус сразу
-- обновляется, потому что компонент вызывает ai.status() при каждой отрисовке.

local ai = require("ai")

--- Резолвится из активной темы, чтобы не спорить с ней палитрой.
--- Хранится в hex: astroui ждёт в surround.color именно цвет, а не имя группы.
local colors = { free_fg = "#89b4fa", paid_fg = "#7f848e", bg = "#1c1c1c" }

local function setup_hl()
  local get = require("astroui").get_hlgroup
  colors.bg = get("Visual").bg or colors.bg
  colors.free_fg = get("DiagnosticOk").fg or colors.free_fg
  colors.paid_fg = get("Comment").fg or colors.paid_fg

  vim.api.nvim_set_hl(0, "AIModelFree", { fg = colors.free_fg, bg = colors.bg, bold = true })
  vim.api.nvim_set_hl(0, "AIModelPaid", { fg = colors.paid_fg, bg = colors.bg, bold = true })
end

--- Текущая модель и признак «бесплатная»
---@return string, boolean
local function current()
  local provider, model = ai.current()
  return model, ai.PROVIDERS[provider].free == true
end

---@return string
local function provider_label()
  local provider = ai.current()
  return ai.PROVIDERS[provider].label
end

return {
  {
    "rebelot/heirline.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.statusline then
        return opts
      end

      local status = require("astroui.status")

      -- Глиф берём литералом, а не через get_icon: таблица иконок astrocore
      -- заполняется при старте и в некоторых окружениях отдаёт пустую строку.
      -- Тот же глиф уже используется в astrocore для CodeCompanion.
      local icon = "󰚩"

      -- Компонент: иконка, имя провайдера, модель, пометка free
      local component = status.component.builder {
        { provider = icon .. " ", hl = "AIModelFree" },
        { provider = function() return provider_label() .. " " end, hl = "AIModelFree" },
        {
          provider = function()
            return current()
          end,
          hl = function()
            local _, free = current()
            return free and "AIModelFree" or "AIModelPaid"
          end,
        },
        {
          -- «free» показываем только у бесплатных моделей
          provider = function()
            local _, free = current()
            return free and " free" or ""
          end,
          hl = "AIModelFree",
        },
        padding = { right = 1 },
        surround = {
          separator = "left",
          -- здесь нужен именно hex: astroui кладёт его прямо в nvim_set_hl
          color = function()
            local _, free = current()
            return { main = colors.bg, right = colors.bg }
          end,
        },
      }

      -- statusline может быть как таблицей, так и функцией
      local statusline_table = type(opts.statusline) == "function" and opts.statusline() or opts.statusline

      -- Сразу после блока режима (mode) — чтобы модель бросалась в глаза слева
      table.insert(statusline_table, 2, component)
      opts.statusline = statusline_table

      return opts
    end,
  },

  -- Группы живут не в теме, а здесь, поэтому просто держим их в актуальном
  -- состоянии при смене colorscheme. Переопределять `status.setup_colors`
  -- нельзя: это внутренняя точка входа, через которую recipe nvchad
  -- заводит свои blank_bg / file_info_bg — если её подменить, heirline
  -- падает с "Invalid highlight color: 'normal'".
  {
    "astroui",
    opts = function(_, opts)
      local group = vim.api.nvim_create_augroup("AIModelStatusline", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = setup_hl,
        desc = "Пересчитать цвета индикатора AI-модели",
      })
      return opts
    end,
  },

  init = function()
    vim.schedule(setup_hl)
  end,
}
