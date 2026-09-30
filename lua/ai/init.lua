-- Реестр AI-провайдеров и моделей для CodeCompanion.
--
-- Зачем отдельный модуль: DeepSeek больше не единственный. Нужен бесплатный
-- вариант (OpenCode Zen, модели вида `big-pickle`), переключение модели на
-- лету и индикатор активной модели в statusline. Всё это живёт здесь, а
-- `lua/plugins/codecompanion.lua` только собирает из этого конфиг плагина.
--
-- Выбор хранится в vim.g.ai_provider / vim.g.ai_model, поэтому statusline и
-- чат всегда показывают реально активную модель. Учти: vim.g живёт только
-- в рамках сессии, поэтому после перезапуска Neovim выбор возвращается
-- к провайдеру по умолчанию.
--
-- ── КЛЮЧИ API ────────────────────────────────────────────────────────
-- Ни один ключ не хардкодится. Порядок поиска для каждого провайдера:
--   1) переменная окружения (см. PROVIDERS[*].env)
--   2) файл вне репозитория (см. PROVIDERS[*].key_file)
-- Если ключ не найден — один раз за сессию показывается vim.notify.
--
-- Создать файл с ключом:
--     mkdir -p ~/.config/deepseek ~/.config/opencode
--     chmod 700 ~/.config/deepseek ~/.config/opencode
--     printf '%s' 'sk-ТВОЙ_КЛЮЧ'   > ~/.config/deepseek/api_key
--     printf '%s' 'zen_ТВОЙ_КЛЮЧ'  > ~/.config/opencode/zen_key
--     chmod 600 ~/.config/deepseek/api_key ~/.config/opencode/zen_key
--
-- Ключ DeepSeek:  https://platform.deepseek.com/api_keys
-- Ключ Zen:       https://opencode.ai/auth  (создаётся в /connect → OpenCode Zen)

local M = {}

M.PROVIDERS = {
  deepseek = {
    label = "DeepSeek",
    adapter = "deepseek", -- имя адаптера в codecompanion
    env = "DEEPSEEK_API_KEY",
    key_file = "~/.config/deepseek/api_key",
    key_hint = "https://platform.deepseek.com/api_keys",
    free = false,
    models = {
      { id = "deepseek-chat", label = "deepseek-chat — быстрая, дешёвая", can_reason = false },
      { id = "deepseek-reasoner", label = "deepseek-reasoner — с размышлением", can_reason = true },
    },
  },

  -- OpenCode Zen: OpenAI-совместимый шлюз с бесплатными моделями.
  -- Эндпоинт один на все: https://opencode.ai/zen/v1/chat/completions
  -- Список моделей:      https://opencode.ai/zen/v1/models
  zen = {
    label = "OpenCode Zen",
    adapter = "zen",
    env = "OPENCODE_API_KEY",
    key_file = "~/.config/opencode/zen_key",
    key_hint = "https://opencode.ai/auth",
    free = true,
    models = {
      { id = "big-pickle", label = "big-pickle — free", free = true },
      { id = "space-bunny-free", label = "space-bunny-free — free, zero-retention", free = true },
      { id = "longcat-2.5-preview-free", label = "longcat-2.5-preview-free — free", free = true },
      { id = "mimo-v2.6-flash-free", label = "mimo-v2.6-flash-free — free", free = true },
      { id = "mimo-v2.5-free", label = "mimo-v2.5-free — free", free = true },
      { id = "ling-3.0-flash-fin-free", label = "ling-3.0-flash-fin-free — free", free = true },
      { id = "nemotron-3-ultra-free", label = "nemotron-3-ultra-free — free", free = true },
      { id = "nemotron-3.5-lightning-free", label = "nemotron-3.5-lightning-free — free", free = true },
    },
  },
}

local warned = {}

--- Прочитать ключ провайдера БЕЗ предупреждения.
--- Само значение наружу не отдаётся ни в лог, ни в UI.
---@param name string
---@return string|nil
function M.read_key(name)
  local p = M.PROVIDERS[name]
  if not p then
    return nil
  end

  local from_env = vim.env[p.env]
  if from_env and from_env ~= "" then
    return (from_env:gsub("%s+$", ""))
  end

  local path = vim.fn.expand(p.key_file)
  local fd = io.open(path, "r")
  if fd then
    local content = vim.trim(fd:read("*a") or "")
    fd:close()
    if content ~= "" then
      return content
    end
  end

  return nil
end

--- Прочитать ключ провайдера; если не нашли — один раз за сессию предупредить.
---@param name string
---@return string|nil
function M.key(name)
  local key = M.read_key(name)
  if key then
    return key
  end

  local p = M.PROVIDERS[name]
  if not p then
    return nil
  end

  if not warned[name] then
    warned[name] = true
    vim.notify(
      ("CodeCompanion [%s]: не найден ключ API.\nСоздайте файл:\n    printf '%%s' 'КЛЮЧ' > %s\nили задайте $%s\nКлюч берётся здесь: %s"):format(
        p.label,
        vim.fn.expand(p.key_file),
        p.env,
        p.key_hint
      ),
      vim.log.levels.WARN
    )
  end

  return nil
end

--- Есть ли ключ (для health и меню выбора модели)
---@param name string
---@return boolean
function M.has_key(name)
  return M.read_key(name) ~= nil
end

--- Статический список `schema.model.choices` для адаптера.
--- `can_reason = false` означает, что провайдеру нельзя слать
--- `thinking.type` / `reasoning_effort` — иначе он отвечает 400.
---@param name string
---@return table
function M.choices(name)
  local out = {}
  for _, m in ipairs(M.PROVIDERS[name].models) do
    out[m.id] = {
      formatted_name = m.label,
      opts = {
        can_reason = m.can_reason == true,
        can_use_tools = true,
        can_form_structured_outputs = false,
        has_vision = false,
      },
    }
  end
  return out
end

--- Умеет ли модель адаптера рассуждать? Используется как `schema.*.enabled`.
--- `choices` умеет быть функцией, поэтому сначала приводим к таблице.
---@param adapter table
---@return boolean
function M.can_reason(adapter)
  local schema = adapter.schema and adapter.schema.model
  if not schema then
    return false
  end
  local model = schema.default
  if type(model) == "function" then
    model = model(adapter)
  end
  local choices = schema.choices
  if type(choices) == "function" then
    choices = choices(adapter)
  end
  if type(model) == "string" and type(choices) == "table" then
    return (choices[model] and choices[model].opts and choices[model].opts.can_reason) == true
  end
  return false
end

---@return string provider, string model
function M.current()
  local provider = vim.g.ai_provider
  local model = vim.g.ai_model

  if type(provider) ~= "string" or not M.PROVIDERS[provider] then
    provider = "deepseek"
  end
  if type(model) ~= "string" or not M.model_info(provider, model) then
    model = M.PROVIDERS[provider].models[1].id
  end

  return provider, model
end

--- Найти описание модели
---@param provider string
---@param model string
---@return table|nil
function M.model_info(provider, model)
  for _, m in ipairs(M.PROVIDERS[provider].models) do
    if m.id == model then
      return m
    end
  end
  return nil
end

--- Таблица для `interactions.*.adapter`
---@return table
function M.adapter()
  local provider, model = M.current()
  return { name = M.PROVIDERS[provider].adapter, model = model }
end

--- Короткая подпись для statusline: "DeepSeek · deepseek-chat"
---@return string
function M.status()
  local provider, model = M.current()
  local p = M.PROVIDERS[provider]
  return ("%s · %s"):format(p.label, model)
end

--- Переключить модель и применить её к CodeCompanion
---@param provider string
---@param model string
function M.set(provider, model)
  if not M.PROVIDERS[provider] or not M.model_info(provider, model) then
    error(("ai: неизвестная модель %s/%s"):format(provider, model), 2)
  end

  local prev_provider, prev_model = M.current()
  vim.g.ai_provider, vim.g.ai_model = provider, model
  M.apply()

  if prev_provider ~= provider or prev_model ~= model then
    vim.notify(("CodeCompanion: %s"):format(M.status()), vim.log.levels.INFO)
  end
end

--- Следующая модель внутри текущего провайдера (переключение по кругу)
function M.cycle()
  local provider, model = M.current()
  local list = M.PROVIDERS[provider].models
  for i, m in ipairs(list) do
    if m.id == model then
      return M.set(provider, list[(i % #list) + 1].id)
    end
  end
  M.set(provider, list[1].id)
end

--- Интерактивный выбор: сначала провайдер, затем модель
function M.pick()
  local cur_provider = M.current()
  local provider_names = vim.tbl_keys(M.PROVIDERS)
  table.sort(provider_names)

  local items = {}
  for _, name in ipairs(provider_names) do
    local p = M.PROVIDERS[name]
    local ok = pcall(M.has_key, name)
    items[#items + 1] = {
      name = ("%s%s%s"):format(
        p.label,
        p.free and "  (free)" or "",
        ok and "" or "  ⚠ нет ключа"
      ),
      kind = "provider",
      value = name,
      current = name == cur_provider and "● " or "  ",
    }
  end

  vim.ui.select(items, {
    prompt = "Провайдер AI",
    format_item = function(it)
      return it.current .. it.name
    end,
  }, function(choice)
    if not choice then
      return
    end
    M.pick_model(choice.value)
  end)
end

--- Выбор модели внутри провайдера
---@param provider string
function M.pick_model(provider)
  local _, cur_model = M.current()
  local items = {}

  for i, m in ipairs(M.PROVIDERS[provider].models) do
    items[#items + 1] = {
      name = m.label,
      value = m.id,
      current = m.id == cur_model and "● " or "  ",
    }
  end

  vim.ui.select(items, {
    prompt = ("Модель — %s"):format(M.PROVIDERS[provider].label),
    format_item = function(it)
      return it.current .. it.name
    end,
  }, function(choice)
    if choice then
      M.set(provider, choice.value)
    end
  end)
end

--- Протолкнуть текущий выбор в конфиг CodeCompanion и в уже открытый чат
function M.apply()
  local ok, config = pcall(require, "codecompanion.config")
  if not ok then
    return
  end

  for _, name in ipairs({ "chat", "inline", "cmd" }) do
    local interaction = config.interactions[name]
    if interaction then
      interaction.adapter = M.adapter()
    end
  end

  -- Если чат уже открыт — меняем адаптер и в нём, иначе останется старая модель
  pcall(function()
    local cc = require("codecompanion")
    local chat = cc.last_chat()
    if not chat or not chat.adapter then
      return
    end
    local adapters = require("codecompanion.adapters")
    local wanted = M.adapter()
    if chat.adapter.name == wanted.name then
      -- тот же провайдер — достаточно сменить модель
      adapters.set_model({ adapter = chat.adapter, model = wanted.model })
    else
      -- другой провайдер — адаптер нужно пересобрать целиком
      chat.adapter = adapters.resolve(wanted)
    end
  end)
end

return M
