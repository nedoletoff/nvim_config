---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "astrodark",

    -- configure AstroNvim status line with user@host
    status = {
      attributes = {
        statusline = {}, -- statusline default attributes
      },
      component = {
        -- add user@host component
        user_host = function()
          local user = vim.loop.os_getenv("USER") or vim.loop.os_getenv("USERNAME") or "user"
          local host = vim.loop.os_gethostname() or "host"
          return user .. "@" .. host
        end,
      },
      section = {
        rz = { " ", "user_host" }, -- add user_host to right section
      },
    },

    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = {
        -- this table overrides highlights in all themes
        -- Normal = { bg = "#000000" },
      },
      astrodark = {
        -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },

    -- Icons can be configured throughout the interface
    icons = {
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
  },
}
