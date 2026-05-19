-- lua/plugins/astrolsp.lua
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Список LSP-серверов для автозапуска
    servers = {
      "pyright",
      "ruff",
      "lua_ls",
      "jsonls",
      "dockerls",
      "yamlls",
      "helm_ls",
      "bashls",
      "gopls",
      "jdtls",
      "clangd",
      "ts_ls", -- Актуальное название вместо tsserver для JS/TS
    },

    -- Настройка отдельных LSP-серверов
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
            -- Говорим gopls использовать goimports как форматтер -- это устраняет ошибку failed to install
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

    -- Настройка форматирования
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
}
