return {
  -- SSH-соединения: управление, добавление, редактирование, удаление
  -- Команды регистрируются внутри setup(), поэтому загружаем через event, а не cmd
  {
    "G00380316/ssh-launcher.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>ss", "<cmd>SshLauncher<cr>",  desc = "SSH: открыть соединение" },
      { "<leader>sa", "<cmd>SshAddKey<cr>",    desc = "SSH: добавить ключ в agent" },
      { "<leader>se", "<cmd>SshEditKey<cr>",   desc = "SSH: редактировать/удалить соединение" },
    },
    config = function()
      require("ssh_launcher").setup({})
    end,
  },
}
