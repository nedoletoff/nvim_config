return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>mv", "<cmd>Markview enable<cr>", desc = "Markview: Включить" },
    { "<leader>mr", "<cmd>Markview disable<cr>", desc = "Markview: Отключить" },
  },
  config = function()
    local markview = require("markview")

    markview.setup({
      headings = {
        enable = true,
        heading_1 = { style = "label", sign = "󰼏 ", icon = "󰼏 ", hl = "GruvboxRedBold" },
        heading_2 = { style = "label", sign = "󰼐 ", icon = "󰼐 ", hl = "GruvboxGreenBold" },
        heading_3 = { style = "label", sign = "󰼑 ", icon = "󰼑 ", hl = "GruvboxYellowBold" },
        heading_4 = { style = "label", sign = "󰼒 ", icon = "󰼒 ", hl = "GruvboxBlueBold" },
        heading_5 = { style = "label", sign = "󰼓 ", icon = "󰼓 ", hl = "GruvboxPurpleBold" },
        heading_6 = { style = "label", sign = "󰼔 ", icon = "󰼔 ", hl = "GruvboxAquaBold" },
      },

      code_blocks = {
        enable = true,
        style = "bordered",
        hl = "GruvboxBg1",
      },

      tables = {
        enable = true,
        use_virt_lines = true,
      },

      list_items = {
        enable = true,
        marker_plus = { add = " ", hl = "GruvboxGreen" },
        marker_minus = { add = " ", hl = "GruvboxRed" },
        marker_star = { add = " ", hl = "GruvboxYellow" },
      },

      callouts = {
        enable = true,
      },
    })
  end,
}
