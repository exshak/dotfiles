" ╔══════════════════════════════════════════╗
" ║           ⎋ .vimrc by exshak ⎋           ║
" ╚══════════════════════════════════════════╝

let s:darwin = has('mac')
let s:windows = has('win32') || has('win64')
let $v = $HOME.(s:darwin ? '/.vim' : '\vim')

set runtimepath+=$v

" Plug {{{1
if empty(glob($v.'/autoload/plug.vim'))
  silent !curl -fLo $v/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($v.'/plugged')

" Colors
Plug 'dracula/vim', { 'as': 'dracula' }
  let g:dracula_italic = 0
Plug 'morhetz/gruvbox'
  let g:gruvbox_contrast_dark = 'soft'
Plug 'tomasr/molokai'
  let g:molokai_original = 0
Plug 'altercation/vim-colors-solarized'
  let g:solarized_termtrans = 0
Plug 'arzg/vim-colors-xcode'

" Display
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'

" Edit
Plug 'editorconfig/editorconfig-vim'
Plug 'andrewradev/splitjoin.vim'
Plug 'markonm/traces.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'mg979/vim-visual-multi'

" Format
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'justinmk/vim-gtfo'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-vinegar'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'mhinz/vim-signify'
Plug 'rhysd/git-messenger.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-github-dashboard'

" Lang
Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim'
Plug 'mattn/emmet-vim'
Plug 'ap/vim-css-color'
Plug 'sheerun/vim-polyglot'
Plug 'honza/vim-snippets'

" Browse
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'romainl/vim-cool'

" Tools
Plug 'metakirby5/codi.vim'
Plug 'tpope/vim-dispatch'
Plug 'puremourning/vimspector'

" Write
Plug 'junegunn/goyo.vim'
Plug 'vimwiki/vimwiki'

call plug#end()
" }}}

" Options {{{1
augroup vimrc
  autocmd!
augroup END
" }}}

" Local {{{1
let $local = glob('~/.vimrc.local')
if filereadable($local)
  source $local
endif
" }}}

" vim: fdm=marker sw=2 ts=2 tw=0
