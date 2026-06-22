-- GetIDE: Smart language-specific IDE setup system
-- Usage: :GetIDE install <language>
-- Example: :GetIDE install go

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      -- GetIDE command зарегистрирован здесь через astrocore commands table
      -- (не через opts function, чтобы не конфликтовать с другими spec-ами)
      autocmds = {
        GetIDESetup = {
          {
            event = "VimEnter",
            callback = function()
              -- Language profiles
              local language_profiles = {
                go = {
                  name = "Go",
                  lsp = { "gopls" },
                  tools = { "goimports", "gofumpt", "gomodifytags", "impl", "delve" },
                  treesitter = { "go", "gomod", "gowork", "gosum" },
                  description = "Go: gopls + goimports + gofumpt + debugging",
                },
                python = {
                  name = "Python",
                  lsp = { "pyright", "ruff" },
                  tools = { "black", "isort", "debugpy" },
                  treesitter = { "python" },
                  description = "Python: pyright + ruff + black + debugpy",
                },
                rust = {
                  name = "Rust",
                  lsp = { "rust_analyzer" },
                  tools = { "rustfmt" },
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
                bash = {
                  name = "Bash/Shell",
                  lsp = { "bashls" },
                  tools = { "shfmt", "shellcheck" },
                  treesitter = { "bash" },
                  description = "Bash: bashls + shellcheck + shfmt",
                },
              }

              local function install_mason_packages(packages)
                local ok, mason_registry = pcall(require, "mason-registry")
                if not ok then
                  vim.notify("mason-registry not available", vim.log.levels.WARN)
                  return
                end
                for _, pkg_name in ipairs(packages) do
                  local ok2, pkg = pcall(function() return mason_registry.get_package(pkg_name) end)
                  if ok2 and pkg then
                    if not pkg:is_installed() then
                      vim.notify("Installing " .. pkg_name .. "...", vim.log.levels.INFO)
                      pkg:install():once(
                        "closed",
                        vim.schedule_wrap(function()
                          if pkg:is_installed() then
                            vim.notify("✓ " .. pkg_name, vim.log.levels.INFO)
                          else
                            vim.notify("✗ Failed: " .. pkg_name, vim.log.levels.ERROR)
                          end
                        end)
                      )
                    end
                  else
                    vim.notify("Package not found: " .. pkg_name, vim.log.levels.WARN)
                  end
                end
              end

              local function setup_getide(lang)
                local profile = language_profiles[lang]
                if not profile then
                  local available = vim.tbl_keys(language_profiles)
                  table.sort(available)
                  vim.notify(
                    "Unknown language: " .. lang .. "\nAvailable: " .. table.concat(available, ", "),
                    vim.log.levels.ERROR
                  )
                  return
                end
                vim.notify("GetIDE: Setting up " .. profile.name, vim.log.levels.INFO)
                local pkgs = {}
                vim.list_extend(pkgs, profile.lsp or {})
                vim.list_extend(pkgs, profile.tools or {})
                vim.list_extend(pkgs, profile.dap or {})
                install_mason_packages(pkgs)
                if profile.treesitter then
                  vim.cmd("TSInstall " .. table.concat(profile.treesitter, " "))
                end
              end

              local function list_languages()
                local langs = {}
                for lang, p in pairs(language_profiles) do
                  table.insert(langs, "  • " .. lang .. ": " .. p.description)
                end
                table.sort(langs)
                vim.notify("GetIDE profiles:\n" .. table.concat(langs, "\n"), vim.log.levels.INFO)
              end

              vim.api.nvim_create_user_command("GetIDE", function(cmd_opts)
                local args = vim.split(cmd_opts.args, " ", { trimempty = true })
                local action = args[1]
                local lang = args[2]
                if action == "install" and lang then
                  setup_getide(lang)
                elseif action == "list" or not action then
                  list_languages()
                else
                  vim.notify("Usage: :GetIDE install <lang> | :GetIDE list", vim.log.levels.ERROR)
                end
              end, {
                nargs = "*",
                desc = "Install language-specific IDE setup",
                complete = function(_, line)
                  local args = vim.split(line, " ", { trimempty = true })
                  if #args == 2 then return { "install", "list" } end
                  if #args == 3 and args[2] == "install" then
                    return vim.tbl_keys(language_profiles)
                  end
                  return {}
                end,
              })
            end,
          },
        },
      },
    },
  },
}
