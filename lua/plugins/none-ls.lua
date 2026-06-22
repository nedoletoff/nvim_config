-- lua/plugins/none-ls.lua
-- none-ls отключён: его API несовместимо с AstroNvim v5 + Neovim 0.12.
-- Форматтеры/линтеры работают через conform.nvim + mason-tool-installer.

---@type LazySpec
return {
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    enabled = false,
  },
}
