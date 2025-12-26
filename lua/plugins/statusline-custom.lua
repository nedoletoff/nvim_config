return {
  "AstroNvim/astroui",
  opts = {
    status = {
      attributes = {
        statusline = {},
      },
      component = {
        keys_typed = function()
          if not vim.g.keys_typed then vim.g.keys_typed = 0 end
          return " 󰌌 " .. vim.g.keys_typed
        end,
      },
    },
  },
  config = function(_, opts)
    require("astroui").setup(opts)
    
    -- Initialize keys counter
    vim.g.keys_typed = 0
    
    -- Count typed keys in insert mode
    vim.api.nvim_create_autocmd("InsertCharPre", {
      callback = function()
        vim.g.keys_typed = (vim.g.keys_typed or 0) + 1
      end,
    })
  end,
}
