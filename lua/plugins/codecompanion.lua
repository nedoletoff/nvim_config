-- CodeCompanion.nvim — AI-ассистент.
--
-- Провайдеры и модели описаны в lua/ai/init.lua, там же резолвится ключ API.
-- Этот файл только собирает из реестра конфиг плагина и вешает кеймапы.
--
-- Провайдеров два:
--   deepseek — платный API DeepSeek, модели deepseek-chat / deepseek-reasoner
--   zen      — OpenCode Zen, бесплатные модели (big-pickle и др.)
--
-- Безопасность ключа: ключ никогда не хардкодится и не попадает в репозиторий.
-- DeepSeek: ~/.config/deepseek/api_key или $DEEPSEEK_API_KEY
-- Zen:      ~/.config/opencode/zen_key или $OPENCODE_API_KEY
-- Подробности и команды создания — в начале lua/ai/init.lua.

local ai = require("ai")

--- Ключ для адаптера. Плагин умеет брать env-поля как функции, поэтому ключ
--- читается в момент запроса и в конфиг не попадает.
--- Пустая строка вместо nil — иначе в Authorization утечёт литерал
--- "${api_key}" из шаблона адаптера.
---@param name string
---@return fun(): string
local function key_fn(name)
  return function()
    return ai.key(name) or ""
  end
end

---@type LazySpec
return {
  "olimorris/codecompanion.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim", -- HTTP-запросы (обязательная зависимость плагина)
    "nvim-treesitter/nvim-treesitter", -- извлечение контекста и кодовых блоков
  },

  keys = {
    {
      "<leader>ca",
      function() require("codecompanion").actions() end,
      desc = "CodeCompanion: меню действий",
    },
    {
      "<leader>cc",
      function() require("codecompanion").toggle_chat() end,
      desc = "CodeCompanion: окно чата",
      mode = { "n", "t" },
    },
    {
      "<leader>ci",
      function() require("codecompanion").inline() end,
      desc = "CodeCompanion: инлайн-правка (выделение/строка)",
      mode = { "n", "v" },
    },
    {
      "ga",
      function() require("codecompanion").add() end,
      desc = "CodeCompanion: добавить выделение в чат",
      mode = "v",
    },
    {
      "<leader>cm",
      function() ai.pick() end,
      desc = "CodeCompanion: выбрать провайдера и модель",
    },
    {
      "<leader>cM",
      function() ai.cycle() end,
      desc = "CodeCompanion: следующая модель",
    },
  },

  opts = function(_, opts)
    -- Язык ответов LLM. В setup-таблице это opts.opts.language
    opts.opts = opts.opts or {}
    opts.opts.language = "Russian"

    opts.adapters = opts.adapters or {}
    opts.adapters.http = opts.adapters.http or {}

    -- ── DeepSeek ──────────────────────────────────────────────────────
    -- Подменяем встроенный адаптер, чтобы резолвить ключ безопасно.
    -- `enabled = ai.can_reason` гасит thinking.type / reasoning_effort
    -- для моделей без can_reason — deepseek-chat отвечает 400 на них.
    opts.adapters.http.deepseek = function()
      return require("codecompanion.adapters").extend("deepseek", {
        env = { api_key = key_fn("deepseek") },
        schema = {
          model = { default = ai.PROVIDERS.deepseek.models[1].id },
          ["thinking.type"] = { enabled = ai.can_reason },
          reasoning_effort = { enabled = ai.can_reason },
        },
      })
    end

    -- ── OpenCode Zen (бесплатные модели) ──────────────────────────────
    -- OpenAI-совместимый шлюз: https://opencode.ai/zen/v1/chat/completions
    -- Список моделей у шлюза:      https://opencode.ai/zen/v1/models
    --
    -- Наследуем поведение openai (стриминг, tools) и меняем только url,
    -- ключ и список моделей — свой handlers не нужен, иначе легко получить
    -- рекурсию. `enabled = ai.can_reason` не нужен: у free-моделей в Zen
    -- reasoning-параметры не поддерживаются, но и в schema их нет.
    opts.adapters.http.zen = function()
      return require("codecompanion.adapters").extend("openai", {
        formatted_name = "OpenCode Zen",
        url = "https://opencode.ai/zen/v1/chat/completions",
        env = {
          api_key = key_fn("zen"),
        },
        schema = {
          model = {
            default = ai.PROVIDERS.zen.models[1].id,
            choices = ai.choices("zen"),
          },
        },
      })
    end

    -- Текущий выбор провайдера — основной адаптер чата. code_review и
    -- background адаптера не имеют и наследуют адаптер чата.
    local adapter = ai.adapter()
    opts.interactions = opts.interactions or {}
    for _, name in ipairs({ "chat", "inline", "cmd" }) do
      opts.interactions[name] = opts.interactions[name] or {}
      opts.interactions[name].adapter = vim.deepcopy(adapter)
    end

    -- Русские заголовки в буфере чата.
    -- Провайдера читаем прямо в момент вызова роли, а не захватываем в
    -- local на этапе setup: иначе после переключения модели в рантайме
    -- заголовок продолжал бы показывать старого провайдера до рестарта.
    opts.interactions.chat.roles = vim.tbl_deep_extend("force", opts.interactions.chat.roles or {}, {
      llm = function(a)
        local cur = ai.current()
        return ("%s (%s)"):format(ai.PROVIDERS[cur].label, tostring(a.schema.model.default))
      end,
      user = "Я",
    })

    return opts
  end,

  config = function(_, opts)
    require("codecompanion").setup(opts)
    -- Прогоняем apply(), чтобы модель, сохранённая в vim.g, встала в готовую
    -- конфигурацию плагина (важно после переключения провайдера).
    ai.apply()
  end,
}
