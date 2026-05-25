-- Clipboard provider for SSH/Server environments
-- Uses OSC 52 escape sequences - works in tmux, SSH, and headless servers
-- Does NOT require X11, Wayland, or any graphical environment
return {
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup({
        max_length = 0,  -- Maximum length of selection (0 for no limit)
        silent = true,   -- Disable message on successful copy
        trim = false,    -- Trim text before copy
      })

      -- Auto-copy to OSC52 on every yank (works over SSH, in tmux, etc.)
      -- OSC52 sends clipboard data via terminal escape sequences,
      -- so it works without X11 or any graphical clipboard tool.
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          if vim.v.event.operator == "y" and vim.v.event.regname == "" then
            require("osc52").copy_register("")
          end
        end,
      })

      -- Keymaps for clipboard operations
      -- <Leader>y in normal mode - copy current line via OSC52
      vim.keymap.set("n", "<Leader>y", function() require("osc52").copy_operator() end,
        { expr = true, desc = "Copy to clipboard (OSC52)" })

      -- <Leader>y in visual mode - copy selection via OSC52
      vim.keymap.set("v", "<Leader>y", function() require("osc52").copy_visual() end,
        { desc = "Copy selection to clipboard (OSC52)" })

      -- NOTE: Paste from clipboard is not supported over pure SSH/OSC52.
      -- Use the terminal's paste (Shift+Insert or right-click) or
      -- the unnamed register p/P after yanking within the same session.
    end,
  },
}
