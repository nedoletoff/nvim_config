--- hashfile.lua — модуль для вычисления хеш-сумм текущего файла
--- Использование: require("hashfile").pick()
--- Зависимости: только стандартный vim API + системные утилиты (sha256sum, md5sum и т.д.)

local M = {}

--- Список поддерживаемых алгоритмов.
--- Каждая запись: { label, cmd }
--- cmd получает путь к файлу как аргумент через %s
local ALGORITHMS = {
  { label = "MD5",     cmd = "md5sum %s" },
  { label = "SHA-1",   cmd = "sha1sum %s" },
  { label = "SHA-224", cmd = "sha224sum %s" },
  { label = "SHA-256", cmd = "sha256sum %s" },
  { label = "SHA-384", cmd = "sha384sum %s" },
  { label = "SHA-512", cmd = "sha512sum %s" },
  { label = "SHA-512/224", cmd = "sha512sum --tag %s | awk '{print $4}'" },
  { label = "B2 (BLAKE2b-512)", cmd = "b2sum %s" },
  { label = "CRC32 (cksum)",    cmd = "cksum %s" },
}

--- Вычислить хеш файла с помощью системной команды.
---@param filepath string абсолютный путь к файлу
---@param cmd_tpl string шаблон команды с %s вместо пути
---@return string|nil результат или nil при ошибке
local function compute_hash(filepath, cmd_tpl)
  local safe_path = vim.fn.shellescape(filepath)
  local cmd = string.format(cmd_tpl, safe_path)
  local handle = io.popen(cmd .. " 2>/dev/null")
  if not handle then return nil end
  local result = handle:read("*l")
  handle:close()
  if not result or result == "" then return nil end
  -- sha*sum выводит: <hash>  <filename> — берём только хеш
  return result:match("^(%S+)")
end

--- Показать float-окно с результатом.
---@param algo_label string название алгоритма
---@param hash string хеш-сумма
---@param filepath string путь к файлу
local function show_result(algo_label, hash, filepath)
  local filename = vim.fn.fnamemodify(filepath, ":t")
  local lines = {
    string.format(" %s  %s ", algo_label, filename),
    "",
    " " .. hash .. " ",
    "",
    " [y] скопировать  [Enter/q] закрыть ",
  }

  local width = 0
  for _, l in ipairs(lines) do
    width = math.max(width, #l)
  end
  width = math.max(width, 60)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local win_h = vim.o.lines
  local win_w = vim.o.columns
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    width = width,
    height = #lines,
    row = math.floor((win_h - #lines) / 2),
    col = math.floor((win_w - width) / 2),
    title = " Hash ",
    title_pos = "center",
  })

  -- Подсветка заголовка и хеша
  vim.api.nvim_buf_add_highlight(buf, -1, "Title",   0, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, -1, "String",  2, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, -1, "Comment", 4, 0, -1)

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  -- Клавиши в окне результата
  local opts = { buffer = buf, nowait = true, noremap = true, silent = true }
  vim.keymap.set("n", "q",     close, opts)
  vim.keymap.set("n", "<Esc>", close, opts)
  vim.keymap.set("n", "<CR>",  close, opts)
  vim.keymap.set("n", "y", function()
    vim.fn.setreg("+", hash)
    vim.fn.setreg('"', hash)
    close()
    vim.notify("Скопировано: " .. hash, vim.log.levels.INFO, { title = "hashfile" })
  end, opts)
end

--- Запустить picker выбора алгоритма через vim.ui.select,
--- затем вычислить хеш и показать результат.
---@param filepath? string путь к файлу (по умолчанию текущий буфер)
function M.pick(filepath)
  filepath = filepath or vim.api.nvim_buf_get_name(0)

  if filepath == "" then
    vim.notify("hashfile: буфер не привязан к файлу", vim.log.levels.WARN, { title = "hashfile" })
    return
  end

  if vim.fn.filereadable(filepath) ~= 1 then
    vim.notify("hashfile: файл недоступен: " .. filepath, vim.log.levels.ERROR, { title = "hashfile" })
    return
  end

  local items = vim.tbl_map(function(a) return a.label end, ALGORITHMS)

  vim.ui.select(items, {
    prompt = "Выберите алгоритм хеширования:",
    telescope = { layout_config = { width = 0.4, height = 0.5 } },
  }, function(choice)
    if not choice then return end

    local algo
    for _, a in ipairs(ALGORITHMS) do
      if a.label == choice then
        algo = a
        break
      end
    end
    if not algo then return end

    -- Вычисляем в defer чтобы не блокировать UI
    vim.defer_fn(function()
      local hash = compute_hash(filepath, algo.cmd)
      if not hash then
        vim.notify(
          string.format("hashfile: не удалось вычислить %s\n(утилита не найдена или ошибка)", algo.label),
          vim.log.levels.ERROR,
          { title = "hashfile" }
        )
        return
      end
      show_result(algo.label, hash, filepath)
    end, 10)
  end)
end

--- Вычислить хеш файла и вернуть результат в кодировке Base64.
--- Использует compute_hash внутри, затем пропускает через base64.
---@param filepath string абсолютный путь к файлу
---@param cmd_tpl string шаблон команды с %s вместо пути
---@return string|nil base64-строка или nil при ошибке
local function compute_hash_b64(filepath, cmd_tpl)
  local safe_path = vim.fn.shellescape(filepath)
  local cmd = string.format(cmd_tpl, safe_path)
  -- Получаем raw бинарный дайджест и сразу кодируем в base64
  local b64_cmd = string.format(
    "%s 2>/dev/null | awk '{print $1}' | xxd -r -p | base64 | tr -d '\n'",
    cmd
  )
  local handle = io.popen(b64_cmd)
  if not handle then return nil end
  local result = handle:read("*l")
  handle:close()
  if not result or result == "" then return nil end
  return result
end

--- Запустить picker выбора алгоритма через vim.ui.select,
--- затем вычислить хеш в Base64 и показать результат.
---@param filepath? string путь к файлу (по умолчанию текущий буфер)
function M.pick_base64(filepath)
  filepath = filepath or vim.api.nvim_buf_get_name(0)

  if filepath == "" then
    vim.notify("hashfile: буфер не привязан к файлу", vim.log.levels.WARN, { title = "hashfile" })
    return
  end

  if vim.fn.filereadable(filepath) ~= 1 then
    vim.notify("hashfile: файл недоступен: " .. filepath, vim.log.levels.ERROR, { title = "hashfile" })
    return
  end

  local items = vim.tbl_map(function(a) return a.label end, ALGORITHMS)

  vim.ui.select(items, {
    prompt = "Выберите алгоритм (результат в Base64):",
    telescope = { layout_config = { width = 0.4, height = 0.5 } },
  }, function(choice)
    if not choice then return end

    local algo
    for _, a in ipairs(ALGORITHMS) do
      if a.label == choice then
        algo = a
        break
      end
    end
    if not algo then return end

    vim.defer_fn(function()
      local b64 = compute_hash_b64(filepath, algo.cmd)
      if not b64 then
        vim.notify(
          string.format("hashfile: не удалось вычислить %s (base64)\n(утилита не найдена или ошибка)", algo.label),
          vim.log.levels.ERROR,
          { title = "hashfile" }
        )
        return
      end
      show_result(algo.label .. " [Base64]", b64, filepath)
    end, 10)
  end)
end

return M
