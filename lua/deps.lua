-- lua/deps.lua
-- Установка всех зависимостей одной командой.
--
-- Раньше пакеты ставились вручную поштучно, а mason-tool-installer имел
-- run_on_start = false, поэтому свежая установка не подтягивала ни
-- форматтеры, ни LSP-серверы. Команда :DepsInstall делает это явно и
-- показывает, что уже стоит.
--
-- Состав берётся из конфигов, а не зашит здесь, чтобы списки не
-- расходились:
--   * форматтеры/линтеры — lua/plugins/mason.lua (mason-tool-installer);
--   * отладчики        — lua/plugins/mason.lua (mason-nvim-dap);
--   * парсеры          — lua/plugins/treesitter.lua.

local M = {}

---@alias DepKind "tool"|"dap"|"parser"

---@param kind DepKind
---@return string[]
local function list_from(kind)
  local ok, mod = pcall(require, "lazy.core.config")
  if not ok then
    return {}
  end
  -- lazy.nvim регистрирует плагины по короткому имени без организации
  -- ("nvim-treesitter", "mason-nvim-dap.nvim"), а не по полному.
  local key = ({ parser = "nvim-treesitter", tool = "mason-tool-installer.nvim", dap = "mason-nvim-dap.nvim" })[kind]
  local plugin = mod.plugins[key]
  if not plugin then
    return {}
  end
  local opts = plugin.opts
  if type(opts) == "function" then
    -- mason-nvim-dap мутирует переданную таблицу и ничего не возвращает,
    -- поэтому результат читаем из аргумента, а не из возвращаемого значения.
    local scratch = {}
    pcall(opts, plugin, scratch)
    opts = scratch
  end
  if type(opts) == "table" and type(opts.ensure_installed) == "table" then
    return opts.ensure_installed
  end
  return {}
end

---@param names string[]
---@param kind DepKind
---@return string[] missing, string[] present
local function split_missing(names, kind)
  local missing, present = {}, {}
  if kind == "parser" then
    -- Парсеры ставит nvim-treesitter, а не mason, и лежат в его runtime.
    -- get_installed() возвращает СПИСОК строк, поэтому строим множество.
    local ok, ts = pcall(require, "nvim-treesitter")
    local have = {}
    if ok then
      local success, list = pcall(ts.get_installed)
      if success and type(list) == "table" then
        for _, lang in ipairs(list) do
          have[lang] = true
        end
      end
    end
    for _, lang in ipairs(names) do
      if have[lang] then
        present[#present + 1] = lang
      else
        missing[#missing + 1] = lang
      end
    end
    return missing, present
  end

  local okreg, registry = pcall(require, "mason-registry")
  for _, name in ipairs(names) do
    local pkg
    if okreg then
      local success, result = pcall(registry.get_package, name)
      pkg = success and result or nil
    end
    if pkg and pkg:is_installed() then
      present[#present + 1] = name
    else
      missing[#missing + 1] = name
    end
  end
  return missing, present
end

---@param names string[]
---@param label string
local function notify_missing(names, label)
  if #names == 0 then
    vim.notify(label .. ": всё на месте", vim.log.levels.INFO, { title = "Deps" })
    return
  end
  vim.notify(label .. ": не хватает " .. table.concat(names, ", "), vim.log.levels.WARN, { title = "Deps" })
end

--- Показать, что уже установлено, а что нет.
function M.status()
  local report = {}
  for _, kind in ipairs({ "tool", "dap", "parser" }) do
    local names = list_from(kind)
    local missing, present = split_missing(names, kind)
    table.insert(
      report,
      string.format("%s — %d/%d (нет: %s)", kind:upper(), #present, #names, #missing > 0 and table.concat(missing, ", ") or "—")
    )
  end
  local text = table.concat(report, "\n")
  vim.notify(text, vim.log.levels.INFO, { title = "Deps" })
  for _, line in ipairs(report) do
    print(line)
  end
end

--- Установить mason-пакеты (форматтеры, линтеры, отладчики).
function M.install()
  local registry = require("mason-registry")
  local jobs = {}

  for _, kind in ipairs({ "tool", "dap" }) do
    local names = list_from(kind)
    local missing = split_missing(names, kind)
    for _, name in ipairs(missing) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok then
        jobs[#jobs + 1] = { name = name, pkg = pkg }
      end
    end
  end

  if #jobs == 0 then
    vim.notify("Mason-пакеты: всё уже установлено", vim.log.levels.INFO, { title = "Deps" })
  else
    vim.notify(string.format("Устанавливаю %d mason-пакетов: %s", #jobs, table.concat(vim.tbl_map(function(j)
      return j.name
    end, jobs), ", ")), vim.log.levels.INFO, { title = "Deps" })

    for _, job in ipairs(jobs) do
      -- start_delay = 0 — стартуем сразу; callback пишет итог, когда
      -- пакет реально распакован, а не когда запись добавлена в очередь.
      job.pkg:install({ start_delay = 0 }, function(success, result)
        if success and job.pkg:is_installed() then
          print(string.format("  ✓ %s", job.name))
        else
          local why = "неизвестная ошибка"
          if type(result) == "table" and result.message then
            why = result.message
          elseif type(result) == "string" then
            why = result
          end
          print(string.format("  ✗ %s — %s", job.name, tostring(why):gsub("\n", " ")))
        end
      end)
    end
  end

  -- Парсеры treesitter ставятся отдельно: это не mason-пакеты, и
  -- mason-registry о них ничего не знает.
  local parsers = list_from("parser")
  local missing_parsers = split_missing(parsers, "parser")
  if #missing_parsers > 0 then
    local ok, ts = pcall(require, "nvim-treesitter")
    if ok and ts.install then
      print(string.format("Ставлю парсеры treesitter: %s", table.concat(missing_parsers, ", ")))
      pcall(function()
        ts.install(missing_parsers):wait(600000)
      end)
    end
  else
    notify_missing({}, "Парсеры treesitter")
  end
end

--- Полная установка: mason-пакеты + парсеры.
function M.install_all()
  M.install()
end

function M.setup()
  vim.api.nvim_create_user_command("DepsInstall", function()
    M.install_all()
  end, { desc = "Установить все mason-пакеты и парсеры treesitter" })

  vim.api.nvim_create_user_command("DepsStatus", function()
    M.status()
  end, { desc = "Показать, какие зависимости установлены, а какие нет" })
end

return M
