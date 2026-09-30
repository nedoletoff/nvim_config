-- Фильтр предупреждений lspconfig-депрекейшена.
--
-- Ставится до lazy: часть сообщений прилетает во время загрузки плагинов,
-- и quiet.lua (подключается позже, через astrocore) их уже не видит.
-- quiet.lua переиспользует этот список, чтобы паттерны не расходились.
--
-- Проверено на Neovim 0.12.3 + nvim-lspconfig: require("lspconfig") в
-- конфиге никто не вызывает, и на обычном старте фильтр не срабатывает.
-- Он остаётся страховкой на случай, если какой-то плагин дёрнет старый
-- API — тогда сообщение уйдёт в :ViewLogs, а не в лицо.
local _suppress_patterns = {
  "lspconfig.*deprecated",
  "Feature will be removed in nvim%-lspconfig",
}
_G.__nvim_suppress_patterns = _suppress_patterns

local _original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" then
    for _, pattern in ipairs(_suppress_patterns) do
      if msg:match(pattern) then return end
    end
  end
  return _original_notify(msg, level, opts)
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { "AstroNvim/AstroNvim", import = "astronvim.plugins" },
    { import = "plugins" },
  },
  defaults = { lazy = true },
  install = { colorscheme = { "astrodark" } },
  checker = { enabled = false },
  -- Ни один плагин в конфиге не ставится через luarocks: markview обходится
  -- нативными API, rockspec-плагинов в списке нет. Проверка luarocks в
  -- :checkhealth lazy всё равно ругается на отсутствующий hererocks/luarocks,
  -- поэтому отключаем секцию целиком.
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
})
