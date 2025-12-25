-- Customize Mason

---@type LazySpec
return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "lua-language-server",
      "stylua",
      -- Python tools
      "basedpyright",
      "black",
      "ruff",
      "debugpy",
      -- Tree-sitter
      "tree-sitter-cli",
    },
  },
}
