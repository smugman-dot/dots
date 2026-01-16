# Neovim Configuration - AI Agent Instructions

## Project Overview

This is a personalized Neovim configuration using **lazy.nvim** as the plugin manager. The architecture separates concerns into modular config files while maintaining a single `init.lua` entry point that bootstraps the environment.

### Core Architecture

- **`init.lua`** - Main entry point: sets vim options (indentation, UI, undo), treesitter config, colorscheme setup, and autocommands
- **`lua/config/`** - Configuration modules loaded by `init.lua`:
  - `lazy.lua` - Lazy.nvim bootstrap and leader key setup
  - `plugins.lua` - Plugin specification using lazy.nvim's declarative format
  - `lsp_config.lua` - Language server protocol setup, keybindings, diagnostic config
  - `cmp_settings.lua` - Completion menu (nvim-cmp) with Copilot integration
  - `which_key_config.lua` - Keybindings and leader mappings with telescope integration
  - `illuminate.lua` - Code reference highlighting configuration

## Key Patterns & Conventions

### Plugin Management

- **Lazy.nvim** is the plugin manager - plugins defined in [plugins.lua](lua/config/plugins.lua) as tables with spec format
- **Lazy-loading** used via `event` field (e.g., `"LspAttach"` for LSP plugins, `lazy = false` for colorschemes)
- Critical plugins: catppuccin/nord (themes), neovim/nvim-lspconfig, nvim-telescope, nvim-cmp

### Completion & AI Integration

- **Copilot** integrated at two layers:
  - [cmp_settings.lua](lua/config/cmp_settings.lua): Copilot suggestion accepts on `<Tab>`, fallback to completion menu
  - `copilot-lsp` plugin: Provides NES (Nested Edit Sequences) for multi-line suggestions on `<Tab>`
- **Completion sources** priority: copilot → nvim_lsp → path → luasnip, buffer
- Smart tab handler: `accept_copilot()` checks visibility before delegating to cmp

### LSP Architecture

- **Servers configured** in [lsp_config.lua](lua/config/lsp_config.lua): lua_ls, basedpyright, cssls, jsonls, html, rust_analyzer, eslint, emmet
- **Setup pattern**: `vim.lsp.config(server, opts)` then `vim.lsp.enable(server)` (Neovim 0.10+ API)
- **LspAttach autocmd** defines all keybindings via helper `map()` function with "Lsp: " prefix
- **Telescope integration**: gd→definitions, `<leader>fr`→references, `<leader>fi`→implementations
- **Hover behavior**: Pretty_hover on CursorHold, suppresses false "no client" notifications

### Keybinding Organization

- **Leader key**: Space (`vim.g.mapleader = " "`)
- **Telescope mappings** in [which_key_config.lua](lua/config/which_key_config.lua): `<leader>ff` (files), `<leader>fg` (grep), `<leader>fb` (buffers)
- **LSP mappings**: All prefixed with "Lsp: " in LspAttach, includes rename, code actions, diagnostics
- **Jump keys**: `gd` (definition), `gr` (references), `gi` (implementation), `K` (hover)
- **Escape alias**: `jk` in insert mode, leap.nvim with `s` key

### Formatting & Treesitter

- **Conform.nvim** handles formatting:
  - lua→stylua, nix→alejandra, rust→rustfmt (lsp_format fallback), js/css→prettier
- **Treesitter**: Auto-enabled for select filetypes, configured for indent, manages tsx/jsx properly
- **File type mapping**: `.js` files treated as `javascriptreact` to enable jsx syntax

### Diagnostic & Error Handling

- **Virtual text** for diagnostics: `●` marker with 2-space padding, severity-sorted
- **Notification filtering** in [lsp_config.lua](lua/config/lsp_config.lua): Suppresses "no client" and "hover capability" messages
- **Diagnostic navigation**: `[d` / `]d` for prev/next, `<leader>e` to open float

## Debugging & Development Workflows

### Essential Keybindings

- `<C-\>` - Open floating terminal (toggleterm)
- `<leader>ff` - Fuzzy find files
- `<leader>e` - Diagnostics via telescope or mini.files
- `:TSUpdate` - Update treesitter parsers (configured in plugins.lua build)
- `<leader>gg` - LazyGit integration

### Adding/Modifying Plugins

1. Edit [plugins.lua](lua/config/plugins.lua) - add spec table to the return statement
2. Use `lazy.nvim` spec format: `{ "owner/repo", dependencies = {...}, config = function() ... end }`
3. Lazy-load with `event` (e.g., `event = "LspAttach"`) or `lazy = false` for always-loaded
4. Reload with `:Lazy sync` or restart Neovim

### Modifying LSP Setup

1. Add server name to `servers` table in [lsp_config.lua](lua/config/lsp_config.lua)
2. Keybindings auto-register via LspAttach autocmd - no manual mapping needed
3. Customize capabilities or server opts before `vim.lsp.enable()`

### Testing Completion & Copilot

- `<Tab>` in insert mode: Copilot acceptance or cmp next item
- `<C-Space>` to manually trigger completion
- `<C-l>` as alternative Copilot accept
- Copilot settings in [init.lua](init.lua#L5): `suggestion.enabled = true`, `panel.enabled = true`

## Project-Specific Conventions

- **Modular config structure**: Each subsystem (lsp, cmp, keybinds) in separate file under `lua/config/`
- **Lazy-loading discipline**: Only load plugins at specific events to reduce startup time
- **Notification cleanup**: Filter irrelevant LSP notifications to keep editor quiet
- **Buffer persistence**: Auto-session saves sessions on VimLeavePre, restores on startup
- **Undo persistence**: Undo files stored in `vim.fn.stdpath("cache") .. "/undo"`

## Common Editing Tasks

| Task | File(s) to Edit |
|------|------------------|
| Add new plugin | [plugins.lua](lua/config/plugins.lua) |
| Add LSP server | [lsp_config.lua](lua/config/lsp_config.lua) + keybindings auto-register |
| Add keybinding | [which_key_config.lua](lua/config/which_key_config.lua) or [lsp_config.lua](lua/config/lsp_config.lua) for LSP |
| Change theme | [init.lua](init.lua) colorscheme setup + [plugins.lua](lua/config/plugins.lua) install field |
| Configure formatting | [init.lua](init.lua) conform.setup() + [plugins.lua](lua/config/plugins.lua) |
| Adjust completion | [cmp_settings.lua](lua/config/cmp_settings.lua) mapping or sources |

