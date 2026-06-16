return {
  -- SSH-соединения: управление, добавление, редактирование, удаление
  {
    "G00380316/ssh-launcher.nvim",
    cmd = { "SshLauncher", "SshAddKey", "SshEditKey" },
    keys = {
      { "<leader>ss", "<cmd>SshLauncher<cr>",  desc = "SSH: открыть соединение" },
      { "<leader>sa", "<cmd>SshAddKey<cr>",    desc = "SSH: добавить ключ в agent" },
      { "<leader>se", "<cmd>SshEditKey<cr>",   desc = "SSH: редактировать/удалить соединение" },
    },
    config = function()
      require("ssh-launcher").setup({})
    end,
  },
}
