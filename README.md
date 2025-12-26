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
- - Rust 1.90+ (для actually-doom плагина)

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

## Дополнительные плагины

### 1. Bad Apple (bad-apple.lua)
**Описание:** Проигрывает Bad Apple анимацию в Neovim.

**Использование:**
```
:BadApple
```

**Быстрая клавиша:** `<leader>ba`

**Требования:** libcanberra (опционально для звука)

### 2. Счётчик введённых символов (statusline-custom.lua)
**Описание:** Показывает количество введённых символов за сессию на нижней панели.

**Особенности:**
- Автоматически инициализируется при запуске
- Считает символы в режиме Insert (InsertCharPre)
- Отображается в statusline с иконкой

**Пример:** ` Keys: 2345`

### 3. Doom-like UI (doom-ui.lua)
Два плагина для красивого UI подобно Doom Emacs:

**which-key.nvim** - показывает доступные команды при нажатии `<leader>`
- Preset: "modern"- Timeout: 300ms
- Красивое меню со всеми доступными командами

### 4. Actually Doom (actually-doom.lua)

**Описание:** Запускает полноценную игру Doom прямо внутри Neovim.

**Использование:**

```
:ActuallyDoom
```

**Требования:** Rust 1.90+ (для сборки и установки плагина через cargo)

**Примечание:** При первом запуске плагин скомпилирует игру, что может занять время.

### 5. Jinja Template Support (jinja.lua)

**Описание:** Добавляет поддержку Jinja2 темплетов (файлы `.j2` и `*.yaml.j2`) с LSP и подсветкой синтаксиса.

**Особенности:**

- Автоматически определяет тип файла Jinja
- Поддержка jinja-lsp для интеллектуальных подсказок

**Требования:** Работает на AstroNvim v5 без дополнительных внешних зависимостей

## Лицензия

MIT
