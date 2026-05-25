-- Clipboard via OSC 52 for SSH/headless servers
-- Requires Neovim 0.10+ (built-in osc52 support, no extra plugin needed)
-- Works over SSH, inside tmux, Docker, without X11 or Wayland.
--
-- HOW IT WORKS:
--   vim.g.clipboard points nvim's "+" and "*" registers at the built-in
--   OSC 52 provider. Combined with clipboard=unnamedplus, plain `y`/`p`
--   use the system clipboard transparently.
--
-- TMUX NOTE:
--   Add to ~/.tmux.conf:  set -g set-clipboard on
--   and use a terminal that supports OSC 52 (iTerm2, WezTerm, kitty,
--   Windows Terminal, most modern terminals).

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- Make all yank/paste use the system clipboard register by default
-- so that plain `y`, `yy`, `Y`, `p`, `P` all go through OSC 52
vim.opt.clipboard = "unnamedplus"

-- This file has no lazy.nvim plugins to declare - config is applied directly
return {}
