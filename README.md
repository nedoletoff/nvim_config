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
init.lua                 # Bootstrap lazy.nvim, rocks отключён
lua/
├── community.lua       # AstroCommunity (отключён, см. первую строку)
├── ai/                 # Провайдеры DeepSeek / OpenCode Zen + health
├── python3/health.lua  # :checkhealth python3 (конвенция lua/<name>/health.lua)
├── hashfile.lua        # Модуль подсчёта хешей
├── user/dance_time.lua # Анимация Dance Time (<Leader>DT)
└── plugins/            # Спеки плагинов
    ├── astrocore.lua     # Core конфиг и which-key группы
    ├── astrolsp.lua      # LSP: gopls, format_on_save
    ├── mason.lua         # Mason: форматтеры, линтеры, DAP-адаптеры
    ├── codecompanion.lua # DeepSeek / Zen адаптеры
    ├── none-ls.lua       # none-ls выключен намеренно
    └── theme.lua         # Тема
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

- **none-ls.lua / null-ls** - отключены: несовместимы с Neovim 0.12. Форматирование на `:w` делает `astrolsp` через `vim.lsp.buf.format()` (см. `plugins/astrolsp.lua`), линтеры ставит `mason-tool-installer` (см. `plugins/mason.lua`). `conform.nvim` в конфиге нет.
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

## 🤖 CodeCompanion.nvim — AI-ассистент

Два провайдера на выбор: **DeepSeek** (платный) и **OpenCode Zen**
(бесплатные модели, включая `big-pickle`). Активная модель всегда видна
в statusline слева.

| Файл | Что делает |
|---|---|
| `lua/ai/init.lua` | реестр провайдеров/моделей, чтение ключей, переключение |
| `lua/ai/health.lua` | `:checkhealth ai` |
| `lua/plugins/codecompanion.lua` | сборка конфига плагина из реестра, кеймапы |
| `lua/plugins/statusline-ai-model.lua` | индикатор модели в statusline |

### Ключи API

Ключ **не хардкодится** в конфиге и лежит вне репозитория. Для каждого
провайдера свой поиск: сначала переменная окружения, потом файл.

| Провайдер | Переменная | Файл | Где взять ключ |
|---|---|---|---|
| DeepSeek | `$DEEPSEEK_API_KEY` | `~/.config/deepseek/api_key` | <https://platform.deepseek.com/api_keys> |
| OpenCode Zen | `$OPENCODE_API_KEY` | `~/.config/opencode/zen_key` | <https://opencode.ai/auth> → `/connect` → OpenCode Zen |

```bash
mkdir -p ~/.config/deepseek ~/.config/opencode
chmod 700 ~/.config/deepseek ~/.config/opencode
printf '%s' 'sk-ТВОЙ_КЛЮЧ'  > ~/.config/deepseek/api_key
printf '%s' 'zen_ТВОЙ_КЛЮЧ' > ~/.config/opencode/zen_key
chmod 600 ~/.config/deepseek/api_key ~/.config/opencode/zen_key
```

Альтернатива — переменные окружения в `~/.zshrc`:

```bash
export DEEPSEEK_API_KEY='sk-ТВОЙ_КЛЮЧ'
export OPENCODE_API_KEY='zen_ТВОЙ_КЛЮЧ'
```

В `.gitignore` в корне уже есть `api_key`, `deepseek_key`, `zen_key`,
`*.env`, `.env`, `secrets.lua` — на случай если ключ окажется в репозитории.
Проверить, что всё в порядке:

```bash
:checkhealth ai
```

Проверка показывает **источник** и длину ключа, но никогда само значение.

### Модели

Список моделей лежит в `lua/ai/init.lua` (`M.PROVIDERS`). Текущий выбор
хранится в `vim.g.ai_provider` / `vim.g.ai_model`, поэтому statusline и чат
всегда показывают реально активную модель. Переменные `vim.g` живут только
в рамках сессии: после перезапуска Neovim выбор возвращается к провайдеру
по умолчанию.

**DeepSeek** (платно, свой API):

- `deepseek-chat` — быстрая, дешёвая, по умолчанию
- `deepseek-reasoner` — с размышлением

В CodeCompanion v19.26 `deepseek-chat` помечена как *Deprecated*; актуальные
модели провайдера — `deepseek-v4-flash` и `deepseek-v4-pro`. Работают и те,
и другие, поэтому оставлена `deepseek-chat`.

**OpenCode Zen** (бесплатно, OpenAI-совместимый шлюз
`https://opencode.ai/zen/v1/chat/completions`):

- `big-pickle`
- `space-bunny-free`, `longcat-2.5-preview-free`
- `mimo-v2.6-flash-free`, `mimo-v2.5-free`
- `ling-3.0-flash-fin-free`
- `nemotron-3-ultra-free`, `nemotron-3.5-lightning-free`

Актуальный список — <https://opencode.ai/zen/v1/models>. Free-модели
помечаются в statusline зелёным и словом `free`. Учти: часть из них
(включая `big-pickle`) во время бесплатного периода может использовать
данные для улучшения модели; у `space-bunny-free` и `longcat` политика
zero-retention.

Параметры `thinking.type` / `reasoning_effort` отправляются в API только для
моделей, помеченных `can_reason`. Для `deepseek-chat` и всех free-моделей
они исключены, иначе API отвечает 400 на неизвестные поля.

### Клавиши

| Клавиша | Режим | Действие |
|---|---|---|
| `<Space>ca` | normal | Меню действий (`CodeCompanionActions`) |
| `<Space>cc` | normal, terminal | Открыть / скрыть окно чата |
| `<Space>ci` | normal, visual | Инлайн-правка: выделение или текущая строка |
| `<Space>cm` | normal | Выбрать провайдера и модель (список) |
| `<Space>cM` | normal | Следующая модель текущего провайдера |
| `ga` | visual | Добавить выделенный фрагмент в чат |

Внутри буфера чата: `/` — команды, `#` — контекст редактора, `@` — инструменты.

Ответы LLM идут на русском языке (`opts.opts.language = "Russian"`).
Смена модели применяется сразу: обновляется и конфиг плагина, и уже
открытый чат.


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

### 📚 Буферы

Семейство маппингов начинается с `b` (без `<Leader>`):

- `bn` - следующий буфер (можно `3bn`)
- `bp` - предыдущий буфер (можно `3bp`)
- `bd` - закрыть текущий буфер
- `bb` - picker буферов (в нём `d` закрывает выбранный буфер)

Групповые операции остались на `<Leader>b*` (AstroNvim):
`<Space>bl` / `<Space>br` / `<Space>bc` / `<Space>bC` — закрыть слева / справа /
все кроме текущего / все, а `<Space>bs{ext,rel,path,num,mod}` — сортировка.

### 💃 Dance Time

- `<Space>DT` - открыть анимированную Miku во флоте, `q` или `<Esc>` - закрыть

Рисунок держится на общем холсте фиксированного размера, поэтому не «прыгает»
при смене кадра и остаётся по центру при ресайзе терминала.

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
