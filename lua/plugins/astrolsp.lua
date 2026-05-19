-- lua/plugins/astrolsp.lua
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- НЕ указываем список servers явно!
    -- Community packs (astrocommunity.lua) автоматически установят нужные LSP
    -- Это позволяет конфигу работать даже если не все инструменты установлены

    -- Настройка отдельных LSP-серверов (только для тех, что уже установлены)
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
