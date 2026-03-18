# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Chezmoi dotfiles for a macOS dual-monitor development environment. Managed via chezmoi's **naming convention** mode (no Go templates or `.chezmoi.toml` variables).

## Chezmoi Commands

```bash
# Apply changes
chezmoi apply

# Preview what would change
chezmoi diff

# Edit source file (opens chezmoi source, not target)
chezmoi edit ~/.zshrc

# Add a new dotfile
chezmoi add ~/.config/some-app/config

# Run once scripts live in scripts/ with executable_ prefix
chezmoi apply scripts/executable_init-layout.sh
```

## Naming Conventions

- `dot_` prefix → maps to `~/` (e.g. `dot_zshrc` → `~/.zshrc`)
- `private_` prefix → file permission 600
- `executable_` prefix → file gets execute permission
- Combinations work: `private_dot_p10k.zsh` → `~/.p10k.zsh` with mode 0600

## Architecture

### Core Stack

Alacritty → tmux (prefix=Ctrl+z) → zsh (oh-my-zsh + powerlevel10k) → Neovim

Window management: yabai (BSP tiling) + skhd (hotkeys) + sketchybar (status bar)

### Key Files

| Source Path | Target | Purpose |
|---|---|---|
| `dot_zshrc` | `~/.zshrc` | Shell config: PATH (homebrew/krew/nvm/mise), aliases (k=kubectl, ji/jo=jumpserver), auto-launches tmux in alacritty |
| `dot_tmux.conf` | `~/.tmux.conf` | tmux: prefix=Ctrl+z, hjkl pane nav, status bar disabled (delegated to sketchybar), tpm resurrect/continuum for session persistence |
| `dot_config/nvim/` | `~/.config/nvim/` | Full Neovim config (see below) |
| `dot_config/sketchybar/` | `~/.config/sketchybar/` | Lua-style sketchybar config with C event providers for CPU/network |
| `dot_yabairc` | `~/.yabairc` | Dual-monitor space layout + per-app space assignments |
| `dot_skhdrc` | `~/.skhdrc` | Alt+R rotate, Alt+F fullscreen, Cmd+Shift+HJKL focus, Ctrl+Return dropdown term |
| `dot_ideavimrc` | `~/.ideavimrc` | JetBrains Vim: leader=space, surround/commentary/easymotion |
| `scripts/executable_init-layout.sh` | run_once | Resets yabai spaces and moves apps to predefined positions |

### Neovim Config (`dot_config/nvim/`)

Based on [ayamir/nvimdots](https://github.com/ayamir/nvimdots) (embedded as a git submodule replacement).

- **Entry**: `init.lua` → `require("core")`
- **Plugin manager**: lazy.nvim (`lua/core/pack.lua`)
- **User extensions**: `lua/user/` — override settings, keymaps, plugins, snippets
- **User templates**: `lua/user_template/` — chezmoi template source for user configs
- **LSP**: mason + lspconfig, configured servers: bashls, clangd, gopls, html, jsonls, lua_ls, pylsp
- **Key plugin categories**: completion (nvim-cmp + copilot), editor (treesitter + flash + grug-far), language (Go + Rust), tools (telescope + nvim-tree + DAP), UI (catppuccin + lualine + bufferline)

## Pre-Push Security Gate

**在执行 `git push` 之前，必须先运行安全审查 agent，通过后才允许 push。**

触发条件：当用户要求 push 到远端（包括"push"、"推送到远端"、"提交到远程"等任何表达），或当本 session 准备执行 `git push` 命令时。

执行步骤：
1. 运行 `/agent dotfiles-security-reviewer` 进行安全审查
2. 等待审查报告输出，检查结论是否为 `APPROVE`
3. 如果存在 CRITICAL 或 HIGH 级别问题 → **阻止 push**，展示问题并等待用户修复
4. 如果仅有 MEDIUM 级别问题 → 提示用户确认后可继续
5. 如果 APPROVE → 执行 push

## Security Note

Do NOT commit API keys, tokens, or secrets to dotfiles. A previous incident (`62ab085`) required removing a leaked API token from `.zshrc`. Use environment variables or secret managers instead.
