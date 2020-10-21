FROM archlinux
RUN pacman -Syu --noconfirm
RUN pacman -S git --noconfirm
CMD curl -fsSL https://raw.githubusercontent.com/exshak/dotfiles/master/install.sh | bash
