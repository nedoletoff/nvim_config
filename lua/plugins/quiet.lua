-- Smart logging: suppress spam but keep important messages
-- Adds :ViewLogs command to see suppressed messages
--
-- Фильтр lspconfig-депрекейшенов ставится дважды намеренно:
-- в init.lua — до lazy, чтобы поймать сообщения на старте, и здесь —
-- чтобы складывать их в журнал для :ViewLogs. Паттерны берём из
-- _G.__nvim_suppress_patterns, чтобы списки не расходились.

local suppress_patterns = _G.__nvim_suppress_patterns or {}

return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    local suppressed_logs = {}
    local max_logs = 100
    local original_notify = vim.notify

    vim.notify = function(msg, level, notify_opts)
      -- msg не обязан быть строкой: Snacks и часть плагинов шлют
      -- таблицы. Без проверки типа match() падал на vim.notify({...}).
      if type(msg) == "string" then
        for _, pattern in ipairs(suppress_patterns) do
          if msg:match(pattern) then
            table.insert(suppressed_logs, {
              msg = msg,
              level = level or vim.log.levels.INFO,
              time = os.date("%H:%M:%S"),
            })
            if #suppressed_logs > max_logs then
              table.remove(suppressed_logs, 1)
            end
            return
          end
        end
      end

      return original_notify(msg, level, notify_opts)
    end

    vim.api.nvim_create_user_command("ViewLogs", function()
      if #suppressed_logs == 0 then
        vim.notify("No suppressed messages", vim.log.levels.INFO)
        return
      end

      local buf = vim.api.nvim_create_buf(false, true)
      -- nvim 0.10+: используем vim.bo вместо устаревшего nvim_buf_set_option
      vim.bo[buf].buftype = "nofile"
      vim.bo[buf].bufhidden = "wipe"

      local lines = { "=== Suppressed Messages ===", "" }
      for _, log in ipairs(suppressed_logs) do
        local level_str = ({
          [vim.log.levels.ERROR] = "[ERROR]",
          [vim.log.levels.WARN]  = "[WARN]",
          [vim.log.levels.INFO]  = "[INFO]",
        })[log.level] or "[LOG]"
        table.insert(lines, string.format("%s %s %s", log.time, level_str, log.msg))
      end
      table.insert(lines, "")
      table.insert(lines, "Press 'q' to close")

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].modifiable = false

      vim.cmd("split")
      vim.api.nvim_win_set_buf(0, buf)
      vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf, noremap = true, silent = true })
    end, { desc = "View suppressed log messages" })

    vim.api.nvim_create_user_command("LazyLog", function()
      vim.cmd("messages")
    end, { desc = "Show vim messages log" })

    return opts
  end,
}
