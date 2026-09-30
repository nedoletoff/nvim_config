-- lua/ai/actions.lua
-- AI-действия над выделенным текстом.
--
-- Вызывается только клавиатурным keymap <Leader>cA (visual) — он открывает
-- меню, выбранный пункт уходит в CodeCompanion вместе с выделением. Правый
-- клик мыши не трогаем: за ним остаётся штатное меню Neovim.
--
-- Меню показывается через vim.ui.select, которым владеет Snacks (пикер),
-- поэтому вид и поиск такие же, как у остальных пикеров конфига.
--
-- Выделение читается из марок '< / '> и захватывается ДО открытия меню:
-- пикер уводит из visual-режима, и к моменту выбора марок уже может не
-- быть. Готовый текст передаём в chat как user_prompt, а не через
-- :CodeCompanion — не нужно экранировать пробелы и кавычки в запросе.

local M = {}

--- Список действий. `prompt = false` означает «спросить текст у пользователя».
local ACTIONS = {
  { name = "Объяснить", prompt = "Объясни, что делает следующий код. Кратко, по-русски." },
  { name = "Найти баги", prompt = "Найди ошибки в следующем коде и предложи исправление." },
  { name = "Отрефакторить", prompt = "Отрефактори следующий код: читаемость, именование, дублирование. Покажи улучшенный вариант." },
  { name = "Оптимизировать", prompt = "Оптимизируй следующий код по производительности и объясни изменения." },
  { name = "Написать тесты", prompt = "Напиши юнит-тесты для следующего кода." },
  { name = "Задокументировать", prompt = "Добавь комментарии и документацию к следующему коду." },
  { name = "Перевести на русский", prompt = "Переведи комментарии и строковые литералы в следующем коде на русский. Сам код не меняй." },
  { name = "Свой запрос…", prompt = false },
}

--- Текст текущего выделения (visual). Пустая строка, если выделения нет.
---
--- Пока visual-режим активен, марки '< / '> ещё не выставлены — их
--- выставляют при выходе из режима. Поэтому в visual берём якоря
--- ('v' и '.') и нормализуем порядок, а вне visual — марки.
---@return string
local function get_selection()
  local m = vim.fn.mode()
  local s, e, linewise
  if m == "v" or m == "V" or m == "\22" then
    linewise = (m == "V")
    s, e = vim.fn.getpos("v"), vim.fn.getpos(".")
    if s[2] > e[2] or (s[2] == e[2] and s[3] > e[3]) then
      s, e = e, s
    end
  else
    s, e = vim.fn.getpos("'<"), vim.fn.getpos("'>")
    -- Для построчного выделения '> ставится в огромную колонку.
    linewise = e[3] >= 2147483647
  end

  if s[2] == 0 or e[2] == 0 then
    return ""
  end

  local lines = vim.fn.getline(s[2], e[2])
  if type(lines) ~= "table" or #lines == 0 then
    return ""
  end
  if linewise then
    return table.concat(lines, "\n")
  end
  if #lines == 1 then
    lines[1] = lines[1]:sub(s[3], e[3])
  else
    lines[1] = lines[1]:sub(s[3])
    lines[#lines] = lines[#lines]:sub(1, e[3])
  end
  return table.concat(lines, "\n")
end

---@param prompt string
---@param text string
---@param ft string
local function send(prompt, text, ft)
  local ok, cc = pcall(require, "codecompanion")
  if not ok then
    vim.notify("ai.actions: CodeCompanion недоступен", vim.log.levels.ERROR)
    return
  end
  local lang = (ft ~= "" and ft or "text")
  local body = ("%s\n\n```%s\n%s\n```"):format(prompt, lang, text)
  cc.chat({ user_prompt = body })
end

---@param action table
---@param text string
---@param ft string
local function run(action, text, ft)
  if action.prompt == false then
    vim.ui.input({ prompt = "AI-запрос: " }, function(input)
      if input and vim.trim(input) ~= "" then
        send(vim.trim(input), text, ft)
      end
    end)
    return
  end
  send(action.prompt, text, ft)
end

--- Открыть меню AI-действий над текущим выделением.
function M.menu()
  local text = get_selection()
  if vim.trim(text) == "" then
    vim.notify("ai.actions: нет выделения", vim.log.levels.WARN)
    return
  end
  local ft = vim.bo.filetype

  vim.ui.select(ACTIONS, {
    prompt = "AI над выделением",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      run(choice, text, ft)
    end
  end)
end

return M
