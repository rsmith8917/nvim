# Neovim Configuration

A modern, modular Neovim configuration with LSP, autocompletion, fuzzy finding, and more.

## Features

- **LSP Support** - Lua, Go, TypeScript/JavaScript, Python
- **Autocompletion** - Context-aware completion with snippets
- **Fuzzy Finding** - Fast file and text search with Telescope
- **Git Integration** - LazyGit terminal UI
- **Code Formatting** - Auto-format on save with conform.nvim
- **File Explorer** - Neo-tree with system integration
- **Code Coverage** - Visual coverage display for multiple languages
- **Smart Folding** - Treesitter-based folding with peek support
- **Beautiful UI** - Catppuccin theme, lualine statusline, and more

## Installation

### Prerequisites

```bash
# Neovim 0.9+ required
nvim --version

# Required external tools
brew install ripgrep lazygit

# Language servers (install as needed)
brew install lua-language-server
go install golang.org/x/tools/gopls@latest
npm install -g typescript-language-server pyright

# Formatters (install as needed)
brew install stylua
npm install -g prettier
pip install black
# gofmt comes with Go
```

### Setup

1. Clone this repo to your Neovim config directory:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

2. Launch Neovim - plugins will auto-install:
   ```bash
   nvim
   ```

3. Wait for lazy.nvim to install all plugins (watch the bottom of the screen)

4. Restart Neovim and you're ready to go!

## Quick Start Guide

### Essential Keybindings

**Leader key is `Space`**

#### Opening Files
- `Space` `f` `f` or `Space` `Space` - Find files (fuzzy search)
- `Space` `f` `g` - Search text across project (live grep)
- `Space` `e` - Toggle file explorer (Neo-tree)

#### Buffers & Navigation
- `Tab` / `Shift+Tab` - Next/previous buffer
- `Space` `b` `d` - Close current buffer
- `Space` `b` `o` - Close all other buffers

#### Windows
- `Space` `\` - Split vertically
- `Space` `-` - Split horizontally
- `Space` `h`/`j`/`k`/`l` - Focus window (left/down/up/right)
- `Space` `w` - Close window

#### Code Navigation (LSP)
- `g` `d` - Go to definition
- `g` `r` - Find references
- `g` `i` - Go to implementation
- `g` `h` - Show diagnostic/error message
- `K` - Show documentation hover

#### Code Actions
- `Space` `.` - Code actions (fix imports, quick fixes)
- `Space` `r` - Rename symbol
- `Space` `F` - Format file (also auto-formats on save)

#### Quick File Switching (Harpoon)
- `Space` `a` - Add current file to Harpoon
- `Space` `m` - Open Harpoon menu
- `Space` `1-5` - Jump to Harpoon file 1-5

#### Git
- `Space` `g` `g` - Open LazyGit

#### Other Essentials
- `Space` `s` - Save file
- `Esc` - Clear search highlight
- `q` - Close utility windows (help, diagnostics, etc.)
- `-` - Toggle fold under cursor
- `Ctrl+n` / `Ctrl+p` - Jump to next/previous reference of word under cursor

## File Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── core/
│   │   ├── init.lua        # Core settings, autocommands
│   │   └── keymaps.lua     # All keybindings
│   └── plugins/
│       └── init.lua        # Plugin specifications
└── lazy-lock.json          # Plugin versions (auto-generated)
```

## Plugin Management

All plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

### Common Commands (run inside Neovim)

- `:Lazy` - Open plugin manager UI
- `:Lazy sync` - Update plugins to lockfile versions
- `:Lazy update` - Update all plugins to latest
- `:Lazy clean` - Remove unused plugins
- `:Lazy profile` - View startup time

## Language Support

### Configured Languages

| Language   | LSP Server | Formatter | Status |
|------------|------------|-----------|--------|
| Lua        | lua_ls     | stylua    | ✓      |
| Go         | gopls      | gofmt     | ✓      |
| TypeScript | ts_ls      | prettier  | ✓      |
| Python     | pyright    | black     | ✓      |

### Adding More Languages

1. Install the language server (check [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md))
2. Add configuration in `lua/plugins/init.lua` under the LSP section
3. Add formatter in `lua/plugins/init.lua` under conform.nvim config
4. Restart Neovim

## Customization

### Changing the Theme

Edit `lua/plugins/init.lua`:
```lua
-- Change from "mocha" to "latte", "frappe", "macchiato", or "mocha"
flavour = "mocha",
```

### Adding Keymaps

Add to `lua/core/keymaps.lua`:
```lua
vim.keymap.set("n", "<leader>x", ":YourCommand<CR>", { desc = "Description" })
```

### Disabling Auto-format on Save

Comment out in `lua/core/init.lua` (lines 84-89):
```lua
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*",
--     callback = function(args)
--         require("conform").format({ bufnr = args.buf, lsp_fallback = true })
--     end,
-- })
```

## Code Coverage

This config includes visual code coverage display:

1. Generate coverage file:
   ```bash
   # Python
   coverage run -m pytest && coverage json

   # Go
   go test -coverprofile=coverage.out

   # JavaScript/TypeScript
   npm test -- --coverage
   ```

2. In Neovim:
   - `Space` `c` `l` - Load coverage data
   - `Space` `c` `c` - Toggle coverage display (green/red bars in gutter)
   - `Space` `c` `s` - Show coverage summary

## Telescope Advanced

### Find All Files (including hidden/ignored)
- `Space` `f` `F` - Find files (no ignore)
- `Space` `f` `G` - Live grep (no ignore)

### Other Pickers
- `Space` `f` `b` - Find open buffers
- `Space` `f` `h` - Search help documentation

### Telescope Tips
- Use `Ctrl+j`/`Ctrl+k` to navigate results
- `Ctrl+q` to send results to quickfix list
- `Esc` or `q` to close

## Troubleshooting

### LSP Not Working

Check if language server is installed:
```bash
:LspInfo
```

Install missing servers using your language's package manager.

### Formatter Not Working

Check if formatter is installed:
```bash
# In terminal
which stylua
which prettier
which black
```

### Plugins Not Loading

Try syncing plugins:
```vim
:Lazy sync
```

Then restart Neovim.

### Treesitter Syntax Issues

Update parsers:
```vim
:TSUpdate
```

## Tips & Tricks

1. **Quick File Navigation** - Use Harpoon (`Space` `a` to mark files, `Space` `1-5` to jump)
2. **Project-wide Search** - `Space` `f` `g` then type your search term
3. **Multi-file Refactor** - Use `Space` `r` to rename a symbol across your project
4. **Peek Definitions** - Hover over a fold and press `K` to peek without opening
5. **Close All Buffers** - `Space` `b` `a` closes all, `Space` `b` `o` closes others
6. **Neo-tree Tips** - Press `?` in Neo-tree to see all available commands
7. **System Open** - In Neo-tree, press `o` to open file/folder in Finder/Explorer

## Resources

- [Neovim Docs](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [LSP Config Servers](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)

## License

Personal configuration - feel free to use and modify as you wish!