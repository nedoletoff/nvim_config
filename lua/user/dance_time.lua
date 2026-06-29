local M = {}

-- Все строки в каждом фрейме должны быть ровно WIN_W = 22 символа
-- Это предотвращает смещение элементов (головы, рук, ног) между кадрами
local frames = {
    -- Оригинальные 12
    { "  (\\ (\\ ",     "  ( •ω•) ",    "  /| |\\ ", "  \\| |/ " },
    { "  (\\ (\\ ",     "  ( •ω•) ",    "  \\| |/ ", "  /| |\\ " },
    { "  ♪ \\(•ω•)/ ♫", "    | | ",     "   / \\ ", "        " },
    { "  ♫ \\(^ω^)/ ♪", "    | | ",     "   / \\ ", "        " },
    { "  (\\ (\\ ",     "  ( ˘ω˘) ♪",   "  /( )\\ ", "   U U " },
    { "  (\\ (\\ ",     "  ( ˘ω˘) ♫",   "  \\( )/ ", "   U U " },
    { "  (=•ω•=)",     "  (/| |\\) ♬",  "   /| |\\ ", "        " },
    { "  (=•ω•=)",     "  (\\| |/) ♩",  "   \\| |/ ", "        " },
    { "  ♪ \\(^▽^)/ ♫ ", "   | || | ",  "   (_)(_) ", "        " },
    { "  ♫ \\(^▽^)/ ♪ ", "   __| |__ ",  "         ", "        " },
    { "  (★ω★) ",      "   \\( | | )/ ", "    | | | ", "   _| |_ " },
    { "  (★ω★) ✨ ",   "   \\(| |)/ ",   "    | | | ", "   _| |_ " },
    -- Новые: прыжки, вращения, эмоции (13-23)
    { "   (\\ (\\ ",     "  ( ˃ ◡ ˂ ) ", "   /| |\\ ", "   /| |\\ " },
    { "  ♬ \\(>ω<)/ ♬", "    | | ",     "   /| |\\ ", "    | | " },
    { "  (=^ω^=)",     "   /| |\\  ♪",  "   /| |\\ ", "        " },
    { "  (=^ω^=)",     "   /| |\\  ♪",  "   /| |\\ ", "        " },
    { "  (o^ω^o)",     "   /| |\\ ♪",   "   /| |\\ ", "    U U " },
    { "  (o^ω^o) ♬",   "   /| |\\ ",    "   /| |\\ ", "   _U U_ " },
    { "  (≧ω≦) ",      "   /| |\\  ♪",  "   /| |\\ ", "   _U U_ " },
    { "  (≧ω≦) ",      "   /| |\\  ♫",  "   /| |\\ ", "   _U U_ " },
    { "  ♪ (o^ω^o) ♫", "   /| |\\ ",    "    | | | ", "   _| |_ " },
    { "  ♬ \\(^ω^)/ ♬", "    | | ",     "   /| |\\ ", "    | | " },
    { "  ♭ (^ω^) ♭ ",  "   /| |\\ ",    "    | | | ", "   _| |_ " },
}

local particles = {
    "♪", "♫", "♬", "♩", "✨", "💫", "⭐", "🌸",
    "💕", "🎵", "🎉", "🦋", "🌟", "🎶",
}

local header_colors = {
    "#ff79c6", "#bd93f9", "#8be9fd", "#50fa7b",
    "#ffb86c", "#ff5555", "#f1fa8c", "#ff79c6",
    "#50fa7b", "#bd93f9", "#8be9fd", "#ffb86c",
}

local WIN_W = 22
local WIN_H = 9

local state = {
    buf = -1, win = -1, timer = nil,
    frame_idx = 1, pos_x = 0, pos_y = 0,
    dir_x = 1, dir_y = 1, tick = 0, move_tick = 0,
}

local function get_screen_size()
    return vim.o.columns, vim.o.lines - vim.o.cmdheight - 2
end

-- Дополняет строку пробелами до фиксированной ширины
local function pad_to_width(str, width)
    local len = vim.fn.strchars(str)
    if len >= width then
        return str
    end
    return str .. string.rep(" ", width - len)
end

local function render_frame()
    if not vim.api.nvim_buf_is_valid(state.buf) then return end

    local f = frames[state.frame_idx]
    local color = header_colors[((state.frame_idx - 1) % #header_colors) + 1]
    local p1 = particles[math.random(#particles)]
    local p2 = particles[math.random(#particles)]

    vim.cmd("hi DanceTimeTitle guifg=" .. color .. " guibg=#1a1a2e gui=bold")

    -- Pad все строки до WIN_W чтобы элементы не съезжали
    local lines = {
        pad_to_width("  " .. p1 .. " ✧ DANCE TIME ✧ " .. p2, WIN_W),
        pad_to_width("╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌", WIN_W),
        pad_to_width("", WIN_W),
    }
    for _, l in ipairs(f) do
        table.insert(lines, pad_to_width(l, WIN_W))
    end
    while #lines < WIN_H do
        table.insert(lines, pad_to_width("", WIN_W))
    end

    vim.api.nvim_buf_set_option(state.buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(state.buf, "modifiable", false)

    state.frame_idx = (state.frame_idx % #frames) + 1
end

local function move_window()
    if not vim.api.nvim_win_is_valid(state.win) then return end

    local cols, rows = get_screen_size()
    state.tick = state.tick + 1

    -- Двигаем окно только каждые 4 тика (720мс вместо 180мс)
    if state.tick % 4 == 0 then
        state.move_tick = state.move_tick + 1
        local wave = math.floor(math.sin(state.move_tick * 0.15) * 2)

        state.pos_x = state.pos_x + state.dir_x
        state.pos_y = state.pos_y + state.dir_y + wave

        if state.pos_x <= 0 then
            state.pos_x = 0
            state.dir_x = 1
        end
        if state.pos_y <= 0 then
            state.pos_y = 0
            state.dir_y = 1
        end
        if state.pos_x + WIN_W >= cols then
            state.pos_x = cols - WIN_W - 2
            state.dir_x = -1
        end
        if state.pos_y + WIN_H >= rows then
            state.pos_y = rows - WIN_H - 2
            state.dir_y = -1
        end

        vim.api.nvim_win_set_config(state.win, {
            relative = "editor",
            row = state.pos_y,
            col = state.pos_x,
        })
    end
end

function M.toggle()
    if vim.api.nvim_win_is_valid(state.win) then
        if state.timer then
            state.timer:stop()
            state.timer:close()
            state.timer = nil
        end
        pcall(vim.api.nvim_win_close, state.win, true)
        state.win = -1
        return
    end

    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(state.buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(state.buf, "filetype", "dance_time")

    local cols, rows = get_screen_size()
    -- Инициализируем по центру экрана
    state.pos_x = math.floor((cols - WIN_W) / 2)
    state.pos_y = math.floor((rows - WIN_H) / 2)
    state.dir_x = (math.random(2) == 1) and 1 or -1
    state.dir_y = (math.random(2) == 1) and 1 or -1
    state.tick = 0
    state.move_tick = 0

    state.win = vim.api.nvim_open_win(state.buf, false, {
        relative = "editor",
        width = WIN_W,
        height = WIN_H,
        row = state.pos_y,
        col = state.pos_x,
        style = "minimal",
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        zindex = 200,
        focusable = false,
    })

    vim.cmd [[
        hi DanceTimeNormal guibg=#1a1a2e guifg=#f8f8f2
        hi DanceTimeBorder guifg=#bd93f9 guibg=#1a1a2e
        hi DanceTimeTitle guifg=#ff79c6 guibg=#1a1a2e gui=bold
    ]]
    vim.api.nvim_win_set_option(state.win, "winhl",
        "Normal:DanceTimeNormal,FloatBorder:DanceTimeBorder")

    vim.api.nvim_buf_call(state.buf, function()
        vim.cmd "syntax match DanceTimeTitle /.*DANCE TIME.*/"
        vim.cmd "syntax match DanceTimeBorder /[╌─╭╮╯╰│]/"
    end)

    state.timer = vim.loop.new_timer()
    state.timer:start(0, 180, vim.schedule_wrap(function()
        if not vim.api.nvim_win_is_valid(state.win) then
            if state.timer then
                state.timer:stop()
                state.timer:close()
                state.timer = nil
            end
            return
        end
        render_frame()
        move_window()
    end))
end

vim.api.nvim_create_autocmd("WinClosed", {
    pattern = "*",
    callback = function(ev)
        if state.win ~= -1 and tostring(state.win) == ev.match then
            if state.timer then
                state.timer:stop()
                state.timer:close()
                state.timer = nil
            end
            state.win = -1
        end
    end,
})

return M
