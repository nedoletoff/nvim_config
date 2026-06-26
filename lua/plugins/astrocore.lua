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
--   b  → Buffers         (AstroNvim)
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
    mappings = {
      n = {
        -- Буферы
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end,  desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Prev buffer" },
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- Explorer + Outline вместе (переопределяем AstroNvim <Leader>o)
        ["<Leader>o"] = {
          function()
            vim.cmd("Neotree toggle")
            vim.cmd("Outline")
          end,
          desc = "Toggle Explorer + Outline",
        },

        -- Dance Time
        ["<Leader>DT"] = {
          function() require("user.dance_time").toggle() end,
          desc = "Dance Time! ✧ (^ω^) ✧",
        },

        -- which-key подписи для пользовательских групп
        -- SSH: занимаем S1..S9 (с цифрой), не пересекаемся с Session (S без цифры)
        -- Наша группа SSH зарегистрирована через ssh-launcher.lua
        ["<Leader>h"] = { desc = "󰯪 Hash file" },
        ["<Leader>m"] = { desc = "󱌀 Project → Markdown" },
        ["<Leader>U"] = { desc = "󰑙 Update" },
        ["<Leader>D"] = { desc = "🕹 Dance" },
      },
      i = {
        ["jj"] = { "<Esc>", desc = "Exit insert mode" },
        ["jk"] = false,
      },
    },
  },
}
