-- Add user@host component to statusline with colors
-- Simple provider that displays user@hostname with highlighting

return {
  {
    "rebelot/heirline.nvim",
    optional = true,
    opts = function(_, opts)
      local status = require("astroui.status")

      -- Get the statusline config
      if opts.statusline then
        -- If statusline is a function, call it to get the table
        local statusline_table = type(opts.statusline) == "function" and opts.statusline() or opts.statusline

        -- Add user@host component in the middle-right area with colors
        local user_host_component = {
          {
            provider = function()
              return os.getenv("USER") or os.getenv("USERNAME") or "user"
            end,
            hl = "StatuslineUser",
          },
          {
            provider = function()
              return "@"
            end,
            hl = "StatuslineAt",
          },
          {
            provider = function()
              return vim.fn.hostname()
            end,
            hl = "StatuslineHost",
          },
        }

        -- Insert the user@host component before the mode at the end
        for i, component in ipairs(user_host_component) do
          table.insert(statusline_table, #statusline_table, component)
        end

        -- Set it back as a table, not a function
        opts.statusline = statusline_table
      end

      return opts
    end,
  },
}
