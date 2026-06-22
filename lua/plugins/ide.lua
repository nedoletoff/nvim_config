-- Full IDE configuration
-- Includes: diagnostics, symbols, todos, blame

return {
  -- aerial.nvim отключён: использует устаревший treesitter node API (node:start(), node:type())
  -- который убрали в Neovim 0.11+. Symbol outline работает через hedyhli/outline.nvim.
  { "stevearc/aerial.nvim", enabled = false },

  -- Панель диагностики (trouble.nvim v3)
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    keys = {
      { "<Leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (project)" },
      { "<Leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<Leader>xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List" },
      { "<Leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List" },
    },
    opts = { auto_close = true, auto_preview = true },
  },

  -- Дерево символов — замена aerial (hedyhli/outline.nvim работает через LSP)
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<Leader>O", "<cmd>Outline<cr>", desc = "Toggle Outline" },
    },
    opts = {},
  },

  -- Хлебные крошки (breadcrumbs)
  {
    "SmiteshP/nvim-navic",
    config = function()
      require("nvim-navic").setup({
        icons = {
          File = " ", Module = " ", Namespace = " ", Package = " ",
          Class = " ", Method = " ", Property = " ", Field = " ",
          Constructor = " ", Enum = " ", Interface = " ", Function = " ",
          Variable = " ", Constant = " ", String = " ", Number = " ",
          Boolean = " ", Array = " ", Object = " ", Key = " ",
          Null = " ", EnumMember = " ", Struct = " ", Event = " ",
          Operator = " ", TypeParameter = " ",
        },
      })
    end,
  },

  -- TODO-комментарии
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    opts = { highlight = { multiline = true } },
  },

  -- Git blame + hunk signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = { virt_text = true, virt_text_pos = "right_align" },
    },
  },
}
