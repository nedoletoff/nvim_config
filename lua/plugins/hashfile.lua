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
          ["<Leader>hb"] = {
            function()
              local hashfile = require("hashfile")
              hashfile.pick_base64()
            end,
            desc = "Hash current file (Base64)",
          },
        },
      },
    },
  },
}
