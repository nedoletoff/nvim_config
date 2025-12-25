# 🎯 Neovim Python IDE - Полная установка и настройка

## ⚠️ ИСПРАВЛЕНИЕ ОШИБКИ с pyright

Если ты видишь ошибку:
```
Spawning language server with cmd: "pyright-langserver", "--stdio" failed
```

**Решение:**

### Шаг 1: Установи Python LSP
```bash
# Глобально
pip install pyright

# ИЛИ дай Mason установить автоматически
nvim
:Mason  # откроется менеджер Mason
# Затем найди pyright в списке и установи (нажми 'i')
```

### Шаг 2: Проверь что pyright в PATH
```bash
pyright --version  # должно вывести версию
which pyright
```

### Шаг 3: Проверь в Neovim
```vim
:LspInfo  # должно показать pyright attached
```

---

## 📥 ПОЛНАЯ УСТАНОВКА (ВСЕ ЧТО НУЖНО)

### 1️⃣ Python и Neovim (ОБЯЗАТЕЛЬНО)

```bash
# Проверь Python
python3 --version  # Должна быть 3.8+

# Установи pynvim (КРИТИЧНО!)
pip install --user pynvim

# Проверь
nvim -c ":checkhealth python3" -c ":q"
```

### 2️⃣ Mason - установит всё сам

Линивые загрузки (`lazy = true`) - установится при первом использовании:

```bash
nvim  # просто открой Neovim

# Mason установит:
# - pyright (LSP) ✓
# - black (форматер) ✓
# - ruff (линтер) ✓
# - debugpy (отладчик) ✓
```

Или вручную:
```vim
:MasonInstall pyright black ruff debugpy
```

### 3️⃣ Для отладки (DAP)

```bash
# Глобально (рекомендуется)
pip install --user debugpy

# ИЛИ в проекте
cd /path/to/project
python -m venv .venv
source .venv/bin/activate  # Unix/macOS
# или
.venv\\Scripts\\activate  # Windows

pip install debugpy
```

### 4️⃣ Для SSH/серверов (clipboard OSC 52)

```bash
# Включи поддержку в SSH:
ssh -o SetEnv=TERM_PROGRAM=tmux user@host

# ИЛИ включи в ~/.ssh/config:
# Host example.com
#   SetEnv TERM_PROGRAM=tmux
```

Теперь `<Space>c` скопирует в буфер обмена даже через SSH!

---

## 🚀 БЫСТРЫЙ СТАРТ

```bash
# 1. Установи основное
pip install --user pynvim debugpy

# 2. Запусти Neovim
nvim

# 3. Проверь всё OK
:checkhealth python3
:LspInfo  # должен быть pyright

# 4. Создай Python файл
# test.py
echo 'def hello(name: str) -> str:
    """Greet someone."""
    return f"Hello, {name}!"' > test.py

# 5. Откой в Neovim
nvim test.py

# 6. Протестируй:
# - Нажми K на hello -> должно быть docstring
# - Нажми gd -> goto definition
# - Нажми Space+b -> set breakpoint
# - Нажми F5 -> start debugging
```

---

## ⌨️ ГОРЯЧИЕ КЛАВИШИ

### LSP (Language Server)
| Клавиша | Действие |
|---------|----------|
| `K` | Документация/hover |
| `gd` | Перейти к определению |
| `gr` | Найти ссылки |
| `gI` | Перейти к реализации |
| `<Space>rn` | Переименовать |
| `<Space>ca` | Code actions (быстрые исправления) |
| `<Space>lf` | Отформатировать |

### Отладка (DAP)
| Клавиша | Действие |
|---------|----------|
| `<F5>` | Запустить/продолжить отладку |
| `<F10>` | Шаг над (step over) |
| `<F11>` | Шаг внутрь (step into) |
| `<F12>` | Шаг из (step out) |
| `<Space>b` | Toggle breakpoint |
| `<Space>B` | Условный breakpoint |

### IDE функции
| Команда | Действие |
|---------|----------|
| `:Trouble` | Открыть диагностику |
| `:SymbolsOutline` | Структура файла |
| `:TodoTelescope` | Найти TODO/FIXME |

### Clipboard (SSH)
| Клавиша | Действие |
|---------|----------|
| `<Space>c` | Копировать (визуальный режим) |
| `<Space>cc` | Копировать строку |

---

## 🔧 ФАЙЛЫ КОНФИГУРАЦИИ

### lua/plugins/
- **python.lua** - DAP конфигурация (отладка)
- **ide.lua** - IDE функции (trouble, symbols, todos, gitsigns)
- **clipboard.lua** - OSC 52 для SSH (буфер обмена)
- **mason.lua** - Инструменты (pyright, black, ruff, debugpy)
- **astrolsp.lua** - Pyright включен
- **none-ls.lua** - Форматирование и линтинг

---

## 🐛 РЕШЕНИЕ ПРОБЛЕМ

### Pyright not installed
```vim
:Mason
# найди pyright -> i (install)
```

### LSP не подключается
```vim
:LspInfo
:checkhealth lsp
```

### Отладка не работает
1. Убедись что debugpy установлен: `pip install debugpy`
2. Установи breakpoint: `<Space>b`
3. Нажми `<F5>`
4. Должен открыться DAP UI

### Clipboard не работает на SSH
1. Включи OSC 52 поддержку в терминале
2. Используй: `ssh -o SetEnv=TERM_PROGRAM=tmux user@host`
3. Копируй с `<Space>c`

### Форматирование не работает
```vim
:Mason  # установи black и ruff
:Format  # проверь
```

---

## 📊 ВСЕ УСТАНОВЛЕННЫЕ ПЛАГИНЫ

✅ **LSP & Intellisense**
- nvim-lspconfig
- pyright (Mason)

✅ **Форматирование & Линтинг**
- none-ls.nvim
- black (Mason)
- ruff (Mason)

✅ **Отладка**
- nvim-dap
- nvim-dap-python
- nvim-dap-ui
- debugpy (Mason)

✅ **IDE Features**
- trouble.nvim (диагностика)
- symbols-outline.nvim (структура)
- nvim-navic (навигация)
- todo-comments.nvim (TODO/FIXME)
- gitsigns.nvim (git blame)

✅ **Clipboard**
- nvim-osc52 (SSH буфер обмена)

---

## 💡 СОВЕТЫ

1. **Для проектов** - создай `.venv` и активируй его
2. **LSP автоматически** подхватит venv
3. **DAP UI** откроется автоматически на F5
4. **Горячие клавиши** можно менять в astrocore.lua
5. **SSH** - используй OSC 52 для копирования

---

## 🎓 EXAMPLE WORKFLOW

```bash
# Создай проект
mkdir my_project && cd my_project

# Создай venv
python -m venv .venv
source .venv/bin/activate

# Установи в проект
pip install debugpy

# Создай файл
cat > main.py << 'EOF'
def fibonacci(n):
    """Calculate Fibonacci number."""
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

if __name__ == "__main__":
    result = fibonacci(5)
    print(result)
EOF

# Открой в Neovim
nvim main.py

# В Neovim:
# 1. Нажми K на fibonacci -> увидишь docstring
# 2. Нажми <Space>b на строке 6 -> breakpoint
# 3. Нажми F5 -> начнется отладка
# 4. Нажми F10/F11 -> шагаешь
# 5. Нажми Space+lf -> форматирует код
```

---

✨ **Готово!** Теперь у тебя полноценная Python IDE в Neovim!
