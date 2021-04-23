# Auto-attach to tmux.
if ((( $+commands[tmux] )) && [[ -z $TMUX && -z $SUDO_USER && -z $SSH_CONNECTION && $ALACRITTY_LOG ]]) {
  tmux attach-session -t '0' 2>/dev/null && exit 0
  tmux new-session -s '0' \; send "la" C-m \; splitw -h && exit 0
}
