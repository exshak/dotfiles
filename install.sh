#!/bin/sh

# curl -fsSL https://raw.githubusercontent.com/exshak/dotfiles/master/install.sh | sh
# or
# wget -qO- https://raw.githubusercontent.com/exshak/dotfiles/master/install.sh | sh

{ # This ensures the entire script is downloaded.

  basedir=$HOME/.dotfiles
  repourl=https://github.com/exshak/dotfiles

  function config {
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
  }

  if ! command -v git >/dev/null 2>&1; then
    echo "Error: Git is not installed!"
    exit 1
  fi

  if [ -d "$basedir" ]; then
    config pull --quiet --rebase origin master
  else
    rm -rf "$basedir"
    git clone --bare --quiet --depth=1 "$repourl" "$basedir"
    mkdir -p .config-backup
    config checkout
    if [ $? = 0 ]; then
      echo "Checked out config."
    else
      echo "Backing up pre-existing dotfiles."
      config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
    fi
    config checkout
    config config status.showUntrackedFiles no
  fi

  . setup.sh -t build

} # This ensures the entire script is downloaded.
