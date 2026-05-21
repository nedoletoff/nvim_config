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


**Конфиг теперь работает на любых машинах, даже если не все инструменты установлены!** (graceful degradation)
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

## Новая фича: GetIDE - умная установка инструментов

Теперь можно устанавливать все необходимые инструменты для языка одной командой!

### Использование:

```vim
" Показать доступные языки
:GetIDE list

" Установить инструменты для Go
:GetIDE install go

" Установить инструменты для Python
:GetIDE install python
```

### Поддерживаемые языки:

- **go**: gopls + goimports + gofumpt + debugging
- **python**: pyright + ruff + black + debugpy
- **rust**: rust-analyzer + rustfmt + clippy
- **lua**: lua_ls + stylua
- **typescript**: ts_ls + eslint + prettier
- **cpp**: clangd + clang-format + debugging
- **docker**: dockerls + hadolint
- **yaml**: yamlls + yamllint
- **json**: jsonls
- **html**: html + cssls + tailwindcss + prettier
- **bash**: bashls + shellcheck + shfmt

### Что GetIDE делает:

✓ Устанавливает LSP серверы
✓ Устанавливает форматтеры и линтеры
✓ Настраивает отладчики (DAP)
✓ Устанавливает Treesitter парсеры
✓ Показывает прогресс установки

### Тихий режим

Конфигурация теперь работает в тихом режиме - не показывает кучу уведомлений при запуске!
Все надоедливые сообщения Mason и lspconfig отфильтрованы автоматически.

## Дополнительные плагины

### Actually Doom (actually-doom.lua)

Запускает полноценную игру Doom прямо внутри Neovim.

```
:ActuallyDoom
```

**Требования**: Rust 1.90+

### Jinja Template Support (jinja.lua)


## 📚 Горячие клавиши и команды

### 🎯 Leader key

В этой конфигурации `<Leader>` = `Пробел` (Space)

### 🔧 Git команды (Gitsigns)

Все Git команды начинаются с `<Space>g`:

#### Навигация по изменениям:
- `]h` - следующее изменение (hunk)
- `[h` - предыдущее изменение

#### Просмотр и откат изменений:
- **`<Space>gh`** - **Preview hunk** - показать изменения в popup окне
- **`<Space>gp`** - **Preview hunk inline** - показать изменения прямо в коде  
- **`<Space>gr`** - **Reset hunk** - **ОТКАТИТЬ изменения текущего блока** ⚠️
- **`<Space>gR`** - **Reset buffer** - откатить весь файл к последнему коммиту
- `<Space>gs` - Stage hunk - добавить изменения в stage
- `<Space>gS` - Stage buffer - добавить весь файл в stage
- `<Space>gu` - Undo stage hunk - отменить stage

#### Git информация:
- `<Space>gb` - **Git blame** - показать кто и когда изменил строку
- `<Space>gB` - Toggle line blame - включить/выключить постоянный показ blame
- `<Space>gd` - Git diff - показать diff всего файла

#### Git UI:
- `<Space>gg` - Открыть LazyGit (если установлен)
- `<Space>gt` - Git status
- `<Space>gc` - Git commits (repository) 
- `<Space>gC` - Git commits (current file)

### 📝 Редактирование

#### Вход/выход из режимов:
- `jj` - выход из Insert mode в Normal mode
- `i` / `a` - войти в Insert mode
- `v` - Visual mode
- `V` - Visual Line mode

#### Копирование/вставка:
- `y` + motion - копировать (работает с y, p как обычно в Vim)
- `p` - вставить после курсора
- `P` - вставить перед курсором
- **`Ctrl+C`** (visual mode) - копировать в системный буфер (работает через SSH)
- **`Ctrl+V`** (normal/insert) - вставить из системного буфера
- **`Ctrl+X`** (visual mode) - вырезать в системный буфер

### 🔍 Поиск и навигация

- `<Space>ff` - Find files
- `<Space>fw` - Live grep (поиск в файлах)
- `<Space>fb` - Find buffers
- `<Space>fh` - Find help
- `<Space>fo` - Find old files (history)

### 💻 LSP (Language Server)

- `gd` - Go to definition
- `gr` - Go to references  
- `K` - Hover documentation
- `<Space>lr` - LSP rename
- `<Space>la` - Code actions
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

### 🛠️ GetIDE - Установка инструментов

`:GetIDE list` - показать доступные языки
`:GetIDE install <язык>` - установить инструменты для языка

Пример:
```vim
:GetIDE install go
:GetIDE install python
:GetIDE install rust
```

### 📦 Управление плагинами

- `:Lazy` - открыть Lazy UI
- `:Lazy sync` - обновить плагины
- `:Lazy clean` - удалить неиспользуемые

### 🔨 Mason

- `:Mason` - открыть Mason UI для установки LSP серверов
- `:MasonUpdate` - обновить registry

---

## 💡 Полезные советы

1. **Откат изменений Git**: Поставьте курсор на изменённую строку и нажмите `Пробел + g + r`
2. **Просмотр изменений**: `Пробел + g + h` покажет что изменилось
3. **Навигация**: Используйте `]h` и `[h` для быстрого перехода между изменениями
4. **Which-key**: Нажмите `Пробел` и подождите секунду - появится меню со всеми доступными командами
Добавляет поддержку Jinja2 темплетов (файлы `.j2` и `*.yaml.j2`) с LSP и подсветкой синтаксиса.

## Лицензия

MIT
