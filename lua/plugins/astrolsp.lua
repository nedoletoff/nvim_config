-- lua/plugins/astrolsp.lua
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Список серверов для автозапуска
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
    
    -- Настройка форматирования
    formatting = {
      format_on_save = {
        enabled = true, -- Включаем автоформатирование при сохранении
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
          "lua"
        },
      },
      timeout_ms = 3000, -- Увеличиваем таймаут для тяжелых форматеров (например, Java)
    },
  },
}
