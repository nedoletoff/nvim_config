
-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "css",
      "git_config",
      "git_rebase",
      "gitcommit",
      "html",
      "javascript",
      "json",
      "latex",
      "lua",
      "markdown",
      "markdown_inline",
      "query",
      "regex",
      "scss",
      "svelte",
      "toml",
      "tsx",
      "typst",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
