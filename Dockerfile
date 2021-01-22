FROM archlinux
RUN pacman -Syu --noconfirm
RUN pacman -S git --noconfirm
RUN useradd -ms /bin/bash archie
RUN gpasswd -a archie wheel
RUN echo 'archie ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER archie
RUN curl -sL exshak.com/dotfiles | bash
