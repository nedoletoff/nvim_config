-- lua/plugins/lspconfig.lua
-- Единый конфиг для astrolsp + mason-lspconfig v2+
-- (объединён с astrolsp.lua во избежание дублирования плагина)

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      config = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
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
            "python",
            "json",
            "dockerfile",
            "yaml",
            "sh",
            "go",
            "java",
            "cpp",
            "javascript",
            "typescript",
            "lua",
          },
        },
        timeout_ms = 3000,
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- automatic_enable = true by default in v2
    },
  },
}
