-- SSH менеджер: подключения, файловый браузер, редактирование ~/.ssh/config
--
-- Маппинги (<Leader>S):
--   Sa  — Добавить хост в ~/.ssh/config
--   Sc  — Подключиться (выбрать из списка)
--   Sp  — Подключиться по user@host
--   Sk  — Подключиться по ключу
--   Ss  — Файловый браузер (oil-ssh)
--   Se  — Редактировать ~/.ssh/config

return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    keys = {
      {
        "<Leader>Sa",
        function()
          vim.ui.input({ prompt = "Host алиас (my-server): " }, function(alias)
            if not alias or alias == "" then return end
            vim.ui.input({ prompt = "Hostname (IP или domain): " }, function(hostname)
              if not hostname or hostname == "" then return end
              vim.ui.input({ prompt = "User (root): ", default = "root" }, function(user)
                if not user or user == "" then return end
                vim.ui.input({ prompt = "IdentityFile (~/.ssh/id_rsa): ", default = "~/.ssh/id_rsa" }, function(keypath)
                  local ssh_config = vim.fn.expand("~/.ssh/config")
                  local entry = string.format(
                    "\n\nHost %s\n  HostName %s\n  User %s",
                    alias, hostname, user
                  )
                  if keypath and keypath ~= "" then
                    entry = entry .. string.format("\n  IdentityFile %s", keypath)
                  end
                  local file = io.open(ssh_config, "a")
                  if file then
                    file:write(entry)
                    file:close()
                    vim.notify(string.format("✓ '%s' добавлен в ~/.ssh/config", alias), vim.log.levels.INFO)
                  else
                    vim.notify("Ошибка записи в ~/.ssh/config", vim.log.levels.ERROR)
                  end
                end)
              end)
            end)
          end)
        end,
        desc = "SSH: добавить хост",
      },
      {
        "<Leader>Sc",
        function()
          local ssh_config = vim.fn.expand("~/.ssh/config")
          if vim.fn.filereadable(ssh_config) == 0 then
            vim.notify("~/.ssh/config не найден", vim.log.levels.WARN)
            return
          end
          local hosts = {}
          for line in io.lines(ssh_config) do
            local host = line:match("^%s*Host%s+(.+)$")
            if host and not host:match("[*?]") then
              table.insert(hosts, host)
            end
          end
          if #hosts == 0 then
            vim.notify("Хосты не найдены", vim.log.levels.WARN)
            return
          end
          vim.ui.select(hosts, { prompt = "SSH хост:" }, function(choice)
            if choice then vim.cmd("tabnew | terminal ssh " .. choice) end
          end)
        end,
        desc = "SSH: подключиться (список)",
      },
      {
        "<Leader>Sp",
        function()
          vim.ui.input({ prompt = "SSH адрес (user@host): " }, function(target)
            if target and target ~= "" then
              vim.cmd("tabnew | terminal ssh " .. target)
            end
          end)
        end,
        desc = "SSH: подключиться (user@host)",
      },
      {
        "<Leader>Sk",
        function()
          vim.ui.input({ prompt = "SSH адрес (user@host): " }, function(target)
            if not target or target == "" then return end
            vim.ui.input({ prompt = "Ключ (~/.ssh/id_rsa): ", default = "~/.ssh/id_rsa" }, function(keypath)
              if not keypath or keypath == "" then return end
              vim.cmd("tabnew | terminal ssh -i " .. vim.fn.expand(keypath) .. " " .. target)
            end)
          end)
        end,
        desc = "SSH: подключиться по ключу",
      },
      {
        "<Leader>Ss",
        function()
          local ssh_config = vim.fn.expand("~/.ssh/config")
          if vim.fn.filereadable(ssh_config) == 0 then
            vim.notify("~/.ssh/config не найден", vim.log.levels.WARN)
            return
          end
          local hosts = {}
          for line in io.lines(ssh_config) do
            local host = line:match("^%s*Host%s+(.+)$")
            if host and not host:match("[*?]") then
              table.insert(hosts, host)
            end
          end
          if #hosts == 0 then
            vim.notify("Хосты не найдены", vim.log.levels.WARN)
            return
          end
          vim.ui.select(hosts, { prompt = "SSH хост:" }, function(choice)
            if choice then
              vim.ui.input({ prompt = "Путь (/): ", default = "/" }, function(path)
                if path then vim.cmd("Oil oil-ssh://" .. choice .. path) end
              end)
            end
          end)
        end,
        desc = "SSH: файловый браузер",
      },
      {
        "<Leader>Se",
        function() vim.cmd("edit " .. vim.fn.expand("~/.ssh/config")) end,
        desc = "SSH: редактировать ~/.ssh/config",
      },
    },
    opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true },
      silence_scp_warning = true,
    },
  },
}
