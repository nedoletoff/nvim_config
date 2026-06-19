-- Animated starfield on the dashboard
-- Stars cycle through brightness states to simulate twinkling
local glyphs = { " ", "·", "˙", "⋅", "-", "✶", "✷", "-", "⋅", "˙", "·", " " }
local NUM_STARS = 60

local timer = nil
local ns = vim.api.nvim_create_namespace("snacks_starfield")

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local function start_starfield(buf)
  stop_timer()
  if not vim.api.nvim_buf_is_valid(buf) then return end

  local stars = {}
  local initialized = false

  timer = vim.uv.new_timer()
  timer:start(0, 100, vim.schedule_wrap(function()
    -- Проверка валидности буфера
    if not vim.api.nvim_buf_is_valid(buf) then
      stop_timer()
      return
    end

    -- Получаем окно, в котором открыт этот буфер
    local win = vim.fn.bufwinid(buf)
    if win == -1 then return end

    local win_width = vim.api.nvim_win_get_width(win)
    local win_height = vim.api.nvim_win_get_height(win)
    local lines_count = vim.api.nvim_buf_line_count(buf)

    -- КРИТИЧЕСКИЙ ФИКС: Растягиваем буфер на всю высоту окна,
    -- иначе Neovim откажется рисовать звезды на пустом фоне снизу.
    if lines_count < win_height then
      local pad = {}
      for _ = 1, win_height - lines_count do table.insert(pad, "") end
      vim.bo[buf].modifiable = true
      vim.api.nvim_buf_set_lines(buf, lines_count, -1, false, pad)
      vim.bo[buf].modifiable = false
      lines_count = win_height
    end

    -- Инициализируем позиции звезд после того, как узнали точные размеры
    if not initialized then
      for _ = 1, NUM_STARS do
        table.insert(stars, {
          r = math.random(0, math.max(0, lines_count - 1)),
          c = math.random(0, math.max(0, win_width - 1)),
          phase = math.random(1, #glyphs),
          speed = math.random(1, 3),
          cnt = 0
        })
      end
      initialized = true
    end

    -- Очищаем старые кадры
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    -- Рендерим новый кадр
    for _, s in ipairs(stars) do
      s.cnt = s.cnt + 1
      if s.cnt >= s.speed then
        s.cnt = 0
        s.phase = s.phase % #glyphs + 1
        
        -- Возрождаем звезду в новой случайной точке, если она потухла
        if s.phase == 1 then
          s.r = math.random(0, math.max(0, lines_count - 1))
          s.c = math.random(0, math.max(0, win_width - 1))
          s.speed = math.random(1, 3)
        end
      end

      local line = lines[s.r + 1] or ""
      local is_empty = true

      -- Быстрая проверка на коллизию с текстом дашборда (ASCII арт и меню).
      -- Находим первый и последний непробельные символы в строке
      local first_non_space = string.find(line, "%S")
      if first_non_space then
        local last_non_space = string.find(line, "%S%s*$")
        -- Скрываем звезду, если она попала в "прямоугольник" текста
        if last_non_space and s.c >= (first_non_space - 1) and s.c <= (last_non_space - 1) then
          is_empty = false
        end
      end

      -- Рисуем через extmark с параметром overlay
      if is_empty then
        pcall(vim.api.nvim_buf_set_extmark, buf, ns, s.r, 0, {
          virt_text = { { glyphs[s.phase], "Comment" } },
          virt_text_pos = "overlay",
          virt_text_win_col = s.c,
          priority = 1,
        })
      end
    end
  end))
end

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}
      
      local group = vim.api.nvim_create_augroup("SnacksStarfield", { clear = true })
      
      -- Триггерим по факту открытия буфера дашборда
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "snacks_dashboard",
        callback = function(ev)
          vim.defer_fn(function()
            start_starfield(ev.buf)
          end, 100) -- Даем Snacks 100мс на отрисовку структуры
        end,
      })

      -- Корректная остановка при переходе в другой файл
      vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
        group = group,
        callback = function(ev)
          if vim.bo[ev.buf].filetype == "snacks_dashboard" then
            stop_timer()
          end
        end,
      })
    end,
  },
}
