-- Suppress lspconfig deprecation spam BEFORE lazy loads plugins
-- (quiet.lua переопределяет notify слишком поздно для startup-варнингов)
local _original_notify = vim.notify
vim.notify = function(msg, level, opts)
  local suppress = {
    "lspconfig.*deprecated",
    "Feature will be removed in nvim%-lspconfig",
  }
  for _, pattern in ipairs(suppress) do
    if type(msg) == "string" and msg:match(pattern) then return end
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
