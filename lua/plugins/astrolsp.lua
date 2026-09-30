-- lua/plugins/astrolsp.lua
-- Настройки LSP. AstroNvim v5 называет этот core-спек "astrolsp",
-- поэтому опции живут здесь, а не в отдельном lspconfig.lua.

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      -- Настройки gopls раздаются на все серверы через vim.lsp.config().
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
        -- Форматирование по BufWritePre через vim.lsp.buf.format().
        -- ВАЖНО: работает только если сервер поддерживает
        -- textDocument/formatting. Список серверов ставит
        -- mason-lspconfig из установленных пакетов, а их конфиги
        -- берутся из nvim-lspconfig (lsp/<server>.lua).
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
