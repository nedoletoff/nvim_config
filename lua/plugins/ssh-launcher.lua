return {
  -- Удалённая разработка через SSHFS: поддерживает и ключи, и пароль
  -- Читает хосты из ~/.ssh/config автоматически
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
      { "<leader>ss", function() require("remote-sshfs.api").connect() end,    desc = "SSH: подключиться" },
      { "<leader>sd", function() require("remote-sshfs.api").disconnect() end, desc = "SSH: отключиться" },
      { "<leader>se", function() require("remote-sshfs.api").edit() end,       desc = "SSH: редактировать ~/.ssh/config" },
      { "<leader>sf", "<cmd>RemoteSSHFSFindFiles<cr>",                         desc = "SSH: поиск файлов на сервере" },
      { "<leader>sg", "<cmd>RemoteSSHFSLiveGrep<cr>",                          desc = "SSH: live grep на сервере" },
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
