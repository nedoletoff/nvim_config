# Troubleshooting Python IDE Setup

## Problem 1: `:checkhealth python3` shows ERROR

### Symptoms:
- "ERROR No healthcheck found for 'python3' plugin"
- No active LSP clients in `:LspInfo`
- Hover/autocomplete not working in Python files

### Solution:

1. **Check if config files are loaded:**
   ```vim
   :lua require("user.python_healthcheck")
   ```

2. **Remove manual pyright installation** (if done via Mason GUI):
   ```vim
   :Mason
   ```
   Navigate to "pyright" and press `d` to delete. We use `basedpyright` instead.

3. **Verify basedpyright-langserver path:**
   ```bash
   # Should exist and be executable
   ls -la ~/.local/share/nvim/mason/bin/basedpyright-langserver
   ```

4. **Reinstall basedpyright via Mason:**
   ```vim
   :Mason
   ```
   Find "basedpyright-langserver" and press `i` to install.

5. **Restart Neovim** and verify:
   ```vim
   :checkhealth python3  " Should now show diagnostics
   :LspInfo              " basedpyright should be attached
   ```

---

## Problem 2: basedpyright-langserver command not found

### Symptoms:
- "ERROR Spawning language server... failed"
- "No language server for python"

### Solution:

1. **Check Mason installation:**
   ```bash
   ~/.local/share/nvim/mason/bin/basedpyright-langserver --version
   ```

2. **If not found, install via pip:**
   ```bash
   pip install --user basedpyright
   ```

3. **Or install via Mason + npm:**
   ```bash
   npm install -g basedpyright
   ```

4. **Verify in Neovim:**
   ```vim
   :checkhealth python3
   ```

---

## Problem 3: Hover info / Autocomplete not working

### Symptoms:
- Hover shows nothing or wrong info
- Autocomplete suggestions not appearing
- "basedpyright running" but no results

### Solution:

1. **Check Python installation:**
   ```bash
   python3 --version
   which python3
   ```

2. **Run healthcheck:**
   ```vim
   :checkhealth python3
   ```
   Look for:
   - ✅ python3 found
   - ✅ basedpyright-langserver installed

3. **Ensure buffer is recognized as Python:**
   ```vim
   :set filetype=python
   :LspInfo
   ```
   basedpyright should show as attached.

4. **Try hovering with explicit keybinding:**
   ```vim
   K  " AstroNvim default for hover
   ```

5. **Check LSP logs:**
   ```bash
   tail -f ~/.local/state/nvim/lsp.log
   ```

---

## Problem 4: Debugging (DAP) not working

### Symptoms:
- `:DapContinue` doesn't start debugger
- Breakpoints don't work
- No debugging UI

### Solution:

1. **Install debugpy:**
   ```bash
   pip install --user debugpy
   ```

2. **Verify installation:**
   ```bash
   python3 -c "import debugpy; print(debugpy.__version__)"
   ```

3. **Check healthcheck:**
   ```vim
   :checkhealth python3
   ``` 
   Should show ✅ debugpy installed

4. **Setup breakpoint in code:**
   ```python
   # Press <Space>db to toggle breakpoint at current line
   ```

5. **Start debugging:**
   ```vim
   :DapContinue  " Start debugger
   :DapToggleBreakpoint  " Toggle breakpoint (<Space>db)
   ```

---

## Problem 5: Black/Ruff formatting not working

### Symptoms:
- Format on save doesn't work
- `:Black` or `:Ruff` commands not found
- Code not getting formatted

### Solution:

1. **Install tools:**
   ```bash
   pip install --user black ruff
   ```

2. **Or via Mason:**
   ```vim
   :Mason
   ```
   Find and install "black" and "ruff"

3. **Verify in terminal:**
   ```bash
   which black
   which ruff
   ```

4. **Check healthcheck:**
   ```vim
   :checkhealth python3
   ```
   Should show ✅ for both tools

5. **Test formatting:**
   ```vim
   :w  " Should trigger format on save (configured in astrolsp.lua)
   ```

---

## Problem 6: LSP log shows many warnings/errors

### Solution:

1. **Check diagnostics:**
   ```vim
   :LspInfo
   ```

2. **View LSP logs:**
   ```bash
   cat ~/.local/state/nvim/lsp.log | tail -100
   ```

3. **Common issues:**
   - **"module 'basedpyright' has no attribute 'cmd'"** → Config mismatch, reload Neovim
   - **"python3: command not found"** → Install Python 3
   - **"debugpy not installed"** → `pip install --user debugpy`

---

## Quick Diagnostics Command

Run this in Neovim to get full environment status:

```vim
:checkhealth python3
```

This will show:
- ✅ or ❌ Python 3 installation
- ✅ or ⚠️ basedpyright-langserver in Mason
- ✅ or ⚠️ debugpy installation
- ✅ or ⚠️ black formatter
- ✅ or ⚠️ ruff linter

---

## Nuclear Option: Full Reset

If nothing else works:

```bash
# Backup config
cp -r ~/.config/nvim ~/.config/nvim.bak

# Remove Mason packages
rm -rf ~/.local/share/nvim/mason

# Restart Neovim - it will auto-reinstall everything
nvim

# Check status
:checkhealth python3
```

---

## Useful Commands

```vim
" Python-specific
:checkhealth python3        " Full diagnostics
:LspInfo                    " Show attached LSP servers
:LspStart basedpyright      " Manually start LSP
:LspStop basedpyright       " Stop LSP

" Debugging
:DapContinue                " Start/continue debugger
:DapToggleBreakpoint        " Toggle breakpoint
:DapStepOver                " Step over
:DapStepInto                " Step into

" Formatting
:Black                      " Format with black
:!ruff check --fix %        " Run ruff linter

" Hover/Info
K                           " Hover info (default)
:LspHover                   " Explicit hover
```

---

**See also:** `PYTHON_IDE_SETUP.md` for initial setup guide.
