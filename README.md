# Neovim Config (AstroNvim)

Минималистичная и быстрая конфигурация Neovim на основе AstroNvim v5+.

## Характеристики

- **LSP**: Pyright, Ruff, Lua LS (управляются через mason)
- **Форматирование**: Автоматическое форматирование на сохранение
- **Themes**: Monokai (default) / Gruvbox / Nord / Kanagawa (optional)- **Синтаксис**: Treesitter для
- **Syntax**: Treesitter для подсветки синтаксиса
## Требования

- Neovim 0.9+
- Git
- Node.js (для некоторых LSP серверов)

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
  ├── plugins/          # Основные плагины
  │   ├── astrocore.lua # Core конфиг
  │   ├── astrolsp.lua  # LSP конфиг (pyright, ruff, lua_ls)
  │   └── theme.lua     # Тема Monokai
  ├── lazy_setup.lua    # Инициализация Lazy
  └── polish.lua        # Дополнительные настройки
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

## Лицензия

MIT
