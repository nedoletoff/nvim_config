-- Quiet mode: suppress annoying notifications
-- Filters out Mason installation messages and lspconfig warnings

return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    -- Override vim.notify to filter out noise
    local original_notify = vim.notify
    vim.notify = function(msg, level, notify_opts)
      -- Suppress these annoying patterns
      local suppress_patterns = {
        "mason%-tool%-installer",  -- mason-tool-installer messages
        "installing",              -- installation messages
        "already installed",       -- already installed messages  
        "lspconfig",               -- lspconfig deprecation warnings
        "deprecated",              -- deprecation warnings
        "Feature will be removed", -- removal warnings
      }

      -- Check if message should be suppressed
      for _, pattern in ipairs(suppress_patterns) do
        if msg:lower():match(pattern:lower()) then
          -- Silently ignore
          return
        end
      end

      -- Call original notify for everything else
      return original_notify(msg, level, notify_opts)
    end

    return opts
  end,
}
