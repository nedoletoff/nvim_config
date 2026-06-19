-- Animated starfield on the dashboard
-- Stars cycle through brightness states to simulate twinkling

local M = {}

-- Star brightness levels (dim -> bright -> dim)
local glyphs = { " ", "·", "˙", "⋅", "- ", "*", "✶", "✷", "- ", "⋅", "˙", "·", " " }
-- Canvas: rows x cols of stars, each with a random phase offset
local ROWS = 4
local COLS = 60
local NUM_STARS = 20  -- active stars at once

-- Initialize star state
local stars = {}
local timer = nil
local tick = 0

local function init_stars()
    stars = {}
    math.randomseed(os.time())
    for _ = 1, NUM_STARS do
        table.insert(stars, {
              row = math.random(1, ROWS),
              col = math.random(1, COLS),
              phase = math.random(1, #glyphs),
              speed = math.random(1, 3), -- frames per step
              counter = 0,
            })
      end
  end

local function render_stars()
    -- Build a grid of spaces
    local grid = {}
    for r = 1, ROWS do
        grid[r] = {}
        for c = 1, COLS do
            grid[r][c] = " "
          end
      end

    -- Place each star
    for _, s in ipairs(stars) do
        s.counter = s.counter + 1
        if s.counter >= s.speed then
            s.counter = 0
            s.phase = s.phase % #glyphs + 1
            -- When a star fades out completely, move it to a new random position
            if s.phase == 1 then
                s.row = math.random(1, ROWS)
                s.col = math.random(1, COLS)
                s.speed = math.random(1, 3)
              end
          end
        grid[s.row][s.col] = glyphs[s.phase]
      end

    -- Convert grid to lines
    local lines = {}
    for r = 1, ROWS do
        lines[r] = table.concat(grid[r])
      end
    return lines
  end

local function stop_timer()
    if timer then
        timer:stop()
        timer:close()
        timer = nil
      end
  end

-- The snacks dashboard section that renders the starfield
local function starfield_section()
    local lines = render_stars()
    local result = {}
    for _, line in ipairs(lines) do
        table.insert(result, { line, hl = "Comment" })
      end
    return result
  end

return {
    {
        "folke/snacks.nvim",
        opts = function(_, opts)
            opts.dashboard = opts.dashboard or {}
            opts.dashboard.sections = opts.dashboard.sections or {}

                  init_stars()

            -- Starfield section: returns text lines, snacks renders them
      local starfield = {
        padding = 1,
                text = function()
                    return starfield_section()
                  end,
              }

            -- Add starfield before existing sections
            table.insert(opts.dashboard.sections, 1, starfield)

            -- Auto-stop timer when leaving dashboard
            vim.api.nvim_create_autocmd("BufLeave", {
                  pattern = "snacks_dashboard",
                  once = false,
                  callback = stop_timer,
                })

            -- Start animation timer when dashboard opens
            vim.api.nvim_create_autocmd("BufEnter", {
                  pattern = "snacks_dashboard",
                  once = false,
                  callback = function()
                      stop_timer()
                      timer = vim.uv.new_timer()
                      timer:start(0, 120, vim.schedule_wrap(function()
                              local ok, dashboard = pcall(require, "snacks.dashboard")
                              if ok and dashboard and dashboard.update then
                                  dashboard.update()
                                end
                            end))
                    end,
                })
          end,
      },
  }
