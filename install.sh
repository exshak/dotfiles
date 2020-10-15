#!/bin/sh

# curl -fsSL https://raw.githubusercontent.com/exshak/dotfiles/master/install.sh | sh
# or
# wget -qO- https://raw.githubusercontent.com/exshak/dotfiles/master/install.sh | sh

{ # This ensures the entire script is downloaded.

  backup=$HOME/.dotfiles-backup
  dotdir=$HOME/.dotfiles
  ghrepo=https://github.com/exshak/dotfiles

  function config {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
  }

  if [[ $(uname -s) == Darwin ]]; then
    if $(command -v xcode-select) >/dev/null 2>&1; then
      echo "Xcode command line tools already installed."
    else
      $(xcode-select --install)
      sleep 1
      osascript <<EOD
        tell application "System Events"
          tell process "Install Command Line Developer Tools"
            keystroke return
            click button "Agree" of window "License Agreement"
          end tell
        end tell
      EOD
    fi
  fi

  if ! $(command -v git) >/dev/null 2>&1; then
    echo "Error: Git is not installed!"
    exit 1
  fi

  if [[ -d $dotdir ]]; then
    config pull --quiet --rebase origin master
  else
    rm -rf "$dotdir"
    git clone --bare --quiet --depth=1 "$ghrepo" "$dotdir"
    mkdir -p "$backup"
    config checkout
    if [ $? = 0 ]; then
      echo "Checked out config."
    else
      echo "Backing up pre-existing dotfiles."
      cp $HOME/.config "$backup"
      cp $HOME/.vim "$backup"
      config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} "${backup}/"{}
    fi
    config checkout -f
    config config status.showUntrackedFiles no
  fi

  ./setup.sh -t build

} # This ensures the entire script is downloaded.
