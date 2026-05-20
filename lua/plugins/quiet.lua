-- Smart logging: suppress spam but keep important messages
-- Adds :ViewLogs command to see suppressed messages

return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    -- Log storage for suppressed messages
    local suppressed_logs = {}
    local max_logs = 100

    -- Save original notify
    local original_notify = vim.notify

    -- Patterns to suppress (only boring spam)
    local suppress_patterns = {
      -- Only deprecation warnings that repeat on every startup
      "lspconfig.*deprecated",
      "Feature will be removed in nvim%-lspconfig",
    }

    -- Override vim.notify with smart filtering
    vim.notify = function(msg, level, notify_opts)
      -- Check if we should suppress
      local should_suppress = false
      for _, pattern in ipairs(suppress_patterns) do
        if msg:match(pattern) then
          should_suppress = true
          break
        end
      end

      if should_suppress then
        -- Save to log but don't show
        table.insert(suppressed_logs, {
          msg = msg,
          level = level or vim.log.levels.INFO,
          time = os.date("%H:%M:%S"),
        })
        -- Keep only last max_logs entries
        if #suppressed_logs > max_logs then
          table.remove(suppressed_logs, 1)
        end
        return
      end

      -- Show everything else normally (GetIDE, Mason, errors, etc)
      return original_notify(msg, level, notify_opts)
    end

    -- Command to view suppressed logs
    vim.api.nvim_create_user_command("ViewLogs", function()
      if #suppressed_logs == 0 then
        vim.notify("No suppressed messages", vim.log.levels.INFO)
        return
      end

      -- Create a scratch buffer
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
      vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

      -- Format logs
      local lines = { "=== Suppressed Messages ===", "" }
      for _, log in ipairs(suppressed_logs) do
        local level_str = ({
          [vim.log.levels.ERROR] = "[ERROR]",
          [vim.log.levels.WARN] = "[WARN]",
          [vim.log.levels.INFO] = "[INFO]",
        })[log.level] or "[LOG]"
        table.insert(lines, string.format("%s %s %s", log.time, level_str, log.msg))
      end
      table.insert(lines, "")
      table.insert(lines, "Press 'q' to close")

      -- Set content
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.api.nvim_buf_set_option(buf, "modifiable", false)

      -- Open in split
      vim.cmd("split")
      vim.api.nvim_win_set_buf(0, buf)

      -- Map 'q' to close
      vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
    end, { desc = "View suppressed log messages" })

    -- Command to view Lazy log (for plugin issues)
    vim.api.nvim_create_user_command("LazyLog", function()
      vim.cmd("messages")
    end, { desc = "Show vim messages log" })

    return opts
  end,
}
