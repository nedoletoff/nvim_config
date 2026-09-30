-- Оформление интерфейса.
--
-- Раньше здесь стояли dressing.nvim (забирал vim.ui.input/select) и
-- nvim-notify (переопределял vim.notify). Оба конфликтовали со Snacks,
-- который в AstroNvim v5 сам владеет и UI-диалогами, и уведомлениями:
--   * :checkhealth snacks падал с ERROR «vim.ui.input is not set to
--     Snacks.input» и тем же для select;
--   * dressing был настроен на backend telescope, которого в системе нет,
--     поэтому vim.ui.select молча откатывался на builtin;
--   * nvim-notify проигрывал Snacks.notifier, и его config.setup с
--     background_colour просто не выполнялся — мёртвый код.
-- Теперь vim.ui и vim.notify принадлежат Snacks, как и задумано в AstroNvim.

return {
  -- Иконки для файлов и UI
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Snacks патчит vim.ui.input/select только в своём M.setup(), а его
  -- вызывают лишь для уже загруженных модулей. Модули ленивые, поэтому до
  -- первого открытия пикера vim.ui.select оставался дефолтом Neovim — и
  -- например выбор модели на <leader>cm показывал системный inputlist(),
  -- а не пикер Snacks. Форсируем патч на VeryLazy.
  --
  -- dashboard.setup() здесь нужен по той же причине: без него его health
  -- писал «setup did not run» (модуль ленивый и на момент проверки ещё не
  -- загрузился). Экран всё равно открывается на каждом старте, так что
  -- вызов setup() на VeryLazy ничего не меняет, кроме снятия ошибки.
  --
  -- Уведомления: notifier делает всплывающие окна плавающими (style =
  -- "fancy" — плавающий бокс с рамкой, а не строчный компакт). Кеймап
  -- <Leader>uN переключает показ уведомлений: когда выключено, vim.notify
  -- становится no-op, и всплывашки исчезают целиком. Событие AstroCore
  -- features.notifications переключается вместе с ним, чтобы «тихий режим»
  -- был один, а не два разных.
  {
    "folke/snacks.nvim",
    opts = {
      input = { enabled = true },
      picker = { enabled = true, ui_select = true },
      notifier = {
        enabled = true,
        style = "fancy",
        timeout = 4000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 1, right = 1, bottom = 1 },
        padding = true,
        sort = { "level", "added" },
        top_down = true,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          pcall(function()
            require("snacks.input").enable()
            require("snacks.picker").setup()
            require("snacks.dashboard").setup()
          end)

          -- Переключатель уведомлений. Держим ровно ту функцию, которой
          -- Snacks сам владеет vim.notify, чтобы при включённом состоянии
          -- ничего не менялось, а при выключенном показ пропадал.
          local notifier = require("snacks.notifier")
          local snacks_notify = notifier.notify
          local enabled = true
          vim.notify = snacks_notify

          local toggle = require("snacks.toggle")({
            name = "Notifications",
            get = function()
              return enabled
            end,
            set = function(state)
              enabled = state
              vim.notify = state and snacks_notify or function() end
              local ok, astrocore = pcall(require, "astrocore")
              if ok and astrocore.config and astrocore.config.features then
                astrocore.config.features.notifications = state
              end
            end,
            -- Без мета-уведомления «Notifications Disabled»: выключение
            -- уведомлений не должно само показывать уведомление.
            notify = false,
          })
          toggle:map("<Leader>uN", { desc = "Toggle Notifications" })
        end,
      })
    end,
  },
}
