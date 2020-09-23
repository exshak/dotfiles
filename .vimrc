
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

" ══════════════════════════════════════════════════════════════════════════════
" Buffers
" ══════════════════════════════════════════════════════════════════════════════
set autoread " Read file again if it's detected to have been changed outside of Vim.
set hidden " Allows you to hide buffers with unsaved changes without being prompted.
set splitbelow " Splitting a window will put the new window below of the current one.
set splitright " Splitting a window will put the new window right of the current one.
set switchbuf=useopen,usetab,newtab " Jump to first open window that contains the buffer.

" ══════════════════════════════════════════════════════════════════════════════
" Colors
" ══════════════════════════════════════════════════════════════════════════════
set background=dark " Choose dark colors if available.
colorscheme dracula " Set dracula as colorscheme.

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors " Enable True Color.
endif

" ══════════════════════════════════════════════════════════════════════════════
" Display
" ══════════════════════════════════════════════════════════════════════════════
set cmdheight=1 " Number of screen lines to use for the command-line.
set laststatus=2 " Always show the status line.
set lazyredraw " Don't redraw screen while executing macros.
set noshowmode " Disable native mode indicator.
set ruler " Show line and column numbers in command-line.
set showcmd " Display key presses in the bottom right.
set showmatch " When a bracket is inserted, briefly jump to the matching one.
set ttyfast " More characters will be sent to the screen for redrawing in terminal.

" ══════════════════════════════════════════════════════════════════════════════
" Edit
" ══════════════════════════════════════════════════════════════════════════════
set matchtime=2 " Tenths of a second to show the matching parenthesis.
set modelines=0 " Set number of lines that is checked for set commands.
set nomodeline " Disable modeline altogether.
set noerrorbells " Never ring the bell for error messages.
set visualbell " Use visual bell instead of beeping on errors.
set t_vb= " No errorbell beep or visualbell flash for errors.
set timeoutlen=500 " Mapping delays in milliseconds.
set ttimeoutlen=10 " Key code delays in milliseconds.
set updatetime=300 " If this many milliseconds nothing is typed, CursorHold will trigger.

" ══════════════════════════════════════════════════════════════════════════════
" Format
" ══════════════════════════════════════════════════════════════════════════════
set foldcolumn=0 " Column with the specified width is shown at the side of the window.
set foldmethod=marker " Markers are used to specify the folding mechanism.
set foldtext=Foldy() " Use custom fold text function for folds.
set linebreak " Wrap lines in 'breakat', rather than at the last character.
set nojoinspaces " Disable inserting two spaces after '.', '?', '!' with join command.
set signcolumn=number " Always draw the sign column even if there is no sign in it.
set textwidth=0 " Prevent auto wrapping when using affecting keys.
set wrap " Wrap lines longer than the width of the window.

" ══════════════════════════════════════════════════════════════════════════════
" General
" ══════════════════════════════════════════════════════════════════════════════
set backspace=indent,eol,start " Allow backspacing over anything in insert mode.
set clipboard^=unnamed,unnamedplus " Sync system clipboard with vim registers.
set complete-=i " Options for keyword completion.
set completeopt=menuone,preview,longest " Options for insert mode completion.
set encoding=utf-8 " Default character encoding. (vim-only)
set fileformats=unix,dos,mac " Use compatible end-of-line <EOL> format.
set history=1000 " Define maximum command history size.
set mouse+=a " Enable the use of the mouse.
set scrolloff=8 " Minimum number of screen lines to keep above and below the cursor.
set shortmess+=ac " Use abbreviations and short messages in command-line menu.
set viminfo=!,%,'1000,<50,s10,h " Saves buffers, marks, registers and search history.
set whichwrap+=h,l,<,> " Allow keys that move left/right to move to the prev/next line.

" ══════════════════════════════════════════════════════════════════════════════
" Indent
" ══════════════════════════════════════════════════════════════════════════════
set autoindent " Copy indent from current line when starting a new line.
set smartindent " Automatically inserts one extra level of indentation in some cases.
set expandtab " Use the appropriate number of spaces instead of tab characters.
set smarttab " Make <Tab>, <BS> indent and remove indent in leading whitespaces.
set shiftround " Round indent to multiple of 'shiftwidth'. Applies to > and < commands.
set shiftwidth=2 " Number of spaces to use for each step of auto indent operators.
set softtabstop=2 " Number of spaces that a <Tab> counts.
set tabstop=2 " Length of a <Tab> character.

" ══════════════════════════════════════════════════════════════════════════════
" Search
" ══════════════════════════════════════════════════════════════════════════════
set grepformat=%f:%l:%c:%m,%f:%l:%m " Format to recognize for the :grep command output.
set hlsearch " Highlight the matched search results by default.
set incsearch " Instantly show results when you start searching.
set ignorecase " Makes sure default search is not case sensitive.
set smartcase " If a uppercase character is entered, the search will be case sensitive.
set shortmess-=S " Show search count message when searching, e.g. '[1/5]'.
set magic " Regex special characters can be used in search patterns.

" ══════════════════════════════════════════════════════════════════════════════
" Wild
" ══════════════════════════════════════════════════════════════════════════════
set wildmenu " Command-line completion operates in an enhanced mode.
set wildignore=*.o,*~,*.pyc " Ignore compiled files.
if s:windows
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" ══════════════════════════════════════════════════════════════════════════════
" Backup
" ══════════════════════════════════════════════════════════════════════════════
set nobackup
set noswapfile
set nowritebackup
if has('persistent_undo')
  set undodir=$v/undodir
  if !isdirectory(&undodir) | call mkdir(&undodir) | endif
  set undofile
endif

" Format the status line.
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" Mappings {{{1
let mapleader = ' '

" ══════════════════════════════════════════════════════════════════════════════
" Buffer
" ══════════════════════════════════════════════════════════════════════════════
" Close all the buffers.
nnoremap <leader>ba :bufdo bd<cr>

" Close the current buffer.
nnoremap <leader>bd :Bclose<cr>

" Buffer navigation.
nnoremap <leader>bf :bfirst<cr>
nnoremap <leader>bl :blast<cr>
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bp :bprevious<cr>

" ══════════════════════════════════════════════════════════════════════════════
" Command
" ══════════════════════════════════════════════════════════════════════════════
" Readline bindings for the command-line.
" cnoremap <C-a> <Home>
" cnoremap <C-b> <Left>
" cnoremap <expr> <C-d> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
" cnoremap <C-e> <End>
" cnoremap <expr> <C-f> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
" cnoremap <C-n> <Down>
" cnoremap <C-p> <Up>
" cnoremap <M-b> <S-Left>
" cnoremap <M-d> <S-Right><C-w>
" cnoremap <M-f> <S-Right>
" silent! exe "set <Down>=\<Esc>n"
" silent! exe "set <Up>=\<Esc>p"
" silent! exe "set <S-Left>=\<Esc>b"
" silent! exe "set <S-Right><C-w>=\<Esc>d"
" silent! exe "set <S-Right>=\<Esc>f"

" ══════════════════════════════════════════════════════════════════════════════
" Cursor
" ══════════════════════════════════════════════════════════════════════════════
" Use a block cursor in normal mode, i-beam cursor in insertmode.
if empty($TMUX)
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif

" ══════════════════════════════════════════════════════════════════════════════
" Edit
" ══════════════════════════════════════════════════════════════════════════════
" Override Ex mode with run @q.
nnoremap Q @q

" Yank from cursor to end of line.
nnoremap Y y$

" Stay in visual mode when indenting.
xnoremap < <gv
xnoremap > >gv

" ══════════════════════════════════════════════════════════════════════════════
" File
" ══════════════════════════════════════════════════════════════════════════════
" Quick close current window.
nnoremap <leader>q :q<cr>

" Quick save the current file.
nnoremap <leader>w :w<cr>

" Quick editing of the ~/.vimrc.
nnoremap <leader>e :vsp ~/.vimrc<cr>

" Switch CWD to that of the open buffer.
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>

" ══════════════════════════════════════════════════════════════════════════════
" Move
" ══════════════════════════════════════════════════════════════════════════════
" Escape with jk.
inoremap jk <Esc>
xnoremap jk <Esc>
cnoremap jk <C-c>

" Jump to start and end of line using the home row keys.
noremap H ^
noremap L $

" Save movements larger than 5 lines to the jumplist, if no count use g[jk].
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" Move lines/blocks of text using Alt+[jk].
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
xnoremap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
xnoremap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" On mac Command+[jk].
" if s:darwin
"   nnoremap <D-j> <M-j>
"   nnoremap <D-k> <M-k>
"   xnoremap <D-j> <M-j>
"   xnoremap <D-k> <M-k>
" endif

" ══════════════════════════════════════════════════════════════════════════════
" Search
" ══════════════════════════════════════════════════════════════════════════════
" Search results centered.
nnoremap <silent> n :normal! nzzzv<cr>
nnoremap <silent> N :normal! Nzzzv<cr>
nnoremap <silent> * :normal! *zzzv<cr>
nnoremap <silent> # :normal! #zzzv<cr>
nnoremap <silent> g* :normal! g*zzzv<cr>
nnoremap <silent> g# :normal! g#zzzv<cr>
nnoremap <silent> <C-o> <C-o>zzzv
nnoremap <silent> <C-i> <C-i>zzzv

" Visual mode pressing * or # searches for the current selection.
vnoremap <silent> * :<C-u>call VisualSelection('', '')<cr>/<C-r>=@/<cr><cr>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<cr>?<C-r>=@/<cr><cr>

" When you press <leader>r you can search and replace the selected text.
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<cr>

" ══════════════════════════════════════════════════════════════════════════════
" Toggle
" ══════════════════════════════════════════════════════════════════════════════
" co? : Toggle options
function! ToggleOption(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap <silent> co%s :%s<bar>set %s?<cr>", key, op, opt)
endfunction

call ToggleOption('a', 'autowrite')
call ToggleOption('b', 'background',
    \ 'let &background = &background == "dark" ? "light" : "dark"<bar>redraw')
call ToggleOption('c', 'cursorline')
call ToggleOption('h', 'hlsearch')
call ToggleOption('l', 'list')
call ToggleOption('m', 'mouse', 'let &mouse = &mouse == "" ? "a" : ""')
call ToggleOption('n', 'number')
call ToggleOption('o', 'startofline')
call ToggleOption('p', 'paste')
call ToggleOption('q', 'belloff', 'let &belloff = &belloff == "" ? "all" : ""')
call ToggleOption('r', 'relativenumber')
call ToggleOption('s', 'spell')
call ToggleOption('t', 'textwidth',
    \ 'let &textwidth = input("textwidth (". &textwidth ."): ")<bar>redraw')
call ToggleOption('v', 'visualbell')
call ToggleOption('w', 'wrap')

" ══════════════════════════════════════════════════════════════════════════════
" Window
" ══════════════════════════════════════════════════════════════════════════════
" Window navigation.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing.
nnoremap <S-Up> <C-w>+
nnoremap <S-Down> <C-w>-
nnoremap <S-Left> <C-w>>
nnoremap <S-Right> <C-w><

" Window switching.
" nnoremap <C-H> <C-w>H
" nnoremap <C-J> <C-w>J
" nnoremap <C-K> <C-w>K
" nnoremap <C-L> <C-w>L

" Split `h`orizontal or `v`ertical.
nnoremap <leader>h :split<cr>
nnoremap <leader>v :vsplit<cr>

" ══════════════════════════════════════════════════════════════════════════════
" Plugin
" ══════════════════════════════════════════════════════════════════════════════
" Commentary
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" EasyAlign
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" EasyMotion
map <leader>h <Plug>(easymotion-linebackward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>l <Plug>(easymotion-lineforward)
map <leader>f <Plug>(easymotion-bd-f)
nmap <leader>f <Plug>(easymotion-overwin-f)
map <leader>s <Plug>(easymotion-f2)
nmap <leader>s <Plug>(easymotion-overwin-f2)
" map <leader>t <Plug>(easymotion-t2)
" nmap <leader>t <Plug>(easymotion-overwin-t2)

" Fugitive
nnoremap <leader>ga :Gwrite<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gd :Gvdiff<cr>
nnoremap <leader>gg :Gwrite<cr>:Gcommit -m 'updated'<cr>:Gpush<cr>
nnoremap <leader>gh :Gbrowse<cr>
nnoremap <leader>gl :Gpull<cr>
nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gr :Gremove<cr>
nnoremap <leader>gs :Gstatus<cr>

" FZF
nnoremap <expr> <leader><leader> (expand('%') =~ 'NERD_tree' ? "\<C-w>\<C-w>" : '').":Files\<cr>"
nnoremap <leader>B :Buffers<cr>
nnoremap <leader>C :Colors<cr>
nnoremap <leader>F :GFiles<cr>
nnoremap <leader>H :History<cr>
nnoremap <leader>L :Lines<cr>
nnoremap <leader>M :Maps<cr>
nnoremap <leader>R :Rg<cr>
nnoremap <leader>T :Tags<cr>
nnoremap <leader>` :Marks<cr>

" Goyo
nnoremap <leader>G :Goyo<cr>

" NERDTree
nnoremap <leader>m :NERDTreeFind<cr>
nnoremap <leader>n :NERDTreeToggle<cr>

" Startify
nnoremap <leader>S :Startify<cr>

" Tagbar
nnoremap <leader>t :TagbarToggle<cr>

" Undotree
nnoremap <leader>u :UndotreeToggle<cr>

" Commands {{{1
augroup vimrc
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif

  " Strip trailing whitespaces automatically when saving files of certain type.
  autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call TrimWhitespace()

  " Automatically load ~/.vimrc source when saved.
  autocmd BufWritePost ~/.vimrc nested source $MYVIMRC

  " Update on buffer entry or focus change.
  autocmd FocusGained,BufEnter * checktime
augroup END

" Functions {{{1
" Don't close window, when deleting a buffer.
command! Bclose call BufferClose()
function! BufferClose()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

function! CmdLine(str)
  call feedkeys(":" . a:str)
endfunction

" For 'foldtext'.
function! Foldy()
  let linelen = &tw ? &tw : 80
  let marker = strpart(&fmr, 0, stridx(&fmr, ',')) . '\d*'
  let range = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1

  let left = substitute(getline(v:foldstart), marker, '', '')
  let leftlen = len(left)

  let right = range . ' [' . v:foldlevel . ']'
  let rightlen = len(right)

  let tmp = strpart(left, 0, linelen - rightlen)
  let tmplen = len(tmp)

  if leftlen > len(tmp)
    let left = strpart(tmp, 0, tmplen - 4) . '... '
    let leftlen = tmplen
  endif

  let fill = repeat(' ', linelen - (leftlen + rightlen))

  return left . fill . right . repeat(' ', 100)
endfunction

" Trim trailing whitespace characters from end of lines.
function! TrimWhitespace()
  let l:view = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

" Visual mode search and replace for the selected text.
function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'gv'
    call CmdLine("Ack '" . l:pattern . "' " )
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
" }}}

" Plugins {{{1
" Plugin: lightline {{{2
let g:lightline = {
  \ 'colorscheme': 'dracula',
  \ 'active': {
  \   'left': [ ['mode', 'paste'],
  \             ['fugitive', 'readonly', 'filename', 'modified'] ],
  \   'right': [ [ 'lineinfo' ], ['percent'] ]
  \ },
  \ 'component': {
  \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
  \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
  \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
  \ },
  \ 'component_visible_condition': {
  \   'readonly': '(&filetype!="help"&& &readonly)',
  \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
  \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' }
  \ }

" Plugin: limelight {{{2
let g:limelight_paragraph_span = 1
let g:limelight_priority = -1

" Plugin: splitjoin {{{2
let g:splitjoin_join_mapping = ''
let g:splitjoin_split_mapping = ''

" Plugin: vim-airline {{{2
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#whitespace#enabled = 0
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = '☰'
" let g:airline_symbols.maxlinenr = ''
" let g:airline_symbols.dirty='⚡'

" Plugin: vim-easy-align {{{2
let g:easy_align_delimiters = {
  \ '"': { 'pattern': '"', 'ignore_groups': [] }
  \ }

" Plugin: vim-easymotion {{{2
let g:EasyMotion_do_mapping        = 0
let g:EasyMotion_do_shade          = 1
let g:EasyMotion_inc_highlight     = 0
let g:EasyMotion_landing_highlight = 0
let g:EasyMotion_off_screen_search = 0
let g:EasyMotion_smartcase         = 0
let g:EasyMotion_startofline       = 0
let g:EasyMotion_use_smartsign_us  = 1
let g:EasyMotion_use_upper         = 0
let g:EasyMotion_skipfoldedline    = 0

" Plugin: vim-github-dashboard {{{2
let g:github_dashboard = { 'username': 'exshak' }

" Plugin: vim-gtfo {{{2
let g:gtfo#terminals = { 'mac': 'iterm' }

" Local {{{1
let $local = glob('~/.vimrc.local')
if filereadable($local)
  source $local
endif
" }}}

" vim: fdm=marker sw=2 ts=2 tw=0
