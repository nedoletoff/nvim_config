# Python Development Setup for Neovim

Complete Python development environment for your AstroNvim configuration with LSP, formatting, linting, and debugging support.

## Features

### 1. **Language Server (LSP) - Pyright**
- Type checking and intellisense
- Hover documentation for functions/classes
- Go to definition (gd)
- Symbol references (gr)
- Diagnostics and quick fixes
- Auto-completion via nvim-cmp

### 2. **Code Formatting**
- **Black**: Python code formatter (100 character line length)
- **Ruff**: Fast Python linter and formatter
- Auto-format on save via none-ls

### 3. **Debugging (DAP)**
- **nvim-dap**: Debug Adapter Protocol support
- **nvim-dap-python**: Python-specific DAP configuration
- **nvim-dap-ui**: Interactive debugging UI

### 4. **Tools Installed via Mason**
- `pyright` - LSP server
- `black` - Code formatter
- `ruff` - Linter and formatter
- `debugpy` - Python debugger (already in mason.lua)

## Installation

1. **Ensure you have Python and pip installed:**
   ```bash
   python3 --version
   pip install --user pynvim
   ```

2. **Verify Neovim Python support:**
   ```vim
   :checkhealth python3
   ```
   You should see ✓ for python3 executable and virtualenv detection.

3. **Install dependencies (one-time setup):**
   ```bash
   pip install debugpy black ruff
   ```
   Or let Mason auto-install them:
   ```vim
   :MasonInstall pyright black ruff debugpy
   ```

## Usage

### LSP Features

| Shortcut | Action |
|----------|--------|
| `K` | Show documentation/hover |
| `gd` | Go to definition |
| `gr` | Find references |
| `gI` | Go to implementation |
| `<Leader>rn` | Rename symbol |
| `<Leader>ca` | Code actions |

### Debugging

| Shortcut | Action |
|----------|--------|
| `<F5>` | Continue execution / Start debugging |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<Leader>b` | Toggle breakpoint |
| `<Leader>B` | Set conditional breakpoint |

### Formatting

```vim
:Format  " Manual format (or <Leader>lf in AstroNvim)
```

Formatting runs automatically on save for Python files.

## Virtual Environment Support

Pyright automatically detects Python virtual environments:

1. **Global detection** (`.venv`, `venv`, etc. in project root)
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # Unix
   # or
   .venv\Scripts\activate  # Windows
   ```

2. **Start Neovim from the project directory**
   ```bash
   nvim
   ```

3. **Verify LSP found the venv:**
   ```vim
   :LspInfo
   ```
   Look for pyright with the correct Python path.

## Configuration Files Modified

- **`lua/plugins/mason.lua`** - Added pyright, black, ruff to ensure_installed
- **`lua/plugins/astrolsp.lua`** - Enabled pyright in servers list
- **`lua/plugins/python.lua`** (new) - Complete Python setup with DAP and formatting

## Troubleshooting

### LSP not working
```vim
:LspInfo  " Check if pyright is attached
:checkhealth lsp  " Diagnose LSP issues
```

### Debugger not starting
1. Ensure `debugpy` is installed: `pip install debugpy`
2. Check breakpoint is set with `<Leader>b`
3. Press `<F5>` to start debugging
4. Verify DAP UI opens (should see variables, stack trace, etc.)

### venv not detected
1. Create venv: `python -m venv .venv`
2. Restart Neovim from project root
3. Run `:LspInfo` to verify

## Development Workflow Example

```python
# Create test.py
def hello(name: str) -> str:
    """Greet someone."""
    return f"Hello, {name}!"

if __name__ == "__main__":
    result = hello("World")  # Hover (K) to see type hints
    print(result)
```

1. Hover over `hello` and press `K` to see docstring
2. Press `gd` to go to definition
3. Set breakpoint on line with `<Leader>b`
4. Press `<F5>` to debug
5. Step through with `<F10>`/`<F11>`
6. Format code with `:Format`

## Performance Tips

- **Pyright** is fast and accurate; prefers it over pylsp
- **Black** formats in milliseconds
- **Ruff** is 10x faster than traditional linters
- Lazy-load DAP to avoid startup overhead (already configured)

## Further Customization

Edit `lua/plugins/python.lua` to:
- Change line length: modify `--line-length` args
- Add more linting rules: add ruff config options
- Customize DAP breakpoint colors: modify dap-ui config

## Resources

- [Pyright Documentation](https://github.com/microsoft/pylance-release)
- [Black Code Formatter](https://black.readthedocs.io/)
- [Ruff Linter](https://github.com/astral-sh/ruff)
- [nvim-dap Wiki](https://github.com/mfussenegger/nvim-dap/wiki)
