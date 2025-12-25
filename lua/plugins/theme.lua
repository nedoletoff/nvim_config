return {
  -- Основная тема: Monokai
  {
    "tanvirtin/monokai.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("monokai")
    end,
  },
  -- Gruvbox - вкусная и выразительная
  {
    "morhetz/gruvbox",
    lazy = true,
    priority = 900,
  },
  -- Nord - минималистная холодная палитра
  {
    "arcticicestudio/nord-vim",
    lazy = true,
    priority = 800,
  },
  -- Kanagawa - японские эстетика
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 700,
  },
}
