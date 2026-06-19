-- Git extended tools
-- diffview.nvim  - diff viewer, file history
-- neogit         - magit-like git client
--
-- Keybindings:
--   <Leader>gd  - diff текущего файла (vs HEAD)
--   <Leader>gD  - diff всего проекта (все изменённые файлы)
--   <Leader>gh  - история текущего файла
--   <Leader>gH  - история всего репо
--   <Leader>gc  - закрыть diffview
--   <Leader>gg  - открыть neogit

---@type LazySpec
return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      {
        "<Leader>gd",
        function() vim.cmd("DiffviewOpen HEAD -- " .. vim.fn.expand("%")) end,
        desc = "Git: diff текущего файла",
      },
      {
        "<Leader>gD",
        "<cmd>DiffviewOpen<cr>",
        desc = "Git: diff всего проекта",
      },
      {
        "<Leader>gh",
        function() vim.cmd("DiffviewFileHistory " .. vim.fn.expand("%")) end,
        desc = "Git: история файла",
      },
      {
        "<Leader>gH",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "Git: история репо",
      },
      {
        "<Leader>gc",
        "<cmd>DiffviewClose<cr>",
        desc = "Git: закрыть diffview",
      },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        file_history = { layout = "diff2_horizontal" },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = { flatten_dirs = true },
        win_config = { width = 35 },
      },
    },
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    keys = {
      {
        "<Leader>gg",
        "<cmd>Neogit<cr>",
        desc = "Git: открыть neogit",
      },
    },
    opts = {
      integrations = { diffview = true },
      graph_style = "unicode",
    },
  },
}
