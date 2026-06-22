-- lua/plugins/none-ls.lua
-- none-ls полностью выключён: несовместимость API с AstroNvim v5 + Neovim 0.12.
-- Форматтеры/линтеры работают через conform.nvim + mason-tool-installer.
-- Отключаем через astrolsp, чтобы перекрыть внутренний конфиг ядра AstroNvim.

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
  -- Переопределяем astrolsp с пустым списком none-ls sources,
  -- чтобы AstroNvim не пытался загрузить none-ls.lua:29
  {
    "AstroNvim/astrolsp",
    opts = {
      -- Пустой список переопределяет внутренний none_ls.sources
      -- и предотвращает вызов setup() на неинициализированном плагине
      none_ls = { sources = {} },
    },
  },
}
