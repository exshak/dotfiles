
# ╔══════════════════════════════════════════════╗
# ║                                              ║
# ║             ⎋ .zshrc by exshak ⎋             ║
# ║                                              ║
# ╚══════════════════════════════════════════════╝

# Plug {{{1
eval $(/opt/homebrew/bin/brew shellenv)

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

zinit light-mode for \
  kazhala/dotbare \
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
    \${P}sed -i '/DIR/c\DIR 38;5;6;1' LS_COLORS; \
    \${P}dircolors -b LS_COLORS > c.zsh" \
  atpull'%atclone' pick"c.zsh" nocompile'!' \
  atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zinit light trapd00r/LS_COLORS
# }}}

# Init {{{1

# Returns whether the given command is executable or aliased.
_has() {
  return $(whence $1 &>/dev/null)
}

# Returns whether the given statement executed cleanly.
_try() {
  return $(eval $* &>/dev/null)
}

# Options {{{1
# Option: Completion {{{2
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# setopt complete_aliases # Prevent aliases from being substituted before completion is attempted.
setopt complete_in_word # Attempt to start completion from both ends of a word.
setopt list_packed # Try to make the completion list smaller by drawing smaller columns.
setopt menu_complete # Instead of listing possibilities, select the first match immediately.

# Option: Directory {{{2
setopt auto_cd # If can't execute the directory, perform the cd command to that.
setopt auto_pushd # Make cd push the old directory onto the directory stack.
setopt pushd_ignore_dups # Don't push multiple copies of the same directory onto the stack.
setopt pushd_minus # Exchanges the meanings of `+` and `-` for pushd.

# Option: General {{{2
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' # List of characters considered part of a word.
setopt no_beep # Don't beep on errors.

# Option: History {{{2
export HISTFILE=~/.zsh_history # Where history logs are stored.
export HISTORY_IGNORE='[bf]g|clear|exit|history|l[adfls]' # Don't record some commands.
export HISTTIMEFORMAT='%F %T ' # Timestamp format of when the commands were executed.
export HISTSIZE=100000000 # The maximum number of events stored in the internal history list.
export SAVEHIST=$HISTSIZE # The maximum number of history events to save in the history file.
setopt extended_history # Save each command's epoch timestamps and the duration in seconds.
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_ignore_dups # Don't record an entry that was just recorded again.
setopt hist_ignore_space # Don't record an entry starting with a space.
setopt hist_reduce_blanks # Remove superfluous blanks before recording an entry.
setopt hist_verify # Don't execute the line directly instead perform history expansion.
setopt share_history # Share history between all sessions.

# Option: Input/Output {{{2
setopt no_clobber # Don't allow `>` redirection to override existing files. Use `>!` instead.
setopt no_flow_control # Disable flow control characters `^S` and `^Q`.
setopt interactive_comments # Allow comments even in interactive shells.
setopt rm_star_wait # Before executing `rm *` first wait 10 seconds and ignore anything typed.

# Option: Job Control {{{2
setopt long_list_jobs # Display PID when suspending processes as well.

# Option: Prompt {{{2
setopt prompt_subst # Expansions are performed in prompts.

# Exports {{{1
export PATH=~/bin:$PATH
export PATH=$(brew --prefix ruby)/bin:$PATH
export PATH=$(brew --prefix)/lib/ruby/gems/3.0.0/bin:$PATH

export XDG_CACHE_HOME=~/.cache
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export XDG_RUNTIME_DIR=/run/user

export DOTBARE_DIR=~/.dotfiles
export DOTBARE_TREE=~
export DOTBARE_BACKUP=~/.config/dotbare
export DOTBARE_FZF_DEFAULT_OPTS='--reverse'

export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
export GPG_TTY=$(tty)

export HOMEBREW_INSTALL_BADGE=☕
export HOMEBREW_NO_ANALYTICS=1

export NPM_CONFIG_CACHE=~/.cache/npm
export NPM_CONFIG_USERCONFIG=~/.config/npm/npmrc

export GOPATH=~/.local/share/go
export CARGO_HOME=~/.local/share/cargo
export RUSTUP_HOME=~/.local/share/rustup

export TASKDATA=~/.config/task
export TASKRC=~/.config/task/taskrc
export WAKATIME_HOME=~/.config/wakatime

export _Z_DATA=~/.config/dotfiles/.z
export ZINIT[ZCOMPDUMP_PATH]=~/.zinit/.zcompdump

if _has less; then
  export MANPAGER='less -X' # Don’t clear the screen after quitting a manual page.
  export PAGER='less'
  export LESS='-R'
fi

if _has nvim; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Aliases {{{1
# Alias: * {{{2
alias c='clear'
alias e='emacs'
alias h='history'
alias j='jobs'
alias m='man'
alias n='neomutt'
alias o='open'
alias za='zathura'

# Alias: Brew {{{2
alias bb='brew bundle --file=~/Brewfile'
alias bcu='brew cu'
alias bd='brew cleanup && brew doctor'
alias bi='brew install'
alias bl='brew list -1'
alias bo='brew outdated'
alias bs='brew search'
alias bt='brew tap'
alias bu='brew update && brew upgrade'

# Alias: Directory {{{2
alias mkdir='mkdir -p'
alias md='mkdir'
alias rd='rmdir'

# Alias: Docker {{{2
alias d='docker'
alias di='docker images'
alias dk='docker kill'
alias dp='docker ps'
alias dr='docker rm'
alias lk='lazydocker'

alias dc='docker-compose'
alias dcb='docker-compose build'
alias dcd='docker-compose down'
alias dce='docker-compose exec'
alias dck='docker-compose kill'
alias dcl='docker-compose logs'
alias dcp='docker-compose ps'
alias dcr='docker-compose rm'
alias dcsp='docker-compose stop'
alias dcst='docker-compose start'
alias dcu='docker-compose up'

# Alias: Dotfiles {{{2
alias cfg='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dot='dotbare'

# Alias: File {{{2
alias b='bat'
alias cat='bat'

# Alias: Git {{{2
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit -m'
alias gd='git diff'
alias ge='git extras'
alias gf='git fetch'
alias gg='git grep'
alias gi='git init'
alias gl='git l'
alias glo='git long'
alias gm='git merge'
alias gn='git notes'
alias gp='git push'
alias gr='git remote'
alias gs='git status -s'
alias gt='git tags'
alias gu='git undo'
alias gw='git worktree'
alias lg='lazygit'

# Alias: Leetcode {{{2
alias lc='leetcode'

# Alias: List {{{2
if _has colorls; then
  alias ls='colorls -Ah --group-directories-first'
elif _has gls; then
  alias ls='gls -Ah --color --group-directories-first'
elif _try ls --color; then
  alias ls='ls -Ah --color --group-directories-first'
elif _try ls -G; then
  alias ls='ls -AGh'
fi

alias la='ls -lA'
alias ld='ls -ld'
alias lf='ls -lf'
alias ll='ls -l1'
alias lo='ls -lo'
alias lr='ls -lr'
alias lt='lr -lt'

# Alias: Navigate {{{2
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias cd.='cd ..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'

alias ~='cd ~' # `cd` is probably faster to type though
alias -- -='cd -'

alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# Alias: Shortcut {{{2
alias co='cd ~/Code'
alias db='cd ~/Dropbox'
alias dl='cd ~/Downloads'
alias dm='cd ~/Documents'
alias dt='cd ~/Desktop'
alias sp='speedtest --simple --server'

# Alias: Task {{{2
alias t='task'

# Alias: Tmux {{{2
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
# alias ts='tmux new-session -s'

# Alias: Vim {{{2
alias v='nvim'
alias vs='nvim +StartupTime'
alias vu='nvim +PU'
alias vw='nvim +VimwikiIndex'

# Alias: Yarn {{{2
alias y='yarn'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yap='yarn add --peer'
alias yb='yarn build'
alias yc='yarn clean'
alias yd='yarn dev'
alias ye='yarn exec'
alias yf='yarn format'
alias yg='yarn global'
alias yga='yarn global add'
alias ygb='yarn global bin'
alias ygl='yarn global list'
alias ygr='yarn global remove'
alias ygu='yarn global upgrade'
alias yh='yarn help'
alias yi='yarn init'
alias yl='yarn list'
alias yo='yarn outdated'
alias yp='yarn pack'
alias yr='yarn remove'
alias ys='yarn serve'
alias yst='yarn start'
alias yt='yarn test'
alias yu='yarn upgrade'
alias yui='yarn upgrade-interactive'
alias yuil='yarn upgrade-interactive --latest'
alias yv='yarn version'
alias yw='yarn workspace'

# Bindings {{{1
# Use emacs key bindings.
bindkey -e

# Functions {{{1
# fzf-down
fzf-down() {
  fzf --height 50% --min-height 20 --reverse --bind ctrl-/:toggle-preview "$@"
}

# Search aliases
al() {
  local aliases
  aliases=$(alias | fzf-down | awk -F '=' '{print $1}') &&
  eval "$aliases"
}

# Browse chrome history
ch() {
  local cols sep
  export cols=$(( COLUMNS / 3 ))
  export sep='{::}'

  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h
  sqlite3 -separator $sep /tmp/h "select title, url from urls order by last_visit_time desc" |
  ruby -ne '
    cols = ENV["cols"].to_i
    title, url = $_.split(ENV["sep"])
    len = 0
    puts "\x1b[36m" + title.each_char.take_while { |e|
      if len < cols
        len += e =~ /\p{Emoji_Presentation}/ ? 2 : 1
        len -= e =~ /\p{Emoji_Modifier_Base}/ ? 1 : 0
      end
    }.join + " " * (2 + cols - len) + "\x1b[m" + url' |
  fzf --ansi --multi --no-hscroll --tiebreak=index |
  sed 's#.*\(https*://\)#\1#' | xargs open
}

# Display directory stack
ds() {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}

# Show IP addresses
ip() {
  ifconfig | awk '$1 == "inet" {print $2}'
}

# Make a directory and cd into it
mc() {
  mkdir -p $@ && cd ${@:$#}
}

# Stackoverflow favorites
so() {
  ~/bin/stackoverflow-favorites |
    fzf --ansi --reverse --with-nth ..-2 --tac --tiebreak index |
    awk '{print $NF}' | while read -r line; do
      open "$line"
    done
}

# Switch tmux-sessions
ts() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" |
    fzf --height 40% --reverse --query="$1" --select-1 --exit-0) &&
  tmux switch-client -t "$session"
}

# Plugins {{{1
# Plugin: * {{{2
source $(brew --prefix git-extras)/share/git-extras/git-extras-completion.zsh
source $(brew --prefix)/etc/profile.d/z.sh
source $(dirname $(gem which colorls))/tab_complete.sh

# Plugin: fzf {{{2
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export FZF_TMUX=0
# export FZF_TMUX_OPTS='-p80%,60%'
export FZF_DEFAULT_OPTS='
  --info=inline
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
  --bind ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle+up,shift-tab:toggle+down'

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
fi

command -v bat  > /dev/null && export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
command -v blsd > /dev/null && export FZF_ALT_C_COMMAND='blsd'
command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {}' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    tssh)         fzf "$@" --preview 'dig {}' --bind 'alt-a:select-all' --multi ;;
    *)            fzf "$@" ;;
  esac
}

# Local {{{1
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi
# }}}
