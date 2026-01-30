-- Add user@host component to statusline
-- Displays user@hostname in the statusline with colors

return {
  {
    "rebelot/heirline.nvim",
    optional = true,
    opts = function(_, opts)
      -- Get the statusline config
      if opts.statusline then
        -- If statusline is a function, call it to get the table
        local statusline_table = type(opts.statusline) == "function" and opts.statusline() or opts.statusline

        -- Add user@host component with separator and colors
        local user_host_component = {
          -- Separator with spacing
          {
            provider = " ",
            hl = "StatusLine",
          },
          -- User component
          {
            provider = function()
              return (os.getenv("USER") or os.getenv("USERNAME") or "user")
            end,
            hl = "Visual",
          },
          -- @ symbol
          {
            provider = "@",
            hl = "String",
          },
          -- Host component
          {
            provider = function()
              return vim.fn.hostname()
            end,
            hl = "Function",
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
