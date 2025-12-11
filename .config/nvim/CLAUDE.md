# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Codebase Overview

This is a Neovim configuration based on LazyVim, a modern Neovim distribution. The configuration is written in Lua and follows LazyVim's modular architecture.

### Architecture

- **Entry point**: `init.lua` - bootstraps lazy.nvim and loads configuration
- **Configuration structure**:
  - `lua/config/` - Core LazyVim configuration overrides
    - `lazy.lua` - Plugin manager setup and LazyVim initialization
    - `options.lua` - Neovim options (currently minimal)
    - `keymaps.lua` - Custom key mappings for centered scrolling and search navigation
    - `autocmds.lua` - Custom autocommands (currently minimal)
  - `lua/plugins/` - Custom plugin configurations and overrides
    - `copilot.lua` - GitHub Copilot integration with Tab key accept mapping

### LazyVim Extras Enabled

The configuration includes these LazyVim extras (from `lazyvim.json`):
- `lazyvim.plugins.extras.ai.copilot` - GitHub Copilot integration
- `lazyvim.plugins.extras.lang.docker` - Docker support
- `lazyvim.plugins.extras.lang.json` - JSON language support
- `lazyvim.plugins.extras.lang.markdown` - Markdown support
- `lazyvim.plugins.extras.lang.tailwind` - Tailwind CSS support  
- `lazyvim.plugins.extras.lang.typescript` - TypeScript support

## Development Commands

### Code Formatting
```bash
stylua . --check    # Check Lua code formatting
stylua .           # Format Lua code
```

### Configuration Management
- Configuration files are automatically reloaded when modified
- Plugin updates are automatically checked (configured in `lazy.lua`)
- Use `:Lazy` command in Neovim to manage plugins

## Key Customizations

### Custom Keymaps
- `<C-u>` / `<C-d>` - Half-page up/down with cursor centering
- `n` / `N` - Search navigation with cursor centering
- `<Tab>` (in insert mode) - Accept Copilot suggestions

### Plugin Configuration
- **Copilot**: Configured for broad filetype support with Tab key acceptance
- **LazyVim**: Uses default configuration with performance optimizations (disabled unused RTP plugins)

## File Structure Notes

- Plugin configuration files in `lua/plugins/` automatically extend LazyVim's plugin specs
- The `lazy-lock.json` file pins plugin versions for reproducible installs
- LazyVim's defaults are inherited, with custom overrides in respective config files