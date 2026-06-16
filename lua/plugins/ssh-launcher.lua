return {
  -- SSH-соединения: управление, добавление, редактирование, удаление
  {
    "G00380316/ssh-launcher.nvim",
    config = function()
      require("ssh-launcher").setup({})
    end,
  },
}
