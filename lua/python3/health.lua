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

  -- Mason-бинарники. basedpyright теперь есть в ensure_installed
  -- (lua/plugins/mason.lua), поэтому ставится вместе с остальными через
  -- :DepsInstall или автоматически при старте. Сообщение оставляем на
  -- случай, если установка не прошла.
  local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/bin")
  if vim.fn.executable(mason_bin .. "/basedpyright-langserver") == 1 then
    health.ok("basedpyright-langserver installed")
  else
    health.warn("basedpyright-langserver not found at " .. mason_bin .. " - run: :DepsInstall")
  end

  -- debugpy проверяем через exit code: systemlist() возвращает пустую
  -- таблицу при коде 0, поэтому ранняя версия health ругалась на
  -- заведомо установленный debugpy.
  local ok, _ = pcall(function()
    return vim.fn.system({ "python3", "-c", "import debugpy" })
  end)
  if ok and vim.v.shell_error == 0 then
    health.ok("debugpy installed")
  else
    health.warn("debugpy not installed - run: pip install --user debugpy")
  end

  -- Форматтеры/линтеры ищем и в PATH, и в каталоге mason: на свежей
  -- машине бинарники ещё не попали в PATH, но уже установлены.
  for _, tool in ipairs({ "ruff", "black" }) do
    local path = vim.fn.exepath(tool)
    if path == "" and vim.fn.executable(mason_bin .. "/" .. tool) == 1 then
      path = mason_bin .. "/" .. tool
    end
    if path == "" then
      health.warn(("%s not found - run: :DepsInstall"):format(tool))
    else
      health.ok(("%s found: %s"):format(tool, path))
    end
  end
end

return M
