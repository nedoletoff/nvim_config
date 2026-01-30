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
          return " μ " .. vim.g.keys_typed
        end,
        user_host = function()
          local user = vim.loop.os_getenv("USER") or vim.loop.os_getenv("USERNAME") or "user"
          local host = vim.loop.os_gethostname() or "host"
          return user .. "@" .. host
        end,
      },
      section = {
        rz = {
          function()
            local user = vim.loop.os_getenv("USER") or vim.loop.os_getenv("USERNAME") or "user"
            local host = vim.loop.os_gethostname() or "host"
            return user .. "@" .. host
          end,
        },
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
