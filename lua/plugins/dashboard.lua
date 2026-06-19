-- Animated starfield on the dashboard
-- Stars cycle through brightness states to simulate twinkling
local glyphs = { " ", "◦", "⋆", "☆", "★", "✦", "✪", "✷", "✹", "✺"," " }-- Используем стандартные группы Neovim для разноцветных звезд
local hl_groups = { "String", "Function", "Constant", "Type", "Special", "Title" }
local NUM_STARS = 50

local timer = nil
local ns = vim.api.nvim_create_namespace("snacks_starfield")

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

local function start_starfield(buf, win)
  stop_timer()
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then return end

  local stars = {}

  local function is_in_deadzone(r, c, win_w, win_h)
    local center_r = math.floor(win_h / 2)
    local center_c = math.floor(win_w / 2)
    local safe_width = 45
    local safe_height = 25

    local min_r = center_r - math.floor(safe_height / 2)
    local max_r = center_r + math.floor(safe_height / 2)
    local min_c = center_c - math.floor(safe_width / 2)
    local max_c = center_c + math.floor(safe_width / 2)

    return (r >= min_r and r <= max_r) and (c >= min_c and c <= max_c)
  end

  local function spawn_star(win_w, win_h)
    local r, c
    repeat
      r = math.random(0, win_h - 1)
      c = math.random(0, win_w - 1)
    until not is_in_deadzone(r, c, win_w, win_h)

    return {
      r = r,
      c = c,
      phase = math.random(1, #glyphs),
      speed = math.random(1, 3),
      color = hl_groups[math.random(1, #hl_groups)], -- Присваиваем случайный цвет
      cnt = 0
    }
  end

  timer = vim.uv.new_timer()
  timer:start(100, 100, vim.schedule_wrap(function()
    if not vim.api.nvim_buf_is_valid(buf) or vim.api.nvim_get_current_buf() ~= buf then
      stop_timer()
      return
    end

    local win_w = vim.api.nvim_win_get_width(win)
    local win_h = vim.api.nvim_win_get_height(win)
    local lines_count = vim.api.nvim_buf_line_count(buf)

    if lines_count < win_h then
      vim.bo[buf].modifiable = true
      local pad = {}
      for _ = 1, win_h - lines_count do table.insert(pad, "") end
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, pad)
      vim.bo[buf].modifiable = false
      lines_count = win_h
    end

    if #stars == 0 then
      for _ = 1, NUM_STARS do
        table.insert(stars, spawn_star(win_w, win_h))
      end
    end

    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

    for _, s in ipairs(stars) do
      s.cnt = s.cnt + 1
      if s.cnt >= s.speed then
        s.cnt = 0

        -- Случайный сдвиг фазы: 0 (залипание), 1 (норма), 2 (пропуск)
        local step = math.random(0, 2)
        s.phase = s.phase + step

        -- Возрождение звезды, если она потухла (вышла за границы массива)
        if s.phase > #glyphs then
          local new_pos = spawn_star(win_w, win_h)
          s.r, s.c = new_pos.r, new_pos.c
          s.speed = new_pos.speed
          s.color = new_pos.color
          s.phase = 1
        end
      end

      local char = glyphs[s.phase] or " "

      pcall(vim.api.nvim_buf_set_extmark, buf, ns, s.r, 0, {
        virt_text = { { char, s.color } },
        virt_text_pos = "overlay",
        virt_text_win_col = s.c,
        ephemeral = false,
        priority = 1,
      })
    end
  end))
end

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}

      local group = vim.api.nvim_create_augroup("SnacksStarfield", { clear = true })

      -- Запуск после события отрисовки Snacks
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "SnacksDashboardUpdatePost",
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local win = vim.api.nvim_get_current_win()
          if vim.bo[buf].filetype == "snacks_dashboard" then
            start_starfield(buf, win)
          end
        end,
      })

      -- Остановка
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
