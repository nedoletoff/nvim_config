-- lua/plugins/mason.lua
return {
  -- mason добавляет свой каталог bin в $PATH внутри setup(). Плагин же
  -- lazy-loaded, и до его загрузки PATH остаётся прежним — тогда gopls,
  -- bash-language-server и прочие серверы не находятся, LSP не стартует
  -- молча, а format_on_save ничего не делает.
  --
  -- Поэтому mason загружается при старте: config/lazy=false. Это не
  -- сколько-нибудь тяжёлый плагин, зато PATH корректен к моменту, когда
  -- astrolsp попытается поднять сервер.
  {
    "mason-org/mason.nvim",
    lazy = false,
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  -- Дебаггеры (DAP адаптеры)
  --
  -- Имена — это пакеты mason, а не языки nvim-dap. Раньше здесь стояли
  -- "python"/"go"/"js", которых в реестре mason нет вообще, поэтому
  -- ensure_installed молча ничего не ставил. Проверено по списку из
  -- mason-registry: debugpy, delve, js-debug-adapter и т.д.
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed or {}, {
        "debugpy",                -- Python
        "bash-debug-adapter",     -- Bash
        "delve",                  -- Go
        "java-debug-adapter",     -- Java (jdtls)
        "java-test",              -- Java
        "codelldb",               -- C/C++
        "js-debug-adapter",       -- JavaScript/TypeScript
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
        "black", "isort", "ruff", "basedpyright",
        -- JSON / YAML / Docker
        "jq", "hadolint",
        -- Bash
        "shellcheck", "shfmt",
        -- Go
        "golangci-lint", "gofumpt", "goimports",
        -- Java
        "google-java-format",
        -- C++
        "cpplint",
        -- JS/TS
        "prettier", "eslint_d",
        -- Lua
        "stylua", "selene",
      },
      auto_update = false,
      -- run_on_start = false означал, что на свежей машине не ставилось
      -- ничего: ensure_installed просто игнорировался. Включаем — плагин
      -- ставит только недостающее и не падает при ошибке сети.
      -- Ручной прогон остаётся доступен: :DepsInstall / :DepsStatus.
      run_on_start = true,
      max_concurrent_installers = 4,
    },
  },
}
