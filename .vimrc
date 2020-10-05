
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
Plug 'jiangmiao/auto-pairs' "Automatic brackets
Plug 'junegunn/vim-easy-align' " Alignment
Plug 'easymotion/vim-easymotion' " Movement
Plug 'justinmk/vim-sneak' " Motion
Plug 'justinmk/vim-gtfo' " Go to Terminal/File manager
Plug 'tpope/vim-eunuch' " UNIX helpers
Plug 'tpope/vim-rsi' " Readline bindings
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
Plug 'neoclide/coc.nvim', { 'branch': 'release' } " Intellisense engine
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
Plug 'tpope/vim-obsession' " Save sessions automatically
Plug 'christoomey/vim-tmux-navigator' " Tmux navigation
Plug 'puremourning/vimspector' " Graphical debugger

" Write
Plug 'junegunn/goyo.vim' " Distraction-free mode
Plug 'junegunn/limelight.vim' " Highlight current paragraph
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
" set shortmess-=S " Show search count message when searching, e.g. '[1/5]'.
set magic " Regex special characters can be used in search patterns.

" ══════════════════════════════════════════════════════════════════════════════
" Wild
" ══════════════════════════════════════════════════════════════════════════════
set wildmenu " Command-line completion operates in an enhanced mode.
set wildmode=full " Wildmenu completion options.
set wildignore=*.o,*~,*.pyc " Ignore compiled files.
set wildignorecase " Ignore case when completing in command menu.
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
" Repeat last command.
nnoremap <leader>. :<C-p><cr>

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

" Reselect last visual area.
onoremap gv :<c-u>normal! gv<cr>

" Highlight last inserted text.
nnoremap gV `[v`]

" Enter new line above or below.
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" ══════════════════════════════════════════════════════════════════════════════
" File
" ══════════════════════════════════════════════════════════════════════════════
" Quick close current window.
nnoremap <leader>q :q<cr>

" Quick close all windows.
nnoremap <leader>Q :qa<cr>

" Quick save the current file.
nnoremap <leader>w :w<cr>

" Sudo save the current file (read-only).
noremap <leader>W :w !sudo tee % > /dev/null<cr>

" Quick editing of the $MYVIMRC.
nnoremap <leader>ev :vs $MYVIMRC<cr>

" Quick reload of the $MYVIMRC.
nnoremap <leader>so :so $MYVIMRC<cr>

" Switch CWD to that of the open buffer.
nnoremap <leader>cd :lcd %:p:h<cr>:pwd<cr>

" ══════════════════════════════════════════════════════════════════════════════
" Move
" ══════════════════════════════════════════════════════════════════════════════
" Escape with jk.
inoremap jk <Esc>
xnoremap jk <Esc>
cnoremap jk <C-c>

" Jump to start and end of line using the home row keys.
noremap H ^
noremap L g_

" Save movements larger than 5 lines to the jumplist, if no count use g[jk].
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" Indent lines/blocks of text using Alt+[hl].
nnoremap <M-h> <<
nnoremap <M-l> >>
xnoremap <M-h> <gv
xnoremap <M-l> >gv

" Move lines/blocks of text using Alt+[jk].
if !has('nvim')
  execute "set <M-j>=\ej"
  execute "set <M-k>=\ek"
endif
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
nnoremap <silent> g; :normal! g;zzzv<cr>
nnoremap <silent> g, :normal! g,zzzv<cr>
nnoremap <silent> <C-o> <C-o>zzzv
nnoremap <silent> <C-i> <C-i>zzzv

" Visual mode * or # searches for the current selection.
vnoremap <silent> * :call <sid>visual_search('f')<cr>
vnoremap <silent> # :call <sid>visual_search('b')<cr>

" Visual mode <leader>r can search and replace the selected text.
vnoremap <silent> <leader>r :call <sid>visual_search('r')<cr>

" Visual mode <leader>gv can Ag after the selected text.
vnoremap <silent> <leader>gv :call <sid>visual_search('g')<cr>

" ══════════════════════════════════════════════════════════════════════════════
" Toggle
" ══════════════════════════════════════════════════════════════════════════════
" co? : Toggle options
function! s:toggle_option(...)
  let [key, opt] = a:000[0:1]
  let op = get(a:, 3, 'set '.opt.'!')
  execute printf("nnoremap <silent> co%s :%s<bar>set %s?<cr>", key, op, opt)
endfunction

call s:toggle_option('a', 'autowrite')
call s:toggle_option('b', 'background',
    \ 'let &background = &background == "dark" ? "light" : "dark"<bar>redraw')
call s:toggle_option('c', 'cursorline')
call s:toggle_option('h', 'hlsearch')
call s:toggle_option('l', 'list')
call s:toggle_option('m', 'mouse', 'let &mouse = &mouse == "" ? "a" : ""')
call s:toggle_option('n', 'number')
call s:toggle_option('o', 'startofline')
call s:toggle_option('p', 'paste')
call s:toggle_option('q', 'belloff', 'let &belloff = &belloff == "" ? "all" : ""')
call s:toggle_option('r', 'relativenumber')
call s:toggle_option('s', 'spell')
call s:toggle_option('t', 'textwidth',
    \ 'let &textwidth = input("textwidth (". &textwidth ."): ")<bar>redraw')
call s:toggle_option('v', 'visualbell')
call s:toggle_option('w', 'wrap')

" ══════════════════════════════════════════════════════════════════════════════
" Window
" ══════════════════════════════════════════════════════════════════════════════
" Window navigation.
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

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

" Zoom/Restore window.
nnoremap <leader>z :Zoom<cr>
inoremap <leader>z <esc>:Zoom<cr>a

" Terminal emulation.
nnoremap <leader>sh :terminal<cr>

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
  autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call <sid>trim_whitespace()

  " Automatically load ~/.vimrc source when saved.
  autocmd BufWritePost ~/.vimrc nested source $MYVIMRC

  " Update on buffer entry or focus change.
  autocmd FocusGained,BufEnter * checktime
augroup END

" Functions {{{1
" Don't close window, when deleting a buffer.
function! s:buffer_close()
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
command! Bclose call <sid>buffer_close()

function! s:cmd_line(str)
  call feedkeys(a:str)
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
function! s:trim_whitespace()
  let l:view = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

" Visual mode search and replace for the selected text.
function! s:visual_search(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    call s:cmd_line("?" . l:pattern . "\<cr>" )
  elseif a:direction == 'f'
    call s:cmd_line("/" . l:pattern . "\<cr>" )
  elseif a:direction == 'g'
    call s:cmd_line(":Ag '" . l:pattern . "' " )
  elseif a:direction == 'r'
    call s:cmd_line(":%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Zoom
function! s:zoom() abort
  if winnr('$') > 1
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        vertical resize | resize
        let t:zoomed = 1
    endif
  else
    execute "silent !tmux resize-pane -Z"
  endif
endfunction
command! Zoom call <sid>zoom()
" }}}

" Plugins {{{1
" Plugin: goyo {{{2
nnoremap <leader>G :Goyo<cr>

function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
  endif
  Limelight
  let &l:statusline = '%M'
  hi StatusLine ctermfg=red guifg=red cterm=NONE gui=NONE
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
  endif
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <sid>goyo_enter()
autocmd! User GoyoLeave nested call <sid>goyo_leave()

" let g:goyo_margin_bottom = 2
" let g:goyo_margin_top = 2
" let g:goyo_width=100

" Plugin: gv {{{2
function! s:gv_expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

autocmd! FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>

" Plugin: indentline {{{2
let g:indentLine_fileTypeExclude = ['markdown', 'startify']
" let g:indentLine_char = '¦'
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" let g:indentLine_color_term = 239
" let g:indentLine_color_gui = '#616161'

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

" Plugin: nerdtree {{{2
nnoremap <leader>m :NERDTreeFind<cr>
nnoremap <leader>n :NERDTreeToggle<cr>

" Open NERDTree automatically when opening a directory.
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END

let NERDTreeIgnore = ['.DS_Store$', '.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden = 1
let g:NERDTreeHighlightFolders = 1
let g:NERDTreeHighlightFoldersFullName = 1
" let g:NERDTreeDirArrowExpandable = ''
" let g:NERDTreeDirArrowCollapsible = ''

" Plugin: provider {{{2
if executable('python2')
  let g:python_host_prog = exepath('python2')
else
  let g:loaded_python_provider = 0
endif

if executable('python3')
  let g:python3_host_prog = exepath('python3')
else
  let g:loaded_python3_provider = 0
endif

let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_ruby_provider = 0

" Plugin: splitjoin {{{2
let g:splitjoin_join_mapping = ''
let g:splitjoin_split_mapping = ''

" Plugin: tagbar {{{2
nnoremap <leader>ta :TagbarToggle<cr>

let g:tagbar_autoclose = 0
let g:tagbar_autofocus = 1
let g:tagbar_compact   = 1
let g:tagbar_sort      = 0

" Plugin: undotree {{{2
nnoremap <leader>u :UndotreeToggle<cr>

let g:undotree_WindowLayout = 2

" Plugin: vim-airline {{{2
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#whitespace#enabled = 0
" let g:airline_section_z = "%p%% %l/%L \ue0a1:%c"
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = '☰'
" let g:airline_symbols.maxlinenr = ''
" let g:airline_symbols.dirty='⚡'

" Plugin: vim-commentary {{{2
map  gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" Plugin: vim-easy-align {{{2
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

let g:easy_align_delimiters = {
  \ '"': { 'pattern': '"', 'ignore_groups': [] }
  \ }

" Plugin: vim-easymotion {{{2
map <leader>h <Plug>(easymotion-linebackward)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>l <Plug>(easymotion-lineforward)
nmap <leader>s <Plug>(easymotion-s2)
nmap <leader>s <Plug>(easymotion-overwin-f2)

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

" Plugin: vim-fugitive {{{2
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

" Plugin: vim-github-dashboard {{{2
let g:github_dashboard = { 'username': 'exshak' }

" Plugin: vim-gtfo {{{2
let g:gtfo#terminals = { 'mac': 'iterm' }

" Plugin: vim-signify {{{2
" Update Git signs every time the text is changed.
autocmd vimrc TextChanged,TextChangedI * call sy#start()

let g:signify_sign_add          = '│'
let g:signify_sign_change       = '│'
let g:signify_sign_changedelete = '│'
let g:signify_skip_filetype = { 'journal': 1 }
let g:signify_vcs_list = ['git']

" Plugin: vim-sneak {{{2
let g:sneak#label = 1
let g:sneak#prompt = '👟 '

" Plugin: vim-startify {{{2
nnoremap <leader>st :Startify<cr>

let g:startify_change_to_dir       = 1
let g:startify_custom_header       = 'startify#pad(startify#fortune#boxed())'
let g:startify_enable_special      = 0
let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles     = 1
let g:startify_use_env             = 1
let g:startify_bookmarks=[
  \ '~/.vimrc',
  \ '~/.zshrc',
  \ ]

" Plugin: vim-surround {{{2
vnoremap Si S(i_<esc>f)

autocmd FileType mako vnoremap Si S"i${ _(<esc>2f"a) }<esc>

let g:surround_indent = 1

" Plugin: vimwiki {{{2
let g:vimwiki_global_ext = 0
let g:vimwiki_map_prefix = '<leader>x'

" Local {{{1
let $local = expand('~/.vimrc.local')
if filereadable($local)
  source $local
endif
" }}}

" vim: fdm=marker sw=2 ts=2 tw=0
