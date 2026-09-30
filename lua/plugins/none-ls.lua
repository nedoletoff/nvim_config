-- lua/plugins/none-ls.lua
-- none-ls выключен намеренно: AstroNvim v5 тянет его как отдельный
-- core-спек, а Neovim 0.12 + текущая версия none-ls несовместимы.
--
-- Форматирование на :w делает astrolsp через vim.lsp.buf.format()
-- (см. astrolsp.lua), линтеры — mason-tool-installer (см. mason.lua).
-- conform.nvim в конфиге нет.

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
  -- Переопределяем astrolsp пустым списком none-ls sources, иначе ядро
  -- AstroNvim попытается вызвать setup() на неинициализированном плагине.
  {
    "AstroNvim/astrolsp",
    opts = {
      -- Пустой список переопределяет внутренний none_ls.sources
      -- и предотвращает вызов setup() на неинициализированном плагине
      none_ls = { sources = {} },
    },
  },
}
