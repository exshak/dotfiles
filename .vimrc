
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
Plug 'vim-airline/vim-airline' " Statusline
Plug 'vim-airline/vim-airline-themes' " Statusline themes
Plug 'mhinz/vim-startify' " Start screen

" Edit
Plug 'editorconfig/editorconfig-vim' " EditorConfig
Plug 'andrewradev/splitjoin.vim' " Split/join multi-lines
Plug 'markonm/traces.vim' " Substitute preview
Plug 'tpope/vim-abolish' " Word variants
Plug 'tpope/vim-commentary' " Comment
Plug 'tpope/vim-endwise' " Automatic `end`
Plug 'tpope/vim-repeat' " Repeat plugins
Plug 'tpope/vim-surround' " Surround mappings
Plug 'tpope/vim-unimpaired' " Bracket mappings
Plug 'mg979/vim-visual-multi' " Multiple cursors

" Format
Plug 'junegunn/vim-easy-align' " Alignment
Plug 'easymotion/vim-easymotion' " Movement
Plug 'justinmk/vim-gtfo' " Go to Terminal/File manager
Plug 'tpope/vim-eunuch' " UNIX helpers
Plug 'tpope/vim-vinegar' " Enhances netrw

" Git
Plug 'tpope/vim-fugitive' " Git wrapper
Plug 'tpope/vim-rhubarb' " GitHub tools
Plug 'mhinz/vim-signify' " VCS sign column
Plug 'rhysd/git-messenger.vim' " Commit messages
Plug 'junegunn/gv.vim' " Commit browser
Plug 'junegunn/vim-github-dashboard' " GitHub events

" Lang
Plug 'w0rp/ale' " Lint engine
Plug 'neoclide/coc.nvim' " Intellisense engine
Plug 'mattn/emmet-vim' " Expand HTML/XML/CSS
Plug 'ap/vim-css-color' " Preview colors
Plug 'sheerun/vim-polyglot' " Language packs
Plug 'honza/vim-snippets' " Common snippets

" Browse
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " File explorer
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' } " Ctags sidebar
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' } " Undo history visualizer
Plug 'xuyuanp/nerdtree-git-plugin' " NERDTree git status
Plug 'ryanoasis/vim-devicons' " Dev icons
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' " NERDTree syntax highlighting
Plug 'junegunn/vim-peekaboo' " Register sidebar

" Search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " FZF plugin
Plug 'junegunn/fzf.vim' " Fuzzy finder
Plug 'romainl/vim-cool' " Automatic search highlighting

" Tools
Plug 'metakirby5/codi.vim' " Interactive scratchpad
Plug 'tpope/vim-dispatch' " Test dispatcher
Plug 'puremourning/vimspector' " Graphical debugger

" Write
Plug 'junegunn/goyo.vim' " Distraction-free mode
Plug 'vimwiki/vimwiki' " Personal Wiki

call plug#end()
" }}}

" Options {{{1
augroup vimrc
  autocmd!
augroup END

filetype plugin indent on " Enable loading {ftdetect,ftplugin,indent}/*.vim files.
syntax on " Enable loading syntax/*.vim files.

" Buffers
set autoread " Read file again if it's detected to have been changed outside of Vim.
set hidden " Allows you to hide buffers with unsaved changes without being prompted.
set splitbelow " Splitting a window will put the new window below of the current one.
set splitright " Splitting a window will put the new window right of the current one.
set switchbuf=useopen,usetab,newtab " Jump to first open window that contains the buffer.

" Colors
set background=dark " Choose dark colors if available.
colorscheme dracula " Set dracula as colorscheme.

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors " Enable True Color.
endif

" Display
set cmdheight=1 " Number of screen lines to use for the command-line.
set laststatus=2 " Always show the status line.
set lazyredraw " Don't redraw screen while executing macros.
set noshowmode " Disable native mode indicator.
set ruler " Show line and column numbers in command-line.
set showcmd " Display key presses in the bottom right.
set showmatch " When a bracket is inserted, briefly jump to the matching one.
set ttyfast " More characters will be sent to the screen for redrawing in terminal.

" Edit
set matchtime=2 " Tenths of a second to show the matching parenthesis.
set modelines=0 " Set number of lines that is checked for set commands.
set nomodeline " Disable modeline altogether.
set noerrorbells " Never ring the bell for error messages.
set visualbell " Use visual bell instead of beeping on errors.
set t_vb= " No errorbell beep or visualbell flash for errors.
set timeoutlen=500 " Mapping delays in milliseconds.
set updatetime=300 " If this many milliseconds nothing is typed, CursorHold will trigger.

" Format
set foldcolumn=0 " Column with the specified width is shown at the side of the window.
set foldmethod=marker " Markers are used to specify the folding mechanism.
set foldtext=Foldy() " Use custom fold text function for folds.
set linebreak " Wrap lines in 'breakat', rather than at the last character.
set nojoinspaces " Disable inserting two spaces after '.', '?', '!' with join command.
set signcolumn=number " Always draw the sign column even if there is no sign in it.
set textwidth=0 " Prevent auto wrapping when using affecting keys.
set wrap " Wrap lines longer than the width of the window.

" General
set backspace=indent,eol,start " Allow backspacing over anything in insert mode.
set clipboard^=unnamed,unnamedplus " Sync system clipboard with vim registers.
set encoding=utf-8 " Default character encoding. (vim-only)
set fileformats=unix,dos,mac " Use compatible end-of-line <EOL> format.
set history=1000 " Define maximum command history size.
set mouse+=a " Enable the use of the mouse.
set scrolloff=8 " Minimum number of screen lines to keep above and below the cursor.
set shortmess+=ac " Use abbreviations and short messages in command-line menu.
set viminfo=!,%,'1000,<50,s10,h " Saves buffers, marks, registers and search history.
set whichwrap+=h,l,<,> " Allow keys that move left/right to move to the prev/next line.

" Indent
set autoindent " Copy indent from current line when starting a new line.
set smartindent " Automatically inserts one extra level of indentation in some cases.
set expandtab " Use the appropriate number of spaces instead of tab characters.
set smarttab " Make <Tab>, <BS> indent and remove indent in leading whitespaces.
set shiftround " Round indent to multiple of 'shiftwidth'. Applies to > and < commands.
set shiftwidth=2 " Number of spaces to use for each step of auto indent operators.
set softtabstop=2 " Number of spaces that a <Tab> counts.
set tabstop=2 " Length of a <Tab> character.

" Search
set grepformat=%f:%l:%c:%m,%f:%l:%m " Format to recognize for the :grep command output.
set hlsearch " Highlight the matched search results by default.
set incsearch " Instantly show results when you start searching.
set ignorecase " Makes sure default search is not case sensitive.
set smartcase " If a uppercase character is entered, the search will be case sensitive.
set shortmess-=S " Show search count message when searching, e.g. '[1/5]'.
set magic " Regex special characters can be used in search patterns.

" Wild
set wildmenu " Command-line completion operates in an enhanced mode.
set wildignore=*.o,*~,*.pyc " Ignore compiled files
if s:windows
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Backup
set nobackup
set noswapfile
set nowritebackup
if has('persistent_undo')
  set undodir=$v/undodir
  if !isdirectory(&undodir) | call mkdir(&undodir) | endif
  set undofile
endif

" Mappings {{{1
let mapleader = ' '
" }}}

" Local {{{1
let $local = glob('~/.vimrc.local')
if filereadable($local)
  source $local
endif
" }}}

" vim: fdm=marker sw=2 ts=2 tw=0
