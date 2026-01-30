-- Heirline statusline plugin to add user@host component
-- Works with AstroNvim v5 and uses proper Heirline integration

return {
  "rebelot/heirline.nvim",
  optional = true,
  opts = function(_, opts)
    local status = require("astroui.status")
    
    -- Add user@host component
    if not opts.statusline then opts.statusline = {} end
    
    -- Store original statusline
    local original_statusline = vim.deepcopy(opts.statusline)
    
    -- Rebuild statusline with user@host
    opts.statusline = function()
      return {
        hl = { fg = "fg", bg = "bg" },
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } },
        status.component.git_branch(),
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        {
          provider = function()
            local user = os.getenv("USER") or os.getenv("USERNAME") or "user"
            local hostname = vim.fn.hostname()
            return " " .. user .. "@" .. hostname .. " "
          end,
          hl = "StatusLine",
        },
        status.component.lsp(),
        status.component.treesitter(),
        status.component.virtual_env(),
        status.component.nav(),
        status.component.mode { mode_text = { padding = { left = 1, right = 1 } } },
      }
    end
    
    return opts
  end,
}
