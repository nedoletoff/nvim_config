-- Проверка окружения CodeCompanion.
-- Вызывается как:  :checkhealth ai
--
-- Зачем отдельный модуль, а не lua/codecompanion/health.lua:
-- плагин подключён через lazy и лежит в rtp только после загрузки, поэтому
-- Neovim не находит его health-модуль при :checkhealth. Модуль из конфига
-- находится в rtp всегда, а require внутри функции тянет плагин.
--
-- Ключи API никогда не печатаются — только источник и длина.

local M = {}

function M.check()
  vim.health.start("CodeCompanion")

  local ok_plug, cc = pcall(require, "codecompanion")
  if not ok_plug then
    vim.health.error("не удалось загрузить codecompanion.nvim: " .. tostring(cc))
    return
  end
  vim.health.ok("плагин загружен")

  -- Собственные проверки плагина: зависимости, парсеры treesitter, библиотеки
  local ok_health, err = pcall(function() require("codecompanion.health").check() end)
  if not ok_health then
    vim.health.warn("проверки плагина прервались: " .. tostring(err))
  end

  -- ── Ключи ──────────────────────────────────────────────────────────
  local ai = require("ai")
  local missing = {}
  vim.health.start("Ключи API")
  for _, name in ipairs(vim.tbl_keys(ai.PROVIDERS)) do
    local p = ai.PROVIDERS[name]
    local path = vim.fn.expand(p.key_file)
    local key = ai.read_key(name)
    if key then
      local from_env = (vim.env[p.env] or "") ~= ""
      vim.health.ok(("%s: ключ найден (%s, %d симв.)"):format(p.label, from_env and "$" .. p.env or path, #key))
    else
      table.insert(missing, p)
      vim.health.warn(("%s: ключ не найден — %s или $%s"):format(p.label, path, p.env))
    end
  end

  -- ── Модели и адаптеры ───────────────────────────────────────────────
  vim.health.start("Активная модель")
  local provider, model = ai.current()
  local p = ai.PROVIDERS[provider]
  vim.health.info(("выбрано: %s · %s"):format(p.label, model))

  local ok_res, adapters = pcall(require, "codecompanion.adapters")
  if not ok_res then
    vim.health.error("не удалось загрузить codecompanion.adapters: " .. tostring(adapters))
    return
  end

  for _, name in ipairs(vim.tbl_keys(ai.PROVIDERS)) do
    local prov = ai.PROVIDERS[name]
    local ok, adapter = pcall(adapters.resolve, name)
    if not ok then
      vim.health.error(("%s: адаптер не резолвится — %s"):format(prov.label, tostring(adapter)))
    else
      local info = ai.model_info(provider, model)
      vim.health.ok(("%s: url=%s"):format(prov.label, tostring(adapter.url)))
      if name == provider then
        vim.health.info(("  активная модель: %s, reasoning: %s"):format(
          tostring(adapter.schema.model.default),
          info and tostring(info.can_reason == true) or "?"
        ))
      end
    end
  end

  local cfg = require("codecompanion.config")
  vim.health.info("язык ответов: " .. tostring(cfg.opts.language))
  vim.health.info("adapter чата: " .. vim.inspect(cfg.interactions.chat.adapter):gsub("%s+", " "))

  -- ── Итог ───────────────────────────────────────────────────────────
  vim.health.start("Итог")
  local total = 0
  for _ in pairs(ai.PROVIDERS) do
    total = total + 1
  end
  if vim.tbl_isempty(missing) then
    vim.health.ok("все ключи на месте, можно отправлять запросы")
  else
    vim.health.warn(("%d из %d провайдеров без ключа — запросы к ним вернут 401"):format(#missing, total))
    for _, prov in ipairs(missing) do
      vim.health.info(("ключ %s берётся здесь: %s"):format(prov.label, prov.key_hint))
    end
    vim.health.info("команды создания файлов — в начале lua/ai/init.lua")
  end
end

return M
