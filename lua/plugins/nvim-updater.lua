-- lua/plugins/nvim-updater.lua
-- Обновление Neovim и конфига прямо из редактора.
--
-- Маппинги:
--   <Leader>UU  — Full upgrade (git pull конфига + обновление nvim)
--   <Leader>Ug  — Обновить конфиг (git pull)
--   <Leader>Un  — Обновить Neovim (скачать новый бинарник)
--
-- Команды: :NvimUpdate  :ConfigUpdate  :FullUpgrade

local function open_float(title, script, cmd_name)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.82)
  local height = math.floor(vim.o.lines * 0.55)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })
  vim.fn.termopen({ "bash", "-c", script }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify(cmd_name .. " completed.", vim.log.levels.INFO, { title = cmd_name })
      else
        vim.notify(cmd_name .. " failed (exit " .. code .. ").", vim.log.levels.ERROR, { title = cmd_name })
      end
    end,
  })
  vim.cmd("startinsert")
end

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      commands = {

        NvimUpdate = {
          function()
            local current = tostring(vim.version())
            local script = table.concat({
              "set -e",
              "echo '━━━ Neovim Binary Update ━━━'",
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
              "NEW=$(/opt/nvim-linux-x86_64/bin/nvim --version | head -1)",
              "echo ''",
              "echo \"✓ Done! New: $NEW\"",
              "echo 'Restart Neovim to apply.'",
            }, "\n")
            open_float("Neovim Update", script, "NvimUpdate")
          end,
          desc = "Update Neovim binary to latest stable",
        },

        ConfigUpdate = {
          function()
            local config_path = vim.fn.stdpath("config")
            local script = table.concat({
              "set -e",
              "echo '━━━ Config Git Pull ━━━'",
              "cd " .. vim.fn.shellescape(config_path),
              "echo \"Path: $PWD\"",
              "git fetch origin",
              "git status --short",
              "git pull --rebase origin $(git branch --show-current)",
              "echo ''",
              "echo '✓ Config updated.'",
              "echo 'Run :Lazy sync to apply plugin changes.'",
            }, "\n")
            open_float("Config Update", script, "ConfigUpdate")
          end,
          desc = "Pull latest nvim config from git",
        },

        FullUpgrade = {
          function()
            local config_path = vim.fn.stdpath("config")
            local current = tostring(vim.version())
            local script = table.concat({
              "set -e",
              "echo '━━━━━━━━━━━━ Full Upgrade ━━━━━━━━━━━━'",
              "",
              "echo '[1/2] Pulling config...'",
              "cd " .. vim.fn.shellescape(config_path),
              "git fetch origin",
              "git pull --rebase origin $(git branch --show-current)",
              "echo '✓ Config updated'",
              "",
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
              "echo '✓ Neovim: '$NEW",
              "",
              "echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'",
              "echo 'Full upgrade complete!'",
              "echo 'Run :Lazy sync then restart Neovim.'",
            }, "\n")
            open_float("Full Upgrade", script, "FullUpgrade")
          end,
          desc = "Full upgrade: git pull config + update Neovim binary",
        },
      },

      mappings = {
        n = {
          ["<Leader>U"]  = { desc = " Update" },
          ["<Leader>UU"] = { "<cmd>FullUpgrade<cr>",  desc = "Full upgrade (config + nvim)" },
          ["<Leader>Ug"] = { "<cmd>ConfigUpdate<cr>", desc = "Update config (git pull)" },
          ["<Leader>Un"] = { "<cmd>NvimUpdate<cr>",   desc = "Update Neovim binary" },
        },
      },
    },
  },
}
