-- Add user@host component to statusline
-- Simple provider that displays user@hostname

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

        -- Add user@host component in the middle-right area
        -- Find the fill component and add after it
        local user_host_component = {
          provider = function()
            local user = os.getenv("USER") or os.getenv("USERNAME") or "user"
            local hostname = vim.fn.hostname()
            return " " .. user .. "@" .. hostname .. " "
          end,
          hl = "StatusLine",
        }

        -- Insert the user@host component before the mode at the end
        table.insert(statusline_table, #statusline_table, user_host_component)

        -- Set it back as a table, not a function
        opts.statusline = statusline_table
      end

      return opts
    end,
  },
}
