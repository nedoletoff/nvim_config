-- Python healthcheck for Neovim
-- Verifies Python environment and language server setup

local M = {}

M.check = function()
  local health = vim.health
  
  health.start("Python 3 Language Server")
  
  -- Check Python 3
  local python_path = vim.fn.exepath("python3")
  if python_path == "" then
    health.error("python3 not found in PATH")
  else
    health.ok("python3 found: " .. python_path)
  end
  
  -- Check basedpyright in Mason
  local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/bin")
  if vim.fn.executable(mason_bin .. "/basedpyright-langserver") == 1 then
    health.ok("basedpyright-langserver installed")
  else
    health.warn("basedpyright-langserver not found at " .. mason_bin)
  end
  
  -- Check debugpy
  local debugpy_check = "python3 -c 'import debugpy' 2>/dev/null && echo ok || echo fail"
  if vim.fn.systemlist(debugpy_check)[1] == "ok" then
    health.ok("debugpy installed")
  else
    health.warn("debugpy not installed - run: pip install --user debugpy")
  end
  
  -- Check black
  local black_path = vim.fn.exepath("black")
  if black_path == "" then
    health.warn("black formatter not found")
  else
    health.ok("black found: " .. black_path)
  end
  
  -- Check ruff
  local ruff_path = vim.fn.exepath("ruff")
  if ruff_path == "" then
    health.warn("ruff linter not found")
  else
    health.ok("ruff found: " .. ruff_path)
  end
end

return M
