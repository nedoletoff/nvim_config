-- SSH менеджер
-- Группа <Leader>S зарегистрирована в astrocore.lua (через desc)
-- Не пересекается с AstroNvim Session (<Leader>S без буквы)
--
-- <Leader>Sa — Добавить хост в ~/.ssh/config
-- <Leader>Sc — Подключиться (выбрать из списка)
-- <Leader>Sp — Подключиться (user@host)
-- <Leader>Sk — Подключиться по ключу
-- <Leader>Ss — Файловый браузер (oil-ssh)
-- <Leader>Se — Редактировать ~/.ssh/config

return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    keys = {
      {
        "<Leader>Sa",
        function()
          vim.ui.input({ prompt = "Host алиас: " }, function(alias)
            if not alias or alias == "" then return end
            vim.ui.input({ prompt = "Hostname: " }, function(hostname)
              if not hostname or hostname == "" then return end
              vim.ui.input({ prompt = "User: ", default = "root" }, function(user)
                if not user or user == "" then return end
                vim.ui.input({ prompt = "IdentityFile: ", default = "~/.ssh/id_rsa" }, function(keypath)
                  local ssh_config = vim.fn.expand("~/.ssh/config")
                  local entry = string.format("\n\nHost %s\n  HostName %s\n  User %s", alias, hostname, user)
                  if keypath and keypath ~= "" then
                    entry = entry .. string.format("\n  IdentityFile %s", keypath)
                  end
                  local file = io.open(ssh_config, "a")
                  if file then
                    file:write(entry)
                    file:close()
                    vim.notify("✓ '" .. alias .. "' добавлен в ~/.ssh/config", vim.log.levels.INFO)
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
          local hosts = {}
          local f = io.open(vim.fn.expand("~/.ssh/config"), "r")
          if not f then vim.notify("~/.ssh/config не найден", vim.log.levels.WARN); return end
          for line in f:lines() do
            local h = line:match("^%s*Host%s+(.+)$")
            if h and not h:match("[*?]") then table.insert(hosts, h) end
          end
          f:close()
          if #hosts == 0 then vim.notify("Хосты не найдены", vim.log.levels.WARN); return end
          vim.ui.select(hosts, { prompt = "SSH хост:" }, function(choice)
            if choice then vim.cmd("tabnew | terminal ssh " .. choice) end
          end)
        end,
        desc = "SSH: подключиться (список)",
      },
      {
        "<Leader>Sp",
        function()
          vim.ui.input({ prompt = "user@host: " }, function(t)
            if t and t ~= "" then vim.cmd("tabnew | terminal ssh " .. t) end
          end)
        end,
        desc = "SSH: подключиться (user@host)",
      },
      {
        "<Leader>Sk",
        function()
          vim.ui.input({ prompt = "user@host: " }, function(target)
            if not target or target == "" then return end
            vim.ui.input({ prompt = "Ключ: ", default = "~/.ssh/id_rsa" }, function(key)
              if not key or key == "" then return end
              vim.cmd("tabnew | terminal ssh -i " .. vim.fn.expand(key) .. " " .. target)
            end)
          end)
        end,
        desc = "SSH: подключиться по ключу",
      },
      {
        "<Leader>Ss",
        function()
          local hosts = {}
          local f = io.open(vim.fn.expand("~/.ssh/config"), "r")
          if not f then vim.notify("~/.ssh/config не найден", vim.log.levels.WARN); return end
          for line in f:lines() do
            local h = line:match("^%s*Host%s+(.+)$")
            if h and not h:match("[*?]") then table.insert(hosts, h) end
          end
          f:close()
          if #hosts == 0 then vim.notify("Хосты не найдены", vim.log.levels.WARN); return end
          vim.ui.select(hosts, { prompt = "SSH хост:" }, function(choice)
            if choice then
              vim.ui.input({ prompt = "Путь (/): ", default = "/" }, function(path)
                if path then vim.cmd("Oil oil-ssh://" .. choice .. path) end
              end)
            end
          end)
        end,
        desc = "SSH: файловый браузер (oil-ssh)",
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
