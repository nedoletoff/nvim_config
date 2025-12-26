return {
  "seandewar/bad-apple.nvim",
  cmd = "BadApple",
  config = function()
    vim.keymap.set("n", "<leader>ba", "<cmd>BadApple<cr>", { noremap = true, silent = true })
    
    -- Configure libcanberra sound support
    -- Path to libcanberra.so library (works without X11)
    -- Find the path with: find /usr -name "libcanberra.so*" 2>/dev/null
    -- Common paths:
    -- - /usr/lib/x86_64-linux-gnu/libcanberra.so.0
    -- - /usr/lib/libcanberra.so
    require("bad-apple.sound").libcanberra_fname = "/usr/lib/x86_64-linux-gnu/libcanberra.so.0"
  end,
}
