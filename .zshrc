
# ╔══════════════════════════════════════════════╗
# ║                                              ║
# ║             ⎋ .zshrc by exshak ⎋             ║
# ║                                              ║
# ╚══════════════════════════════════════════════╝

# Plug {{{1

# Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
  zinit-zsh/z-a-rust \
  zinit-zsh/z-a-as-monitor \
  zinit-zsh/z-a-patch-dl \
  zinit-zsh/z-a-bin-gem-node
# End of Zinit's installer chunk

zinit wait lucid for \
  OMZL::git.zsh \
  OMZP::git

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit ice wait"0c" lucid reset \
  atclone"local P=${${(M)OSTYPE:#*darwin*}:+g}
    \${P}sed -i '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
    \${P}dircolors -b LS_COLORS > c.zsh" \
  atpull'%atclone' pick"c.zsh" nocompile'!' \
  atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

# }}}

# Init {{{1
# Returns whether the given command is executable or aliased.
_has() {
  return $(whence $1 >/dev/null)
}

# Options {{{1

# Completion
setopt complete_aliases # Prevent aliases from being substituted before completion is attempted.
setopt complete_in_word # Attempt to start completion from both ends of a word.
setopt list_packed # Try to make the completion list smaller by drawing smaller columns.
setopt menu_complete # Instead of listing possibilities, select the first match immediately.

# Directory
setopt auto_cd # If can't execute the directory, perform the cd command to that.
setopt auto_pushd # Make cd push the old directory onto the directory stack.
setopt pushd_ignore_dups # Don't push multiple copies of the same directory onto the stack.
setopt pushd_minus # Exchanges the meanings of `+` and `-` for pushd.

# General
setopt no_beep # Don't beep on errors.

# History
typeset -g HISTFILE=~/.zsh_history # Where history logs are stored.
typeset -g HISTSIZE=100000000 # The maximum number of events stored in the internal history list.
typeset -g SAVEHIST=$HISTSIZE # The maximum number of history events to save in the history file.
setopt extended_history # Save each command's epoch timestamps and the duration in seconds.
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_ignore_dups # Don't record an entry that was just recorded again.
setopt hist_ignore_space # Don't record an entry starting with a space.
setopt hist_reduce_blanks # Remove superfluous blanks before recording an entry.
setopt hist_verify # Don't execute the line directly instead perform history expansion.
setopt share_history # Share history between all sessions.

# Input/Output
setopt no_clobber # Don't allow `>` redirection to override existing files. Use `>!` instead.
setopt no_flow_control # Disable flow control characters `^S` and `^Q`.
setopt interactive_comments # Allow comments even in interactive shells.
setopt rm_star_wait # Before executing `rm *` first wait 10 seconds and ignore anything typed.

# Job Control
setopt long_list_jobs # Display PID when suspending processes as well.

# Prompt
setopt prompt_subst # Expansions are performed in prompts.

# Exports {{{1

if _has less; then
  export MANPAGER='less -X' # Don’t clear the screen after quitting a manual page.
  export PAGER='less'
  export LESS='-R'
fi

export HOMEBREW_INSTALL_BADGE='☕'
export HOMEBREW_NO_ANALYTICS=1

# Aliases {{{1
# Alias: List {{{2
if _has colorls; then
  # `ls` with color and icons
  alias ls='colorls -A --sd'
  alias lt='colorls --sd --tree'
  alias l='colorls -l --sd'
  alias la='colorls -lA --sd'
  alias lsd='colorls -ld --sd'
  alias lsf='colorls -lf --sd'
fi

# Alias: Shortcut {{{2
alias brewup='brew update && brew upgrade && brew cleanup && brew doctor'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias speeds='speedtest --simple --server'

# Local {{{1
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
# }}}

source $(dirname $(gem which colorls))/tab_complete.sh
