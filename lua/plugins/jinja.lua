-- Jinja2 template filetype.
--
-- Новый nvim-lspconfig (v3) удалил `require("lspconfig").setup()`, а lazy
-- вызывает его, если у плагина задан `opts`. Поэтому здесь НЕ описаны
-- opts/config для nvim-lspconfig — только регистрация файлтипа.
--
-- LSP (`jinja_lsp`) включается штатно: astrolsp через `vim.lsp.enable`,
-- сервер берётся из lsp/jinja_lsp.lua и ставится mason-lspconfig.

local function register_filetype()
  vim.filetype.add({
    extension = {
      j2 = "jinja",
      jinja = "jinja",
      jinja2 = "jinja",
    },
    pattern = {
      [".*%.yaml%.j2"] = "jinja",
      [".*%.yml%.j2"] = "jinja",
      [".*%.json%.j2"] = "jinja",
    },
  })
end

register_filetype()

return {}
