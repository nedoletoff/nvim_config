return {
  {
    "seandewar/actually-doom.nvim",
    cmd = "Doom",
    dependencies = {},
    config = function()
      vim.keymap.set("n", "<leader>gd", "<cmd>Doom<cr>", { noremap = true, silent = true })
    end,
  },
}
