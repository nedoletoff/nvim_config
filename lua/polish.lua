-- Add user@host to statusline
local user = vim.loop.os_getenv("USER") or vim.loop.os_getenv("USERNAME") or "user"
local host = vim.loop.os_gethostname() or "host"
local user_host = user .. "@" .. host
vim.g.user_host = user_host

-- Append to doom statusline right section after setup
vim.defer_fn(function()
  local ok, doom_statusline = pcall(require, "doom.modules.ui.statusline")
  if ok and doom_statusline and doom_statusline.section and doom_statusline.section.rz then
    table.insert(doom_statusline.section.rz, user_host)
  end
end, 200)
