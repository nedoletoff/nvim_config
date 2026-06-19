-- Animated starfield on the dashboard
-- Stars cycle through brightness states to simulate twinkling

local glyphs = { " ", "·", "˙", "⋅", "-", "✶", "✷", "-", "⋅", "˙", "·", " " }
local ROWS = 15
local COLS = 60
local NUM_STARS = 20

local stars = {}
local timer = nil

local function init_stars()
  stars = {}
  math.randomseed(os.time())
  for _ = 1, NUM_STARS do
    table.insert(stars, {
      row = math.random(1, ROWS),
      col = math.random(1, COLS),
      phase = math.random(1, #glyphs),
      speed = math.random(1, 3),
      counter = 0,
    })
  end
end

local function render_stars()
  local grid = {}
  for r = 1, ROWS do
    grid[r] = {}
    for c = 1, COLS do
      grid[r][c] = " "
    end
  end

  for _, s in ipairs(stars) do
    s.counter = s.counter + 1
    if s.counter >= s.speed then
      s.counter = 0
      s.phase = s.phase % #glyphs + 1
      if s.phase == 1 then
        s.row = math.random(1, ROWS)
        s.col = math.random(1, COLS)
        s.speed = math.random(1, 3)
      end
    end
    grid[s.row][s.col] = glyphs[s.phase]
  end

  local lines = {}
  for r = 1, ROWS do
    lines[r] = table.concat(grid[r])
  end
  return lines
end

local function starfield_section()
  return {
    align = "center",
    padding = 1,
    text = {
      { table.concat(render_stars(), "\n"), hl = "Comment" },
    },
  }
end

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.sections = opts.dashboard.sections or {}

      init_stars()

      table.insert(opts.dashboard.sections, 1, function()
        return starfield_section()
      end)

      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          stop_timer()
          timer = vim.uv.new_timer()
          timer:start(0, 120, vim.schedule_wrap(function()
            local ok, Snacks = pcall(require, "snacks")
            if ok and Snacks and Snacks.dashboard then
              Snacks.dashboard.update()
            end
          end))
        end,
      })

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = stop_timer,
      })
    end,
  },
}
