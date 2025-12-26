return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      enabled = true,
      format_on_save = {
        enabled = true,
        allow_filetypes = { "python", "lua", "javascript", "typescript" },
      },
    },
    servers = {
    "ruff",
      "lua_ls",
    },
skip_setup = { "ruff" },  },
}
