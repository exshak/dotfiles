### :octocat: Hi there, checkout my dotfiles! <img src="https://github.com/exshak/assets/raw/main/skyfall.png" align="right" width="400" />

🎯 `curl -sL exshak.com/dotfiles | bash`

This is my **personal configuration** for unix systems. \
The [setup](#-setup-) section will guide you through the install.

Here are some details about my setup:

- **OS** • [macOS](https://en.wikipedia.org/wiki/MacOS) , [Arch Linux](https://wiki.archlinux.org) <img src="https://github.com/exshak/assets/raw/main/archlinux.png" align="center" width="14" /> coming soon!
- **Shell** • [Zsh](https://github.com/zsh-users/zsh) 🐚 with [zinit](https://github.com/zdharma-continuum/zinit) framework! <kbd>optional</kbd>
- **Terminal** • [Alacritty](https://github.com/alacritty/alacritty), [Kitty](https://github.com/kovidgoyal/kitty), [WezTerm](https://github.com/wez/wezterm) <kbd>available</kbd>
- **Multiplexer** • [Tmux](https://github.com/tmux/tmux) with [.tmux](https://github.com/gpakosz/.tmux) and [tpm](https://github.com/tmux-plugins/tpm) plugins!
- **Text Editor** • [Neovim](https://github.com/neovim/neovim) <img src="https://github.com/exshak/assets/raw/main/neovim.svg" align="center" width="14" /> with [lazy](https://github.com/folke/lazy.nvim), [Doom Emacs](https://github.com/hlissner/doom-emacs)
- **Graphical IDE** • [VSCode](https://github.com/microsoft/vscode) <img src="https://github.com/exshak/assets/raw/main/vscode.png" align="center" width="14" /> with [neovim](https://github.com/asvetliakov/vscode-neovim), [Xcode](https://developer.apple.com/xcode)
- **Window Manager** • [Yabai](https://github.com/koekeishiya/yabai) with [Übersicht](https://github.com/felixhageloh/uebersicht) widgets!
- **Linux Environment** • [AWM](https://github.com/awesomeWM/awesome), [Dunst](https://github.com/dunst-project/dunst), [Picom](https://github.com/yshui/picom), [Polybar](https://github.com/polybar/polybar)
- **Application Launcher** • [Alfred](https://alfredapp.com) 🧢, [Rofi](https://github.com/davatorium/rofi) 🔍, [sxhkd](https://github.com/baskerville/sxhkd) 🎒

## 🌸 Setup <img src="https://img.shields.io/github/repo-size/exshak/dotfiles?style=flat-square&label=.files&labelColor=373e4d&color=cf8ef4" align="right" />

1. Install the dotfiles into a [bare repo](https://atlassian.com/git/tutorials/dotfiles).

   **macOS** • [Homebrew](https://brew.sh) and Xcode command line tools will be automatically installed.

   ```shell
   curl -sL exshak.com/dotfiles | bash
   ```

   Pre-existing dotfiles will be backed up.

2. Install [dependencies]() and enable [services]().

   - **macOS** • Edit the [`Brewfile`](../bin/Brewfile) and choose which applications you want to install.

     ```shell
     brew bundle --file=~/bin/Brewfile
     ```

   - **Arch Linux** • (and all Arch-based distributions)

3. Install system defaults and user configs.

   **macOS** • Customize the [`macos`](../bin/macos) file and adjust the settings to your preference.

   ```shell
   bash ~/bin/macos
   ```

   Restart for changes to take effect.

## 🎉 Credits

[Dotfiles](https://dotfiles.github.io)
