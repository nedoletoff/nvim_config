-- Jinja2 template filetype and LSP configuration
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Define jinja filetype for .j2 files
      vim.filetype.add({
        extension = {
          j2 = "jinja",
          jinja = "jinja",
          jinja2 = "jinja",
        },
        filename = {
          ["*.yaml.j2"] = "jinja",
          ["*.yml.j2"] = "jinja",
          ["*.json.j2"] = "jinja",
        },
      })
      return opts
    end,
  },
}
