-- Full IDE configuration for Python development
-- Includes: LSP, diagnostics, formatting, linting, symbols, todos, trouble

return {
  -- Better diagnostics panel
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    config = function()
      require("trouble").setup({
        auto_open = false,
        auto_preview = true,
      })
    end,
  },
  -- Symbol outline (structure)
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = function()
      require("symbols-outline").setup()
    end,
  },
  -- Breadcrumb navigation
  {
    "SmiteshP/nvim-navic",
    config = function()
      require("nvim-navic").setup({
        icons = {
          File = " ",
          Module = " ",
          Namespace = " ",
          Package = " ",
          Class = " ",
          Method = " ",
          Property = " ",
          Field = " ",
          Constructor = " ",
          Enum = " ",
          Interface = " ",
          Function = " ",
          Variable = " ",
          Constant = " ",
          String = " ",
          Number = " ",
          Boolean = " ",
          Array = " ",
          Object = " ",
          Key = " ",
          Null = " ",
          EnumMember = " ",
          Struct = " ",
          Event = " ",
          Operator = " ",
          TypeParameter = " ",
        },
      })
    end,
  },
  -- Todo comments
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({
        highlight = {
          multiline = true,
        },
      })
    end,
  },
  -- Git integration (show diffs inline)
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "right_align",
        },
      })
    end,
  },
}
