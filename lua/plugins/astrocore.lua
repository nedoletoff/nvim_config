-- AstroCore: глобальные настройки, маппинги и which-key группы
--
-- Схема групп (заглавные ≠ строчные, чтобы избежать путаницы):
--   s  → Find/Search     (AstroNvim — snacks picker)
--   S  → Session         (AstroNvim — resession)
--   g  → Git             (AstroNvim + diffview + neogit)
--   h  → Hash            (наш: hashfile.lua)
--   m  → Project → MD    (наш: project-to-md.lua)
--   x  → Quickfix/Lists  (AstroNvim + trouble)
--   u  → UI/UX           (AstroNvim)
--   U  → Update          (наш: nvim-updater.lua)
--   b  → Buffers         (наши bn/bp/bd/bb; AstroNvim — Ctrl-b)
--   c  → CodeCompanion   (наш: codecompanion.lua — ca/cc/ci)
--   d  → Debugger        (AstroNvim)
--   l  → Language Tools  (AstroNvim)
--   p  → Packages        (AstroNvim — mason)
--   t  → Terminal        (AstroNvim)
--   f  → Find            (AstroNvim — алиас s)
--   D  → Dance           (наш: dance_time.lua)
--   SSH → отдельная группа <Leader>Sцифра (не пересекается)

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 },
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    options = {
      opt = {
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,
        colorcolumn = "120",
      },
    },
    autocmds = {
      text_wrap = {
        {
          event = "FileType",
          pattern = { "text", "markdown", "norg", "org", "gitcommit" },
          callback = function(args)
            vim.wo.wrap = true
            vim.wo.linebreak = true
            -- j/k moves by visual (wrapped) lines, line numbers stay real
            vim.keymap.set("n", "j", "gj", { buffer = args.buf, silent = true })
            vim.keymap.set("n", "k", "gk", { buffer = args.buf, silent = true })
            vim.keymap.set("n", "0", "g0", { buffer = args.buf, silent = true })
            vim.keymap.set("n", "^", "g^", { buffer = args.buf, silent = true })
            vim.keymap.set("n", "$", "g$", { buffer = args.buf, silent = true })
          end,
        },
      },
    },
    mappings = {
      n = {
        -- Буферы: семейство начинается с b
        ["bn"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["bp"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Prev buffer" },
        ["bd"] = { function() require("astrocore.buffer").close() end, desc = "Close buffer" },
        ["bb"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Buffer picker",
        },

        -- Explorer + Outline вместе (переопределяем AstroNvim <Leader>o)
        ["<Leader>o"] = {
          function()
            vim.cmd("Neotree toggle")
            vim.cmd("Outline")
          end,
          desc = "Toggle Explorer + Outline",
        },

        -- Toggle wrap (для текстовых файлов)
        ["<Leader>tw"] = {
          function()
            vim.wo.wrap = not vim.wo.wrap
            local mode = vim.wo.wrap and "ON" or "OFF"
            vim.notify("Wrap: " .. mode)
          end,
          desc = "Toggle wrap",
        },

        -- Dance Time
        ["<Leader>DT"] = {
          function() require("user.dance_time").toggle() end,
          desc = "Dance Time! ✧ (^ω^) ✧",
        },

        -- which-key подписи для пользовательских групп
        -- SSH: занимаем S1..S9 (с цифрой), не пересекаемся с Session (S без цифры)
        -- Наша группа SSH зарегистрирована через ssh-launcher.lua
        --
        -- Именно desc, а не group: group = в which-key v3 не создаёт
        -- keymap, из-за чего пропадали реальные <Leader>DT и <Leader>h.
        -- Пустые группы m/U which-key v3 не показывает — это его
        -- поведение, а не ошибка конфига (проверено: :checkhealth which-key
        -- сообщает "No issues reported", наложений и дублей нет).
        ["<Leader>h"] = { desc = "󰯪 Hash file" },
        ["<Leader>m"] = { desc = "󱌀 Project → Markdown" },
        ["<Leader>U"] = { desc = "󰑙 Update" },
        ["<Leader>D"] = { desc = "🕹 Dance" },
        ["<Leader>t"] = { desc = "󰖌 Toggle" },
        ["<Leader>c"] = { desc = "󰚩 CodeCompanion" },
      },
      i = {
        ["jj"] = { "<Esc>", desc = "Exit insert mode" },
        ["jk"] = false,
      },
    },
  },
}
