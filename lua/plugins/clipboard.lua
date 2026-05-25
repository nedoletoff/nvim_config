-- Clipboard provider for SSH/Server environments
-- Supports: OSC 52 (tmux, SSH), xsel, xclip, pbcopy

return {
  {
    "ojroques/nvim-osc52",
    config = function()
      require("osc52").setup({
        max_length = 0, -- Maximum length of selection (0 for no limit)
        silent = true, -- Disable message on successful copy
        trim = false, -- Trim text before copy
      })

      -- Auto-copy to clipboard with OSC52 when using y/Y in visual mode
      -- This works alongside normal Vim yank behavior
      vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
          if vim.v.event.operator == "y" and vim.v.event.regname == "" then
            -- Only copy to OSC52 if yanking to default register
            require("osc52").copy_register("")
          end
        end,
      })

      -- Keymaps for explicit clipboard operations
      -- Ctrl+C in visual mode - copy to system clipboard via OSC52
            vim.keymap.set("v", "<C-c>", function() require("osc52").copy_visual() end, { desc = "Copy to clipboard (OSC52)" })
      
      -- Ctrl+X in visual mode - cut to system clipboard
      vim.keymap.set("v", "<C-x>", '"+x', { desc = "Cut to clipboard" })
      
      -- Ctrl+V in normal/insert mode - paste from system clipboard
      vim.keymap.set("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
      vim.keymap.set("i", "<C-v>", '<C-r>+', { desc = "Paste from clipboard" })
        end,
  },
}
