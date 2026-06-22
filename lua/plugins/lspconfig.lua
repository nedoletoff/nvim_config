-- lua/plugins/lspconfig.lua
-- Neovim 0.11+ использует vim.lsp.config() напрямую, без nvim-lspconfig.
-- mason-lspconfig v2 автоматически вызывает vim.lsp.enable() для установленных серверов.

---@type LazySpec
return {
  -- Отключаем устаревший nvim-lspconfig framework
  { "neovim/nvim-lspconfig", enabled = false },

  -- Гоплс-настройки через astrolsp → vim.lsp.config()
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true, shadow = true },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      },
      formatting = {
        format_on_save = {
          enabled = true,
          allow_filetypes = {
            "python", "json", "dockerfile", "yaml", "sh",
            "go", "java", "cpp", "javascript", "typescript", "lua",
          },
        },
        timeout_ms = 3000,
      },
    },
  },
}
