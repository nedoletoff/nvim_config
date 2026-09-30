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
  {
    "folke/snacks.nvim",
    opts = {
      input = { enabled = true },
      picker = { enabled = true, ui_select = true },
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
        end,
      })
    end,
  },
}
