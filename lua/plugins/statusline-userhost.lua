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
          -- Separator with spacing
          {
            provider = " ",
            hl = "StatusLine",
          },
          -- User component with theme colors
          {
            provider = function()
              return (os.getenv("USER") or os.getenv("USERNAME") or "user")
            end,
            hl = function()
              local colors = require("astroui.colors")
              return {
                fg = colors.get_hlgroup("Visual").fg or colors.yellow,
                bg = colors.get_hlgroup("Normal").bg or colors.bg,
                bold = true,
              }
            end,
          },
          -- @ symbol
          {
            provider = "@",
            hl = function()
              local colors = require("astroui.colors")
              return {
                fg = colors.get_hlgroup("String").fg or colors.green,
              }
            end,
          },
          -- Host component with theme colors
          {
            provider = function()
              return vim.fn.hostname()
            end,
            hl = function()
              local colors = require("astroui.colors")
              return {
                fg = colors.get_hlgroup("Function").fg or colors.blue,
              }
            end,
          },
          -- Trailing space
          {
            provider = " ",
            hl = "StatusLine",
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
