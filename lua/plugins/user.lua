---@type LazySpec
return {
  -- Discord Presence
  "andweeb/presence.nvim",

  -- LSP function signature hints
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- Кастомный dashboard header
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            "        ▒▓▓▓▓▓█    ▒▓▓▓█     ▒▓▓█        ",
            "          ▒▓█     ▒▓▌   █   ▒▓▌ ▓█       ",
            "         ▒▓█     ▒▓▌    █  ▒▓▌   ▓█      ",
            "        ▒▓█     ▒▓█▀▀▀▀▀  ▒▓█▀▀▀▀▀█      ",
            "       ▒▓█     ▒▓█       ▒▓█      ▓█     ",
            "     ▒▓▓▓▓█   ▒▓█       ▒▓▓▓█    ▒▓▓█    ",
            "                                            ▀█▀",
            "  ▒▓▓▓▓█  ▒▓▓▓▓█                            █",
            "    ▒▓▓█    ▒▓█          ▓▌                 ▒▓█",
            "   ▒▓█  ▌  ▒▓█  ▒▓   ▓▌      ▓█▓   ▓▓▓▌    ▒▓▓▓█",
            "  ▒▓█   ▐ ▒▓█    ▓  ▓▌  ▓▌  ▓▌ ▓  ▓▌ ▓▌    ▒▓▓▓█",
            " ▒▓█     ▒▓█     ▓ ▓▌  ▓▌  ▓▌   ▓▌   ▓▌    ▒▓▓▓█",
            "▒▓▓▓█   ▒▓▓▓█     ▓▌  ▓▌  ▓▌        ▓▌     ▒▓▓▓█",
            "\n\n",
            "·  nedoletoff / astrovim  ·",
            "──────────────────────────────────────",
          }, "\n"),
        },
      },
    },
  },

  { "max397574/better-escape.nvim", enabled = false },
}
