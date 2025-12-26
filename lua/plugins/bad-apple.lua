return {
  {
    "seandewar/bad-apple.nvim",
    cmd = "BadApple",
    config = function()
      vim.keymap.set("n", "<leader>ba", "<cmd>BadApple<cr>", { noremap = true, silent = true })
    end,
  },
}
