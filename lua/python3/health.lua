-- lua/python3/health.lua
-- Проверка Python-окружения. Neovim находит этот файл сам по конвенции
-- lua/<name>/health.lua, поэтому :checkhealth python3 работает без
-- ручного vim.health.register_check().

local M = {}

function M.check()
  local health = vim.health

  health.start("Python 3 Language Server")

  local python_path = vim.fn.exepath("python3")
  if python_path == "" then
    health.error("python3 not found in PATH")
  else
    health.ok("python3 found: " .. python_path)
  end

  -- Mason-бинарники. basedpyright ставится через
  -- :MasonInstall basedpyright (см. mason.lua).
  local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/bin")
  if vim.fn.executable(mason_bin .. "/basedpyright-langserver") == 1 then
    health.ok("basedpyright-langserver installed")
  else
    health.warn("basedpyright-langserver not found at " .. mason_bin)
  end

  if vim.fn.system({ "python3", "-c", "import debugpy" }) == "" and vim.v.shell_error == 0 then
    health.ok("debugpy installed")
  else
    health.warn("debugpy not installed - run: pip install --user debugpy")
  end

  for _, tool in ipairs({ "ruff", "black" }) do
    local path = vim.fn.exepath(tool)
    if path == "" then
      health.warn(("%s not found - run: :MasonInstall %s"):format(tool, tool))
    else
      health.ok(("%s found: %s"):format(tool, path))
    end
  end
end

return M
