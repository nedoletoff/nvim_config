-- Python debugging configuration (DAP)
-- Requires: debugpy, nvim-dap, nvim-dap-python, nvim-dap-ui

return {
  -- Debug Adapter Protocol
  { "mfussenegger/nvim-dap", lazy = true },
  -- Python-specific DAP configuration
  {
    "mfussenegger/nvim-dap-python",
    lazy = true,
    ft = "python",
    config = function()
      local dap_python = require "dap-python"
      dap_python.setup "python"

      local dap = require "dap"
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return "python"
          end,
        },
      }
    end,
  },
  -- DAP UI for interactive debugging
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      dapui.setup()

      -- Auto-open/close DAP UI on debug session
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
