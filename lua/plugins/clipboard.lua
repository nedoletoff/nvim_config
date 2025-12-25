-- Clipboard provider for SSH/Server environments
-- Supports: OSC 52 (tmux, SSH), xsel, xclip, pbcopy

return {
  {
    "ojroques/nvim-osc52",
    config = function()
      local function copy(lines, _)
        require("osc52").copy(table.concat(lines, "\n"))
      end

      local function paste()
        return { vim.fn.getreg("\"") }
      end

      vim.g.clipboard = {
        name = "osc52",
        copy = { ["+"] = copy, ["*"] = copy },
        paste = { ["+"] = paste, ["*"] = paste },
      }

      vim.keymap.set("n", "<Leader>c", require("osc52").copy_operator, { expr = true })
      vim.keymap.set("n", "<Leader>cc", "<Leader>c_", { remap = true })
      vim.keymap.set("v", "<Leader>c", require("osc52").copy_visual)
    end,
  },
}
