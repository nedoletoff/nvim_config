-- Git расширенные инструменты
-- diffview.nvim  — diff, история файлов
-- neogit         — magit-подобный git-клиент
--
-- Маппинги (<Leader>g):
--   gd  — diff текущего файла
--   gD  — diff всего проекта
--   gh  — история файла
--   gH  — история репо
--   gq  — закрыть diffview
--   gg  — открыть neogit

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
        desc = "Git: diff файла",
      },
      { "<Leader>gD", "<cmd>DiffviewOpen<cr>",        desc = "Git: diff проекта" },
      {
        "<Leader>gh",
        function() vim.cmd("DiffviewFileHistory " .. vim.fn.expand("%")) end,
        desc = "Git: история файла",
      },
      { "<Leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Git: история репо" },
      { "<Leader>gq", "<cmd>DiffviewClose<cr>",       desc = "Git: закрыть diffview" },
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
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = "Neogit",
    keys = {
      { "<Leader>gg", "<cmd>Neogit<cr>", desc = "Git: открыть neogit" },
    },
    opts = {
      integrations = { diffview = true },
      graph_style = "unicode",
    },
  },
}
