return {
  -- ===== Удалённая работа по SSH — две задачи: =====
  --
  -- 1. Работа с файлами (remote-sshfs): монтирует файловую систему через SSHFS,
  --    файлы открываются как локальные, поддерживает ключи и пароль.
  --    Маппинги: <leader>ss / sd / se / sf / sg
  --
  -- 2. Терминал как PuTTY (<leader>st): открывает интерактивный SSH-шелл
  --    в встроенном терминале Neovim. Спрашивает user@host, запускает ssh без ключей
  --    (терминал сам запросит пароль если нужно).
  {
    "nosduco/remote-sshfs.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "RemoteSSHFSConnect",
      "RemoteSSHFSDisconnect",
      "RemoteSSHFSEdit",
      "RemoteSSHFSFindFiles",
      "RemoteSSHFSLiveGrep",
    },
    keys = {
      -- Работа с файлами через SSHFS
      { "<leader>ss", function() require("remote-sshfs.api").connect() end,    desc = "SSH: подключиться (SSHFS)" },
      { "<leader>sd", function() require("remote-sshfs.api").disconnect() end, desc = "SSH: отключиться (SSHFS)" },
      { "<leader>se", function() require("remote-sshfs.api").edit() end,       desc = "SSH: редактировать ~/.ssh/config" },
      { "<leader>sf", "<cmd>RemoteSSHFSFindFiles<cr>",                         desc = "SSH: поиск файлов на сервере" },
      { "<leader>sg", "<cmd>RemoteSSHFSLiveGrep<cr>",                          desc = "SSH: live grep на сервере" },
      -- Интерактивный терминал (как PuTTY)
      {
        "<leader>st",
        function()
          vim.ui.input({ prompt = "SSH адрес (user@host): " }, function(target)
            if target and target ~= "" then
              vim.cmd("tabnew | terminal ssh " .. target)
            end
          end)
        end,
        desc = "SSH: открыть терминал (PuTTY-режим)",
      },
    },
    config = function()
      require("remote-sshfs").setup({
        connections = {
          ssh_configs = {
            vim.fn.expand("$HOME") .. "/.ssh/config",
            "/etc/ssh/ssh_config",
          },
          sshfs_args = { "-o reconnect", "-o ConnectTimeout=5" },
        },
        mounts = {
          base_dir = vim.fn.expand("$HOME") .. "/.sshfs/",
          unmount_on_exit = true,
        },
      })
    end,
  },
}
