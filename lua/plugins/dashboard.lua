-- Animated starfield on the dashboard
-- Stars cycle through brightness states to simulate twinkling
local glyphs = { " ", "·", "˙", "⋅", "-", "✶", "✷", "-", "⋅", "˙", "·", " " }
local NUM_STARS = 50 -- Количество звезд на всем экране

local timer = nil
local ns = vim.api.nvim_create_namespace("snacks_starfield")

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local function start_starfield()
  stop_timer()
  
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local stars = {}

  -- Функция спавна звезды в случайном пустом месте
  local function spawn_star()
    local lines_count = vim.api.nvim_buf_line_count(buf)
    local win_width = vim.api.nvim_win_get_width(win)
    return {
      r = math.random(0, math.max(0, lines_count - 1)),
      c = math.random(0, math.max(0, win_width - 1)),
      phase = math.random(1, #glyphs),
      speed = math.random(1, 3),
      cnt = 0
    }
  end

  for _ = 1, NUM_STARS do
    table.insert(stars, spawn_star())
  end

  timer = vim.uv.new_timer()
  timer:start(0, 100, vim.schedule_wrap(function()
    -- Прерываем, если ушли с дашборда
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_get_current_buf() ~= buf then
      stop_timer()
      return
    end

    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local win_width = vim.api.nvim_win_get_width(win)

    for _, s in ipairs(stars) do
      s.cnt = s.cnt + 1
      if s.cnt >= s.speed then
        s.cnt = 0
        s.phase = s.phase % #glyphs + 1
        
        -- Перемещение звезды после затухания
        if s.phase == 1 then
          local new_s = spawn_star()
          s.r, s.c, s.speed = new_s.r, new_s.c, new_s.speed
        end
      end

      -- Проверка на то, чтобы не затирать текст (ascii арт или меню)
      if s.r < #lines and s.c < win_width then
        local line = lines[s.r + 1]
        local is_empty = true
        
        -- Если координата попадает на длину текущей строки, проверяем символ
        if s.c < vim.fn.strchars(line) then
          local char = vim.fn.strcharpart(line, s.c, 1)
          if char ~= " " and char ~= "" then
            is_empty = false
          end
        end

        -- Отрисовка extmark только на пустом месте
        if is_empty then
          pcall(vim.api.nvim_buf_set_extmark, buf, ns, s.r, 0, {
            virt_text = { { glyphs[s.phase], "Comment" } },
            virt_text_win_col = s.c,
            priority = 1,
          })
        end
      end
    end
  end))
end

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}
      
      -- Автокоманды для контроля жизненного цикла анимации
      local group = vim.api.nvim_create_augroup("SnacksStarfield", { clear = true })
      
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "snacks_dashboard",
        callback = function()
          -- Даем дашборду мгновение на отрисовку структуры, затем пускаем звезды
          vim.defer_fn(start_starfield, 50)
        end,
      })

      vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
        group = group,
        pattern = "*",
        callback = function(ev)
          if vim.bo[ev.buf].filetype == "snacks_dashboard" then
            stop_timer()
          end
        end,
      })
    end,
  },
}
