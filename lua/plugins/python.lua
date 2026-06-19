-- Python debugging configuration (DAP)
-- NOTE: pyright + ruff + black уже установлены через astrocommunity.pack.python
-- Здесь только DAP UI и кастомные keybindings для дебаггера

return {
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<Leader>du", function() require("dapui").toggle() end, desc = "DAP: toggle UI" },
      { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: breakpoint" },
      { "<Leader>dc", function() require("dap").continue() end, desc = "DAP: continue" },
      { "<Leader>dn", function() require("dap").step_over() end, desc = "DAP: step over" },
      { "<Leader>di", function() require("dap").step_into() end, desc = "DAP: step into" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
}
