-- lua/plugins/mason.lua
return {
  -- Дебаггеры (DAP адаптеры)
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "python",                          -- debugpy
        "bash",                            -- bash-debug-adapter
        "go",                              -- delve
        "javadbg", "javatest",             -- Java
        "codelldb",                        -- C++
        "js",                              -- js-debug-adapter
      })
    end,
  },
  -- Форматеры и линтеры (устанавливаются через mason напрямую)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
        -- Python
        "black", "isort",
        -- JSON / YAML / Docker
        "jq", "hadolint",
        -- Bash
        "shellcheck", "shfmt",
        -- Go (goimports отдельно, т.к. не покрыт pack.go через mason-tool-installer)
        "golangci-lint", "gofumpt", "goimports",
        -- Java
        "google-java-format",
        -- C++
        "cpplint",
        -- JS/TS
        "prettier", "eslint_d",
      })
    end,
  },
}
