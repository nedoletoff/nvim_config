-- Dance Time: открыть/закрыть анимированную ASCII-тянку
-- Маппинг зарегистрирован через astrocore.lua (<Leader>DT)
-- Этот файл оставлен как fallback для окружений без AstroNvim
vim.keymap.set("n", "<leader>DT", function()
  require("user.dance_time").toggle()
end, { desc = "Dance Time! ✧ (^ω^) ✧" })
