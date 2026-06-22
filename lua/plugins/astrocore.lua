-- AstroCore: глобальные настройки, маппинги и which-key группы

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
        ["]b"]        = { function() require("astrocore.buffer").nav(vim.v.count1) end,  desc = "Next buffer" },
        ["[b"]        = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Prev buffer" },
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- which-key группы для пользовательских плагинов
        -- (AstroNvim регистрирует свои группы сам, здесь только дополнения)
        ["<Leader>S"]  = { desc = " SSH" },
        ["<Leader>O"]  = { desc = " Outline" },
        ["<Leader>U"]  = { desc = " Update" },
      },
      i = {
        ["jj"] = { "<Esc>", desc = "Exit insert mode" },
        ["jk"] = false,
      },
    },
  },
}
