# Пошаговая установка Neovim конфигурации

## ВАЖНО! Полная чистая установка

### Шаг 1: Удалите ВСЁ старое

```bash
# Удалить конфигурацию
rm -rf ~/.config/nvim

# Удалить данные, кэш, состояние
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim  
rm -rf ~/.cache/nvim

# Для root (если нужно)
sudo rm -rf /root/.config/nvim
sudo rm -rf /root/.local/share/nvim
sudo rm -rf /root/.local/state/nvim
sudo rm -rf /root/.cache/nvim
```

### Шаг 2: Установите Neovim 0.10+

```bash
# Проверьте версию
nvim --version

# Если версия < 0.10, установите через AppImage:
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# Проверьте снова
nvim --version  # Должно быть NVIM v0.10.0+
```

### Шаг 3: Установите зависимости

```bash
sudo apt update
sudo apt install -y \
  git \
  curl \
  ripgrep \
  fd-find \
  python3-pip \
  python3-venv \
  nodejs \
  npm \
  build-essential \
  gcc \
  g++
```

### Шаг 4: Клонируйте конфигурацию

```bash
git clone https://github.com/nedoletoff/nvim_config.git ~/.config/nvim
```

### Шаг 5: ПЕРВЫЙ запуск - дождитесь установки

```bash
# Запустите Neovim
nvim

# Lazy.nvim автоматически:
# 1. Скачает все плагины (2-3 минуты)
# 2. Установит treesitter парсеры
# 3. Скомпилирует всё необходимое

# ВАЖНО: Дождитесь сообщения "All plugins installed!"
# Или нажмите 'q' когда увидите "✓ 40/40 plugins"

# После этого закройте Neovim
:q
```

### Шаг 6: Проверьте что всё работает

```bash
# Перезапустите Neovim
nvim

# Проверьте здоровье
:checkhealth

# Проверьте Lazy (должны быть все плагины)
:Lazy

# Проверьте Mason
:Mason

# Если всё ОК - закройте
:q
```

### Шаг 7: Установите инструменты для языка

```bash
nvim

# Посмотрите доступные языки
:GetIDE list

# Установите нужный
:GetIDE install go
:GetIDE install python
:GetIDE install rust

# Подождите установки (1-2 минуты)
```

## Диагностика проблем

### Если видите ошибки при первом запуске:

```bash
# Откройте Neovim с verbose логами
nvim --headless "+Lazy! sync" +qa

# Или запустите и посмотрите ошибки
nvim
:messages
```

### Если treesitter ошибки:

```bash
nvim

# Переустановите treesitter парсеры
:TSInstall! lua vim bash markdown

# Или удалите и переустановите
:TSUninstall all
:TSInstall lua vim bash markdown go python
```

### Если Mason не работает:

```bash
nvim

# Проверьте Mason
:Mason

# Если пустой - обновите registry
:MasonUpdate
```

### Если ничего не помогает:

```bash
# Полная очистка снова
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

# Клонируйте снова
git clone https://github.com/nedoletoff/nvim_config.git ~/.config/nvim

# Запустите с чистого листа
nvim --headless "+Lazy! sync" +qa && nvim
```

## Полезные команды после установки

```vim
" Управление плагинами
:Lazy                  " Открыть Lazy UI
:Lazy sync             " Синхронизировать плагины
:Lazy clean            " Удалить неиспользуемые

" GetIDE
:GetIDE list           " Список языков
:GetIDE install go     " Установить Go окружение

" Mason
:Mason                 " Открыть Mason UI  
:MasonUpdate           " Обновить registry
:MasonInstall gopls    " Установить пакет вручную

" LSP
:LspInfo               " Информация о LSP
:LspRestart            " Перезапуск LSP

" Логи
:messages              " Все сообщения
:ViewLogs              " Скрытые warnings
:checkhealth           " Проверка здоровья
```

## Ожидаемый результат

После правильной установки должно быть:
- ✅ Neovim запускается без ошибок
- ✅ `:Lazy` показывает ~40 установленных плагинов
- ✅ `:Mason` открывается и показывает UI
- ✅ `:checkhealth` не показывает критических ошибок
- ✅ LSP работает при открытии файлов
- ✅ Автодополнение работает
- ✅ Treesitter подсветка синтаксиса работает
