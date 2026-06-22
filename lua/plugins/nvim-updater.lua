-- lua/plugins/nvim-updater.lua
-- Обновление Neovim прямо из редактора.
-- Скачивает последний релиз с GitHub и заменяет /opt/nvim-linux-x86_64.
-- Команда: :NvimUpdate
-- Клавиша: <Leader>U

---@type LazySpec
return {
  {
    -- Без внешнего плагина — через встроенный astrocore
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      commands = {
        NvimUpdate = {
          function()
            local current = tostring(vim.version())
            -- Запускаем обновление в фоновом терминале
            local script = table.concat({
              "set -e",
              "echo '=== Neovim updater ==='",
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
              "echo 'Done! Restart Neovim to use the new version.'",
            }, "\n")

            -- Открываем floating terminal
            local buf = vim.api.nvim_create_buf(false, true)
            local width = math.floor(vim.o.columns * 0.8)
            local height = math.floor(vim.o.lines * 0.5)
            vim.api.nvim_open_win(buf, true, {
              relative = "editor",
              width = width,
              height = height,
              col = math.floor((vim.o.columns - width) / 2),
              row = math.floor((vim.o.lines - height) / 2),
              style = "minimal",
              border = "rounded",
              title = " Neovim Updater ",
              title_pos = "center",
            })

            vim.fn.termopen({ "bash", "-c", script }, {
              on_exit = function(_, code)
                if code == 0 then
                  vim.notify(
                    "Neovim updated successfully! Restart to apply.",
                    vim.log.levels.INFO,
                    { title = "NvimUpdate" }
                  )
                else
                  vim.notify(
                    "Update failed (exit code " .. code .. ").",
                    vim.log.levels.ERROR,
                    { title = "NvimUpdate" }
                  )
                end
              end,
            })

            vim.cmd("startinsert")
          end,
          desc = "Update Neovim to latest stable release",
        },
      },
      mappings = {
        n = {
          ["<Leader>U"] = {
            function() vim.cmd("NvimUpdate") end,
            desc = "Update Neovim",
          },
        },
      },
    },
  },
}
