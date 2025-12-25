# 🐍 BasedPyright Migration Guide

## Проблема ❌

При попытке использовать `pyright` через Mason на Debian/Ubuntu системах без npm:

```
Error: Spawning language server with cmd: `{ "pyright-langserver", "--stdio" }` failed.
The language server is either not installed, missing from PATH, or not executable.
```

Причина: `pyright` в Mason требует **npm** (Node.js) для установки, а на серверных системах npm часто не установлен.

## Решение ✅

Используем **BasedPyright** - форк pyright, который устанавливается через **pip** вместо npm.

### Что такое BasedPyright?

- ✨ Форк официального Pyright
- 📦 Устанавливается через PyPI (pip)
- 🚀 Поддерживается в Mason registry
- 🎯 100% совместим с LSP конфигурацией Pyright
- 📈 Имеет дополнительные фичи из Pylance

## Установка

### Шаг 1: Обновить конфиги

**lua/plugins/mason.lua:**
```lua
ensure_installed = {
  "lua-language-server",
  "stylua",
  -- Python tools
  "basedpyright",  -- ← Changed from "pyright"
  "black",
  "ruff",
  "debugpy",
  "tree-sitter-cli",
}
```

**lua/plugins/astrolsp.lua:**
```lua
servers = {
  "basedpyright",  -- ← Changed from "pyright"
}
```

### Шаг 2: Установить инструменты

```bash
# Вариант 1: Через Mason (рекомендуется)
cd ~/.config/nvim
git pull origin main
nvim
:Mason
# Найти basedpyright и нажать 'i' для установки

# Вариант 2: Вручную через pip
pip install basedpyright black ruff debugpy
```

### Шаг 3: Проверить установку

```bash
# Проверить что всё установлено
nvim
:checkhealth python3
:LspInfo  # Должен показать basedpyright-langserver
:Mason    # Проверить status инструментов
```

## Тестирование

```bash
# Создать тестовый файл
cat > test.py << 'EOF'
import os
import sys

def hello(name: str) -> str:
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(hello("World"))
EOF

# Открыть в Neovim
nvim test.py
```

**Проверить функциональность:**
- `K` - hover на функции (должна показать docstring)
- `gd` - go to definition
- `:checkhealth lsp` - проверить LSP status
- `Space+b` - set breakpoint (если DAP настроен)

## Почему BasedPyright лучше?

| Аспект | Pyright | BasedPyright |
|--------|---------|---------------|
| Установка | npm (требует Node.js) | pip ✅ |
| Размер | ~500MB | ~50MB ✅ |
| Pylance features | Нет | Да ✅ |
| Скорость | Нормальная | Такая же |
| Поддержка Mason | Да | Да ✅ |

## Ошибки и их решение

### "basedpyright-langserver not found"

```bash
# Убедитесь что Mason установил basedpyright
:Mason

# Или установите вручную
pip install --user basedpyright
```

### "LSP не подключается"

```bash
# Перезагрузить Neovim
:quit
nvim

# Или вручную перезагрузить LSP
:LspRestart
```

### "Still getting pyright errors"

```bash
# Убедитесь что вы обновили обе конфигурации:
# 1. lua/plugins/mason.lua - ensure_installed
# 2. lua/plugins/astrolsp.lua - servers

# Проверить кэш Mason
rm -rf ~/.local/share/nvim/mason
nvim
:Mason
```

## SSH/Remote

Безопасно работает по SSH благодаря OSC52 поддержке в clipboard.lua.

Для mejor производительности на медленных соединениях:
```bash
# Подключиться с TERM_PROGRAM
ssh -o SetEnv=TERM_PROGRAM=tmux user@host
```

## Ссылки

- 📖 [BasedPyright Docs](https://detachhead.github.io/basedpyright/)
- 🔧 [Mason Registry](https://mason-registry.dev/registry/list)
- 🏗️ [AstroNvim Docs](https://docs.astronvim.com/)

## Резюме

Всё что нужно было сделать:
1. Заменить `"pyright"` на `"basedpyright"` в mason.lua
2. Заменить `"pyright"` на `"basedpyright"` в astrolsp.lua
3. Установить через `:Mason` или `pip install basedpyright`
4. Готово! 🎉

---

**Версия:** 2025-12-25  
**Совместимость:** AstroNvim v5+, Neovim 0.7+
