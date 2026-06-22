-- lua/plugins/nvim-updater.lua
-- Обновление Neovim и конфига прямо из редактора.
--
-- Маппинги:
--   <Leader>uu  — Full upgrade (git pull конфига + обновление nvim)
--   <Leader>ug  — Git pull конфига (:AstroUpdate)
--   <Leader>un  — Обновнить Neovim (скачать новый бинарник)
--
-- Команды: :NvimUpdate  :ConfigUpdate  :FullUpgrade

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      commands = {

        -- Обновление бинарника Neovim
        NvimUpdate = {
          function()
            local current = tostring(vim.version())
            local script = table.concat({
              "set -e",
              "echo '━━━ Neovim Binary Updater ━━━'",
              "echo 'Current: " .. current .. "'",
              "TMP=$(mktemp -d)",
              "ARCHIVE=nvim-linux-x86_64.tar.gz",
              "URL=https://github.com/neovim/neovim/releases/latest/download/$ARCHIVE",
              "echo \"Downloading $URL...\"",
              "curl -fL -o $TMP/$ARCHIVE $URL",
              "echo 'Extracting...'",
              "sudo rm -rf /opt/nvim-linux-x86_64",
              "sudo tar -C /opt -xzf $TMP/$ARCHIVE",
              "sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim",
              "rm -rf $TMP",
              "echo ''",
              "NEW=$(/opt/nvim-linux-x86_64/bin/nvim --version | head -1)",
              "echo \"Done! New version: $NEW\"",
              "echo 'Restart Neovim to apply.'",
            }, "\n")
            require("plugins.nvim-updater").open_float(" Neovim Update ", script, "NvimUpdate")
          end,
          desc = "Update Neovim binary to latest stable",
        },

        -- Обновление конфига через git pull
        ConfigUpdate = {
          function()
            local config_path = vim.fn.stdpath("config")
            local script = table.concat({
              "set -e",
              "echo '━━━ Config Git Pull ━━━'",
              "cd " .. config_path,
              "echo \"Path: $PWD\"",
              "git fetch origin",
              "git status --short",
              "git pull --rebase origin $(git branch --show-current)",
              "echo ''",
              "echo '✓ Config updated. Run :Lazy sync to apply plugin changes.'",
            }, "\n")
            require("plugins.nvim-updater").open_float(" Config Update ", script, "ConfigUpdate")
          end,
          desc = "Pull latest config from git",
        },

        -- Полный апгрейд: git pull + обновление nvim
        FullUpgrade = {
          function()
            local config_path = vim.fn.stdpath("config")
            local current = tostring(vim.version())
            local script = table.concat({
              "set -e",
              "echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'",
              "echo '      Full Upgrade'",
              "echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'",
              "",
              "echo ''",
              "echo '[1/2] Pulling config from git...'",
              "cd " .. config_path,
              "git fetch origin",
              "git pull --rebase origin $(git branch --show-current)",
              "echo '✓ Config updated'",
              "",
              "echo ''",
              "echo '[2/2] Updating Neovim binary...'",
              "echo 'Current: " .. current .. "'",
              "TMP=$(mktemp -d)",
              "ARCHIVE=nvim-linux-x86_64.tar.gz",
              "URL=https://github.com/neovim/neovim/releases/latest/download/$ARCHIVE",
              "curl -fL -o $TMP/$ARCHIVE $URL",
              "sudo rm -rf /opt/nvim-linux-x86_64",
              "sudo tar -C /opt -xzf $TMP/$ARCHIVE",
              "sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim",
              "rm -rf $TMP",
              "NEW=$(/opt/nvim-linux-x86_64/bin/nvim --version | head -1)",
              "echo '✓ Neovim updated to: '$NEW",
              "",
              "echo ''",
              "echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'",
              "echo 'Full upgrade complete!'",
              "echo 'Run :Lazy sync then restart Neovim.'",
            }, "\n")
            require("plugins.nvim-updater").open_float(" Full Upgrade ", script, "FullUpgrade")
          end,
          desc = "Full upgrade: git pull config + update Neovim binary",
        },
      },

      mappings = {
        n = {
          -- which-key группа
          ["<Leader>u"] = { desc = " Update" },
          ["<Leader>uu"] = { "<cmd>FullUpgrade<cr>",   desc = "Full upgrade (config + nvim)" },
          ["<Leader>ug"] = { "<cmd>ConfigUpdate<cr>",  desc = "Update config (git pull)" },
          ["<Leader>un"] = { "<cmd>NvimUpdate<cr>",    desc = "Update Neovim binary" },
        },
      },
    },
  },

  -- Локальный Lua-модуль с хелпером для floating terminal
  -- (lazy.nvim не загружает его как плагин, это чистый локальный модуль)
  {
    dir = vim.fn.stdpath("config"),
    name = "nvim-updater-lib",
    lazy = true,
    config = function()
      -- Регистрируем хелпер прямо в package (без подгрузки require)
    end,
  },
}
