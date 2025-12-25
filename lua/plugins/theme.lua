return {
  -- Основная тема: Darcula (как в PyCharm)
  {
    "doums/darcula.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("darcula")
    end,
  },
  -- Дополнительная тема: Monokai (на выбор)
  {
    "tanvirtin/monokai.nvim",
    lazy = true,
  },
}
