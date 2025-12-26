return {
  -- Красивые диалоги и input для LSP
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        border = "rounded",
        title_pos = "left",
      },
      select = {
        enabled = true,
        backend = { "telescope" },
      },
    },
  },

  -- Иконки для файлов и UI
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Красивые уведомления
  {
    "rcarriga/nvim-notify",
    lazy = true,
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
      vim.notify = require("notify")
    end,
  },
}
