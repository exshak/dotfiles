eval $(/opt/homebrew/bin/brew shellenv)

ZINIT_HOME=$HOME/.local/share/zinit
if [[ ! -f $ZINIT_HOME/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} Installing %F{14}zdharma-continuum/zinit%F{33}…%f"
  command mkdir -p "$ZINIT_HOME" && command chmod g-rwX "$ZINIT_HOME"
  command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME/zinit.git" && \
    print -P "%F{34} Install successful%f" || print -P "%F{160} Clone failed%f"
fi

# Default {{{1
export ZPFX=~/.local/share/zinit/polaris
source "$ZINIT_HOME/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
  OMZP::git

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull"zinit creinstall -q ." \
    zsh-users/zsh-completions

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit ice wait"0c" lucid reset \
  atclone"local P=${${(M)OSTYPE:#*darwin*}:+g}
    \${P}sed -i '/DIR/c\DIR 38;5;4' LS_COLORS; \
    \${P}dircolors -b LS_COLORS > c.zsh" \
  atpull"%atclone" pick"c.zsh" nocompile"!" \
  atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"'
zinit light trapd00r/LS_COLORS

# Returns whether the given command is executable or aliased
_has() {
  return $(whence $1 &>/dev/null)
}

# Returns whether the given statement executed cleanly
_try() {
  return $(eval $* &>/dev/null)
}

# Options {{{1
zstyle ":completion:*" use-cache true
zstyle ":completion:*" cache-path $ZSH_CACHE_DIR
zstyle ":completion:*" matcher-list "m:{a-zA-Z-_}={A-Za-z_-}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"
# setopt complete_aliases # Prevent aliases from being substituted before completion is attempted.
setopt complete_in_word # Attempt to start completion from both ends of a word.
setopt list_packed # Try to make the completion list smaller by drawing smaller columns.
setopt menu_complete # Instead of listing possibilities, select the first match immediately.
setopt auto_cd # If can not execute the directory, perform the cd command to that.
setopt auto_pushd # Make cd push the old directory onto the directory stack.
setopt pushd_ignore_dups # Do not push multiple copies of the same directory onto the stack.
setopt pushd_minus # Exchanges the meanings of `+` and `-` for pushd.
export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>" # List of characters considered part of a word.
setopt no_beep # Do not beep on errors.
export HISTFILE=~/.zsh_history # Where history logs are stored.
export HISTORY_IGNORE="[clv]|[bf]g|g[dls]|l[adfls]" # Do not record some commands.
export HISTTIMEFORMAT="%F %T " # Timestamp format of when the commands were executed.
export HISTSIZE=100000000 # The maximum number of events stored in the internal history list.
export SAVEHIST=$HISTSIZE # The maximum number of history events to save in the history file.
setopt extended_history # Save each commands epoch timestamps and the duration in seconds.
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history.
setopt hist_ignore_dups # Do not record an entry that was just recorded again.
setopt hist_ignore_space # Do not record an entry starting with a space.
setopt hist_reduce_blanks # Remove superfluous blanks before recording an entry.
setopt hist_verify # Do not execute the line directly instead perform history expansion.
setopt share_history # Share history between all sessions.
setopt no_clobber # Do not allow `>` redirection to override existing files. Use `>!` instead.
setopt no_flow_control # Disable flow control characters `^S` and `^Q`.
setopt interactive_comments # Allow comments even in interactive shells.
setopt rm_star_wait # Before executing `rm *` first wait 10 seconds and ignore anything typed.
setopt long_list_jobs # Display PID when suspending processes as well.
setopt prompt_subst # Expansions are performed in prompts.

# Exports {{{1
export PATH=~/bin:$PATH
export PATH=$(brew --prefix)/bin:$PATH
export PATH=$(brew --prefix ruby)/bin:$PATH
export PATH=$(brew --prefix)/lib/ruby/gems/3.3.0/bin:$PATH

export XDG_CACHE_HOME=~/.cache
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export XDG_RUNTIME_DIR=~/.local/run/user
export XDG_STATE_HOME=~/.local/state

export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"
export GPG_TTY=$(tty)
export HOMEBREW_NO_ENV_HINTS=1
export LESS=-RFX
export LESSHISTFILE=-
export NPM_CONFIG_CACHE=~/.cache/npm
export TERMINFO=~/.local/share/terminfo
export WAKATIME_HOME=~/.config/wakatime
export ZINIT[ZCOMPDUMP_PATH]=~/.local/share/zinit/.zcompdump

if _has nvim; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

# Aliases {{{1
# * {{{2
alias b="bat"
alias c="clear"
alias e="emacs"
alias h="history"
alias j="jobs"
alias m="man"
alias n="nvim"
alias o="open"
alias p="pnpm"
alias t="task"
alias v="nvim"

# brew {{{2
alias bb="brew bundle --file=~/bin/Brewfile"
alias bcu="brew cu"
alias bd="brew cleanup && brew doctor"
alias bi="brew install"
alias bl="brew list -1"
alias bo="brew outdated"
alias bq="bu && bd"
alias bs="brew search"
alias bt="brew tap"
alias bu="brew update && brew upgrade"

# directory {{{2
alias co="cd ~/code"
alias cl="cd ~/code/leetcode"
alias cn="cd ~/.config/nvim"
alias db="cd ~/Dropbox"
alias dl="cd ~/Downloads"
alias dm="cd ~/Documents"
alias dt="cd ~/Desktop"

alias df="df -h"
alias du="du -h -d 1"
alias mkdir="mkdir -p"
alias md="mkdir"
alias rd="rmdir"

# git {{{2
alias g="git"
alias ga="git add"
alias gb="git branch"
alias gc="git commit -m"
alias gd="git diff"
alias gdss="git diff --staged --stat"
alias gdst="git diff --stat"
alias ge="git extras"
alias gf="git fetch"
alias gfr="git filter-repo"
alias gg="git grep"
alias ggc="git gc --aggressive --prune=now --quiet"
alias ghc="gh repo create"
alias ghcc="gh repo create --public --clone"
alias ghcs="gh repo create --public --source"
alias ghd="gh repo delete"
alias gi="git init"
alias gl="git l"
alias glo="git long"
alias gm="git merge"
alias gmv="git mv"
alias gn="git notes"
alias gp="git push"
alias gpl="git pull"
alias gr="git remote"
alias gre="git reflog expire --all --expire=now"
alias gs="git status -s"
alias gt="git tags"
alias gu="git undo"
alias gw="git worktree"
alias gx="git ls-files --exclude-standard --others"
alias lg="lazygit"

# list {{{2
if _has lsd; then
  alias ls="lsd -Ah --group-directories-first"
elif _has gls; then
  alias ls="gls -Ah --color --group-directories-first"
elif _try ls --color; then
  alias ls="ls -Ah --color --group-directories-first"
elif _try ls -G; then
  alias ls="ls -AGh"
fi

alias l="ls -lA"
alias la="ls -lA"
alias ld="ls -ld"
alias le="ls --tree"
alias lf="ls -lf"
alias lo="ls -lo"
alias lr="ls -lr"
alias lt="lr -lt"

# navigate {{{2
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias cd.="cd .."
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."

alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

alias 1="cd -1"
alias 2="cd -2"
alias 3="cd -3"
alias 4="cd -4"
alias 5="cd -5"
alias 6="cd -6"
alias 7="cd -7"
alias 8="cd -8"
alias 9="cd -9"

# pnpm {{{2
alias pa="pnpm add"
alias pb="pnpm build"
alias pd="pnpm run dev"
alias pi="pnpm install"
alias pp="pnpm preview"
alias pu="pnpm update"

# shortcut {{{2
alias cf="caffeinate -id"
alias hs="history | grep"
alias lc="leetcode"
alias oc="opencode"
alias py="python3"
alias sp="speedtest --simple --server"
alias ta="tmux attach -t"
alias tl="tmux list-sessions"
alias tt="tldr"
alias tw="taskwarrior-tui"
alias vl="NVIM_APPNAME=lazyvim nvim"
alias za="zathura"
alias zr="source ~/.zshrc"

alias cat="bat"
alias cfg="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias pir="pip3 install -r requirements.txt"

# Plugins {{{1
# * {{{2
bindkey -e # Use emacs key bindings
source $(brew --prefix git-extras)/share/git-extras/git-extras-completion.zsh

# fx {{{2
# fzf-down
fzf-down() {
  fzf --height 50% --min-height 20 --reverse --bind ctrl-/:toggle-preview "$@"
}

# Inside repo?
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
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
  export sep="{::}"
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
    dirs -v | head -n 10
  fi
}

# Show IP addresses
ip() {
  ifconfig | awk '$1 == "inet" {print $2}'
}

# Leetcode questions
lq() {
  local question="echo {} | awk -F '[][]' '{print \$2}'"
  leetcode list -q L"$@" |
    fzf --reverse \
      --bind  "enter:execute($question | xargs -I{} leetcode show {})+abort" \
      --bind "ctrl-g:execute($question | xargs -I{} leetcode show {} -ge)+abort"
}

# Make a directory and cd into it
mc() {
  mkdir -p $@ && cd ${@:$#}
}

# Stackoverflow favorites
sf() {
  ~/bin/stackoverflow |
    fzf --ansi --reverse --with-nth ..-2 --tac --tiebreak index |
    awk "{print $NF}" | while read -r line; do
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

_dc() {
  cd
  rm -rf ~/.dotfiles
  git clone --bare --quiet --depth=1 g:exshak/dotfiles ~/.dotfiles
  git config --local status.showUntrackedFiles no
  git config --local core.bare false
  git config --local core.worktree ~
  git remote set-url origin g:exshak/dotfiles
  git reset --quiet
  git diff --stat
}

_gc() {
  temp=$(gdate -d "2026-01-01 12:00:00 $(shuf -i 0-20000 -n 1) sec")
  GIT_AUTHOR_DATE=$temp GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE git commit -qm "$*"
  git show -s --pretty=fuller
}

# fzf {{{2
# Setup fzf
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
fi

# Auto-completion
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"

# export FZF_TMUX=0
# export FZF_TMUX_OPTS="-p80%,60%"
export FZF_DEFAULT_OPTS="
  --gutter=' '
  --info=inline
  --color=dark
  --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f,border:#44475a
  --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
  --bind ctrl-a:select-all,ctrl-d:deselect-all,tab:toggle+up,shift-tab:toggle+down"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
  export FZF_CTRL_T_COMMAND="fd --type f --type d --hidden --exclude .git"
fi

command -v bat  > /dev/null && export FZF_CTRL_T_OPTS="--preview 'bat -p --color=always --theme=Dracula {}'"
command -v blsd > /dev/null && export FZF_ALT_C_COMMAND="blsd"
command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf "$@" --preview "tree -C {}" ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview "dig {}" ;;
    tssh)         fzf "$@" --preview "dig {}" --bind "alt-a:select-all" --multi ;;
    *)            fzf "$@" ;;
  esac
}
# }}}1
