-- lua/plugins/mason.lua
return {
  -- Форматеры и линтеры
  {
    "jay-babu/mason-null-ls.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "black", "isort",              -- Python
        "jq",                          -- JSON
        "hadolint",                    -- Docker
        "shellcheck", "shfmt",         -- Bash
        "golangci-lint", "gofumpt",    -- Go
        "google-java-format",          -- Java
        "cpplint",                     -- C++
        "prettier", "eslint_d",        -- JS/TS
      })
    end,
  },
  -- Дебаггеры
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "python",                      -- debugpy
        "bash",                        -- bash-debug-adapter
        "go",                          -- delve
        "javadbg", "javatest",         -- Java
        "codelldb",                    -- C++
        "js",                          -- js-debug-adapter
      })
    end,
  },
}
