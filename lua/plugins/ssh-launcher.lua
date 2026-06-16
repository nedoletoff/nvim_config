return {
  -- ===== Удалённая работа по SSH =====
  --
  -- 1. Работа с файлами (oil.nvim через oil-ssh://): просматривай и редактируй
  --    удалённые файлы как буфер (аналог WinSCP). Поддерживает ключи и пароль.
  --    Маппинги: <leader>ss (SSH браузер), <leader>sc (выбрать из ~/.ssh/config)
  --
  -- 2. Терминал:
  --    <leader>st — по паролю  (ssh user@host)
  --    <leader>sk — по ключу   (ssh -i ~/path/to/key user@host)
  --
  -- 3. Редактирование:
  --    <leader>se — открыть ~/.ssh/config для редактирования
  --
  -- Хранение подключений: ~/.ssh/config (стандартный формат, читается всеми SSH-утилитами)
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    keys = {
      -- Браузер файлов по SSH (запрашивает user@host вручную)
      {
        "<leader>ss",
        function()
          vim.ui.input({ prompt = "SSH адрес (user@host:/path): " }, function(target)
            if target and target ~= "" then
              vim.cmd("Oil oil-ssh://" .. target)
            end
          end)
        end,
        desc = "SSH: браузер файлов (oil-ssh)",
      },
      -- Выбор из сохранённых хостов из ~/.ssh/config
      {
        "<leader>sc",
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
            vim.notify("В ~/.ssh/config не найдено хостов", vim.log.levels.WARN)
            return
          end

          vim.ui.select(hosts, {
            prompt = "Выберите SSH хост:",
          }, function(choice)
            if choice then
              vim.ui.input({ prompt = "Путь на сервере (/): ", default = "/" }, function(path)
                if path then
                  vim.cmd("Oil oil-ssh://" .. choice .. path)
                end
              end)
            end
          end)
        end,
        desc = "SSH: выбрать хост из ~/.ssh/config",
      },
      -- Редактировать ~/.ssh/config
      {
        "<leader>se",
        function()
          vim.cmd("edit " .. vim.fn.expand("~/.ssh/config"))
        end,
        desc = "SSH: редактировать ~/.ssh/config",
      },
      -- Терминал по паролю
      {
        "<leader>st",
        function()
          vim.ui.input({ prompt = "SSH адрес (user@host): " }, function(target)
            if target and target ~= "" then
              vim.cmd("tabnew | terminal ssh " .. target)
            end
          end)
        end,
        desc = "SSH: открыть терминал по паролю",
      },
      -- Терминал по ключу
      {
        "<leader>sk",
        function()
          vim.ui.input({ prompt = "SSH адрес (user@host): " }, function(target)
            if not target or target == "" then return end
            vim.ui.input({
              prompt = "Путь к ключу (~/.ssh/id_rsa): ",
              default = "~/.ssh/id_rsa",
            }, function(keypath)
              if not keypath or keypath == "" then return end
              local expanded = vim.fn.expand(keypath)
              vim.cmd("tabnew | terminal ssh -i " .. expanded .. " " .. target)
            end)
          end)
        end,
        desc = "SSH: открыть терминал по ключу",
      },
    },
    opts = {
      -- oil заменяет netrw для открытия директорий
      default_file_explorer = true,
      -- Показывать скрытые файлы
      view_options = {
        show_hidden = true,
      },
      -- Отключить предупреждение про netrw scp (oil-ssh заменяет)
      silence_scp_warning = true,
    },
  },
}
