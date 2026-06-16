-- Clipboard via OSC 52 for SSH/headless servers
-- Requires Neovim 0.10+ (built-in osc52 support, no extra plugin needed)
-- Works over SSH, inside tmux, Docker, without X11 or Wayland.
--
-- HOW IT WORKS:
--   copy  -> OSC 52: yank пушает текст в системный буфер терминала через OSC 52
--   paste -> читается из внутреннего регистра Neovim (без OSC 52),
--         так как OSC 52 paste вызывает зависание "Waiting for OSC 52 response"
--         в большинстве терминалов через SSH.
--
-- TMUX NOTE:
--   Add to ~/.tmux.conf:  set -g set-clipboard on
--   and use a terminal that supports OSC 52 (iTerm2, WezTerm, kitty,
--   Windows Terminal, most modern terminals).

-- Функция вставки из внутреннего регистра Neovim.
-- Neovim ожидает таблицу { lines_table, regtype }, а не два значения.
local function paste_from_register()
  local text = vim.fn.getreg('"')
  local regtype = vim.fn.getregtype('"')
  return { vim.split(text, "\n"), regtype }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste_from_register,
    ["*"] = paste_from_register,
  },
}

-- Make all yank/paste use the system clipboard register by default
-- so that plain `y`, `yy`, `Y`, `p`, `P` all go through OSC 52
vim.opt.clipboard = "unnamedplus"

-- This file has no lazy.nvim plugins to declare - config is applied directly
return {}
