
" ╔══════════════════════════════════════════════╗
" ║                                              ║
" ║             ⎋ .vimrc by exshak ⎋             ║
" ║                                              ║
" ╚══════════════════════════════════════════════╝

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if exists('g:vscode')
  source $v/.vimrc.vsc
else
  source ~/.vimrc
  lua require 'config'
endif
