-- lua/plugins/mason.lua
return {
  -- Дебаггеры (DAP адаптеры)
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
        "python",       -- debugpy
        "bash",         -- bash-debug-adapter
        "go",           -- delve
        "javadbg", "javatest", -- Java
        "codelldb",     -- C++
        "js",           -- js-debug-adapter
      })
      -- Не падать, если не удалось установить
      opts.automatic_installation = false
    end,
  },
  -- Форматтеры и линтеры
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- Python
        "black", "isort",
        -- JSON / YAML / Docker
        "jq", "hadolint",
        -- Bash
        "shellcheck", "shfmt",
        -- Go (устанавливаются автоматически при наличии Go)
        "golangci-lint", "gofumpt", "goimports",
        -- Java
        "google-java-format",
        -- C++
        "cpplint",
        -- JS/TS
        "prettier", "eslint_d",
      },
      -- Автоматически устанавливать при запуске (soft fail - не падать)
      auto_update = false,
      run_on_start = false,
          -- Отключить уведомления и сделать тихий режим
    max_concurrent_installers = 4,
    },
  },
}
