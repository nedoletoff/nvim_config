-- GetIDE: Smart language-specific IDE setup system
-- Usage: :GetIDE install <language>
-- Example: :GetIDE install go

return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    -- Language profiles with LSP, linters, formatters, and tools
    local language_profiles = {
      go = {
        name = "Go",
        lsp = { "gopls" },
        tools = { "goimports", "gofumpt", "gomodifytags", "impl", "delve" },
        dap = { "delve" },
        treesitter = { "go", "gomod", "gowork", "gosum" },
        description = "Go: gopls + goimports + gofumpt + debugging",
      },
      python = {
        name = "Python",
        lsp = { "pyright", "ruff" },
        tools = { "black", "isort", "debugpy" },
        dap = { "debugpy" },
        treesitter = { "python" },
        description = "Python: pyright + ruff + black + debugpy",
      },
      rust = {
        name = "Rust",
        lsp = { "rust_analyzer" },
        tools = { "rustfmt", "clippy" },
        dap = { "codelldb" },
        treesitter = { "rust", "toml" },
        description = "Rust: rust-analyzer + rustfmt + clippy",
      },
      lua = {
        name = "Lua",
        lsp = { "lua_ls" },
        tools = { "stylua" },
        treesitter = { "lua", "luadoc" },
        description = "Lua: lua_ls + stylua",
      },
      typescript = {
        name = "TypeScript/JavaScript",
        lsp = { "ts_ls", "eslint" },
        tools = { "prettier", "eslint_d" },
        treesitter = { "typescript", "tsx", "javascript" },
        description = "TS/JS: ts_ls + eslint + prettier",
      },
      cpp = {
        name = "C/C++",
        lsp = { "clangd" },
        tools = { "clang-format" },
        dap = { "codelldb" },
        treesitter = { "c", "cpp" },
        description = "C/C++: clangd + clang-format + debugging",
      },
      docker = {
        name = "Docker",
        lsp = { "dockerls", "docker_compose_language_service" },
        tools = { "hadolint" },
        treesitter = { "dockerfile" },
        description = "Docker: dockerls + hadolint",
      },
      yaml = {
        name = "YAML",
        lsp = { "yamlls" },
        tools = { "yamllint" },
        treesitter = { "yaml" },
        description = "YAML: yamlls + yamllint",
      },
      json = {
        name = "JSON",
        lsp = { "jsonls" },
        treesitter = { "json", "jsonc" },
        description = "JSON: jsonls",
      },
      html = {
        name = "HTML/CSS",
        lsp = { "html", "cssls", "tailwindcss" },
        tools = { "prettier" },
        treesitter = { "html", "css" },
        description = "HTML/CSS: html + cssls + prettier",
      },
      bash = {
        name = "Bash/Shell",
        lsp = { "bashls" },
        tools = { "shfmt", "shellcheck" },
        treesitter = { "bash" },
        description = "Bash: bashls + shellcheck + shfmt",
      },
    }

    -- Helper function to install Mason packages
    local function install_mason_packages(packages)
      local mason_registry = require("mason-registry")
      local notify = vim.notify

      local installed = 0
      local failed = 0
      local skipped = 0

      for _, pkg_name in ipairs(packages) do
        local pkg = mason_registry.get_package(pkg_name)
        if pkg then
          if not pkg:is_installed() then
            notify("Installing " .. pkg_name .. "...", vim.log.levels.INFO)
            pkg:install():once(
              "closed",
              vim.schedule_wrap(function()
                if pkg:is_installed() then
                  installed = installed + 1
                  notify("✓ " .. pkg_name .. " installed", vim.log.levels.INFO)
                else
                  failed = failed + 1
                  notify("✗ Failed to install " .. pkg_name, vim.log.levels.ERROR)
                end
              end)
            )
          else
            skipped = skipped + 1
          end
        else
          notify("Package not found: " .. pkg_name, vim.log.levels.WARN)
          failed = failed + 1
        end
      end

      vim.defer_fn(function()
        local msg = string.format(
          "GetIDE: ✓ %d installed, ↷ %d skipped, ✗ %d failed",
          installed,
          skipped,
          failed
        )
        notify(msg, installed > 0 and vim.log.levels.INFO or vim.log.levels.WARN)
      end, 1000)
    end

    -- Helper to install treesitter parsers
    local function install_treesitter_parsers(parsers)
      vim.cmd("TSInstall " .. table.concat(parsers, " "))
    end

    -- Main GetIDE command
    local function setup_getide(lang)
      local profile = language_profiles[lang]
      if not profile then
        local available = vim.tbl_keys(language_profiles)
        table.sort(available)
        vim.notify(
          "Unknown language: " .. lang .. "\n\nAvailable: " .. table.concat(available, ", "),
          vim.log.levels.ERROR
        )
        return
      end

      vim.notify(
        "GetIDE: Setting up " .. profile.name .. " IDE\n" .. profile.description,
        vim.log.levels.INFO
      )

      -- Collect all Mason packages (LSP + tools + DAP)
      local all_packages = {}
      vim.list_extend(all_packages, profile.lsp or {})
      vim.list_extend(all_packages, profile.tools or {})
      vim.list_extend(all_packages, profile.dap or {})

      -- Install packages
      install_mason_packages(all_packages)

      -- Install treesitter parsers
      if profile.treesitter then
        install_treesitter_parsers(profile.treesitter)
      end
    end

    -- List all available languages
    local function list_languages()
      local langs = {}
      for lang, profile in pairs(language_profiles) do
        table.insert(langs, { lang = lang, desc = profile.description })
      end
      table.sort(langs, function(a, b)
        return a.lang < b.lang
      end)

      local lines = { "GetIDE: Available language profiles:\n" }
      for _, item in ipairs(langs) do
        table.insert(lines, string.format("  • %s: %s", item.lang, item.desc))
      end
      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    end

    -- Register GetIDE command
    vim.api.nvim_create_user_command("GetIDE", function(cmd_opts)
      local args = vim.split(cmd_opts.args, " ", { trimempty = true })
      local action = args[1]
      local lang = args[2]

      if action == "install" and lang then
        setup_getide(lang)
      elseif action == "list" or not action then
        list_languages()
      else
        vim.notify(
          "Usage: :GetIDE install <language> | :GetIDE list",
          vim.log.levels.ERROR
        )
      end
    end, {
      nargs = "*",
      desc = "Install language-specific IDE setup",
      complete = function(_, line)
        local args = vim.split(line, " ", { trimempty = true })
        if #args == 2 then
          return { "install", "list" }
        elseif #args == 3 and args[2] == "install" then
          return vim.tbl_keys(language_profiles)
        end
        return {}
      end,
    })

    return opts
  end,
}
