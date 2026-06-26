-- Dance Time: открыть/закрыть анимированную ASCII-тянку
vim.keymap.set("n", "<leader>dt", function()
  require("user.dance_time").toggle()
end, { desc = "Dance Time! ✧ (^ω^) ✧" })
