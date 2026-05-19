# Neovim Config (AstroNvim)

Минималистичная и быстрая конфигурация Neovim на основе AstroNvim v5+.

## Характеристики

- **LSP**: Pyright, Ruff, Lua LS, gopls, jdtls, clangd, ts_ls, dockerls, yamlls, bashls (управляются через mason)
- **Форматирование**: Автоматическое форматирование на сохранение (через gopls, goimports, gofumpt, black, prettier, и т.д.)
- **Themes**: Monokai (default) / Gruvbox / Nord / Kanagawa (optional) - **Синтаксис**: Treesitter для подсветки синтаксиса
- **Go поддержка**: Полная поддержка Go через `astrocommunity.pack.go` (gopls, goimports, gofumpt, golangci-lint, delve)

## Требования

- Neovim 0.10+
- Git
- Node.js (для некоторых LSP серверов)
- Go 1.21+ (для Go разработки)
- Rust 1.90+ (для actually-doom плагина)

## Быстрая установка

### 1. Сделать бэкап текущей конфигурации

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### 2. Клонировать репозиторий

```bash
git clone https://github.com/nedoletoff/nvim_config ~/.config/nvim
```

### 3. Запустить Neovim

```bash
nvim
```

Первый запуск загрузит все плагины и настроит LSP. Это может занять время.

## Структура конфига

```
lua/
├── plugins/            # Основные плагины
│   ├── astrocore.lua     # Core конфиг
│   ├── astrolsp.lua      # LSP конфиг (включая gopls с inlay hints)
│   ├── mason.lua         # Mason tool installer (форматтеры/линтеры/DAP)
│   ├── astrocommunity.lua # Community packs (Go, Python, Java, C++, JS/TS)
│   └── theme.lua         # Тема Monokai
├── lazy_setup.lua        # Инициализация Lazy
└── polish.lua            # Дополнительные настройки
```

## Горячие клавиши

- `Space` + `f` + `f` - поиск файлов (Telescope)
- `Space` + `f` + `w` - поиск текста (Telescope)
- `Ctrl` + `n` - Toggle file browser
- `Space` + `l` + `f` - Format code

## Настройка

Добавляйте новые плагины в папку `lua/plugins/`:

```lua
return {
  "author/plugin-name",
  config = function()
    -- ваша конфигурация
  end,
}
```

## Важные изменения

### Убраны устаревшие компоненты

- **none-ls.lua / null-ls** - удалён, так как deprecated. Форматирование теперь через LSP (gopls, pyright) и `mason-tool-installer`
- **mason-null-ls.nvim** - заменён на `WhoIsSethDaniel/mason-tool-installer.nvim`

### Go окружение

Теперь Go-разработка полностью настроена:
- **gopls** с inlay hints, staticcheck, gofumpt
- **goimports** автоматически устанавливается через `mason-tool-installer`
- **golangci-lint** для линтинга
- **delve** для отладки

Никаких конфликтов null-ls больше нет!

## Дополнительные плагины

### Actually Doom (actually-doom.lua)

Запускает полноценную игру Doom прямо внутри Neovim.

```
:ActuallyDoom
```

**Требования**: Rust 1.90+

### Jinja Template Support (jinja.lua)

Добавляет поддержку Jinja2 темплетов (файлы `.j2` и `*.yaml.j2`) с LSP и подсветкой синтаксиса.

## Лицензия

MIT
