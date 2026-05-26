-- @type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<Leader>h"] = { desc = "+hash" },
          ["<Leader>ha"] = {
            function()
              local hashfile = require("hashfile")
              hashfile.pick()
            end,
            desc = "Hash current file",
          },
        },
      },
    },
  },
}
