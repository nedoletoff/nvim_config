-- lua/plugins/lspconfig.lua
-- LSP configuration for mason-lspconfig v2+ (Neovim 0.11+)
-- handlers/setup() API removed; mason-lspconfig now uses automatic_enable
-- Server configs go via astrolsp opts.config -> vim.lsp.config()

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      -- Server-specific settings are configured here.
      -- astrolsp passes them to vim.lsp.config() automatically.
      config = {
        -- Example: per-server overrides (add as needed)
        -- lua_ls = {
        --   settings = { Lua = { diagnostics = { globals = { "vim" } } } },
        -- },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- automatic_enable = true by default in v2:
      -- automatically calls vim.lsp.enable() for every installed server.
      -- No handlers needed anymore.
    },
  },
}
