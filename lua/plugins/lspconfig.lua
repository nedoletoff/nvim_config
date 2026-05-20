-- Customize LSP configuration

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      -- Configuration for built-in LSP handlers
      config = {
        -- Handlers will be set up by mason-lspconfig
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- Handlers will be configured by GetIDE system
      handlers = {
        -- Default handler for all servers
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
      },
    },
  },
}
