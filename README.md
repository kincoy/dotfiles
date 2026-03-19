<div align="center">


### macOS Personal Development Environment

[![macOS](https://img.shields.io/badge/macOS-sonoma-000?logo=apple&logoColor=white)]() [![Chezmoi](https://img.shields.io/badge/chezmoi-managed-007d8c)]() [![Neovim](https://img.shields.io/badge/Neovim-0.11-57A143?logo=neovim&logoColor=white)]() [![tmux](https://img.shields.io/badge/tmux-3.5a-1db954?logo=tmux&logoColor=white)]() [![yabai](https://img.shields.io/badge/yabai-bsp-e535ab)]() [![Shell](https://img.shields.io/badge/zsh-oh__my__zsh-F15F24?logo=zsh&logoColor=white)]() [![Alacritty](https://img.shields.io/badge/Alacritty-0.15-4688C8?logo=alacritty&logoColor=white)]()

</div>

---

## Terminal / 终端

- **tmux** — Prefix `Ctrl+z`, hjkl pane nav, session persistence via resurrect + continuum. 
- **zsh** — oh-my-zsh + Powerlevel10k + autosuggestions + syntax-highlighting. 
- **Alacritty** — Hack Nerd Font, 70% opacity, borderless.

<img src=".github/screenshots/terminal_multi_panel.jpg" width="420" alt="tmux panels" />
<img src=".github/screenshots/terminal_multi_window.jpg" width="420" alt="tmux windows" />

## Editor / 编辑器

**Neovim** based on [ayamir/nvimdots](https://github.com/ayamir/nvimdots) — nvim-cmp + Copilot, telescope, DAP, catppuccin.

<img src=".github/screenshots/nvim_menu.jpg" width="420" alt="neovim dashboard" />
<img src=".github/screenshots/nvim_go_code.jpg" width="420" alt="neovim go code" />

## Window Management / 窗口管理

**yabai** BSP auto-tiling + **skhd** hotkeys + **sketchybar** status bar (C event providers). Dual-monitor deterministic layout, Vim-style focus, dropdown terminal.

<img src=".github/screenshots/screen1_split.jpg" height="300" alt="display 1" />
<img src=".github/screenshots/screen2_split.jpg" height="300" alt="display 2" />

## Also includes / 其他

- **JetBrains IDE** — Vim emulation via IdeaVim
- **Tools** — kubectl, Docker, NVM, mise, lazygit, autojump

## Setup

```bash
chezmoi apply       # Apply dotfiles
chezmoi diff        # Preview changes
```

## Credits

- [chezmoi](https://www.chezmoi.io/) 
- [ayamir/nvimdots](https://github.com/ayamir/nvimdots) 
-  [yabai](https://github.com/koekeishiya/yabai) 
-  [skhd](https://github.com/koekeishiya/skhd) 
-  [sketchybar](https://github.com/FelixKratz/SketchyBar) 
-  [powerlevel10k](https://github.com/romkatv/powerlevel10k)
