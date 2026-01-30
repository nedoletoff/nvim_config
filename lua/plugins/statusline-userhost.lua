-- Add user@host component to statusline with colors from theme
-- Simple provider that displays user@hostname with highlighting and separator

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

        -- Add user@host component with separator and colors from theme
        local user_host_component = {
          -- Separator before user@host component
          {
            provider = status.sep.left,
            hl = function()
              return {
                fg = "StatuslineUser",
                bg = "StatusLine",
              }
            end,
          },
          -- User component with theme colors
          {
            provider = function()
              return " " .. (os.getenv("USER") or os.getenv("USERNAME") or "user") .. " "
            end,
            hl = function()
              return {
                fg = status.hl.lualine_b_visual.fg,
                bg = status.hl.lualine_a_visual.fg,
                bold = true,
              }
            end,
          },
          -- @ symbol with accent color
          {
            provider = "@",
            hl = function()
              return {
                fg = status.hl.lualine_c_normal.fg,
              }
            end,
          },
          -- Host component with theme colors
          {
            provider = function()
              return vim.fn.hostname()
            end,
            hl = function()
              return {
                fg = status.hl.lualine_b_command.fg,
              }
            end,
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
