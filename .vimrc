
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
Plug 'jiangmiao/auto-pairs' " Automatic brackets
Plug 'yggdroot/indentline' " Indentation level
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
Plug 'styled-components/vim-styled-components', { 'branch': 'main' } " JSX

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
" Plug 'wakatime/vim-wakatime' " Automatic time tracking
Plug 'puremourning/vimspector' " Graphical debugger

" Write
Plug 'junegunn/goyo.vim' " Distraction-free mode
Plug 'junegunn/limelight.vim' " Highlight current paragraph
Plug 'vimwiki/vimwiki' " Personal Wiki
Plug 'iamcco/markdown-preview.nvim', {
  \ 'do': { -> mkdp#util#install() },
  \ 'for': ['markdown', 'vim-plug'],
  \ 'on': 'MarkdownPreview'
  \ } " Preview markdown

let g:plug_url_format = 'git@github.com:%s.git'

Plug 'exshak/vim-autonohl' " Automatic nohlsearch
Plug 'exshak/vim-easypaste' " Easy auto paste mode
Plug 'exshak/vim-position' " Restore last position

unlet! g:plug_url_format

call plug#end()
" }}}

" Options {{{1
augroup vimrc
  autocmd!
augroup END

filetype plugin indent on " Enable loading {ftdetect,ftplugin,indent}/*.vim files.
syntax on " Enable loading syntax/*.vim files.

" - Buffer {{{2
set autoread " Read file again if it's detected to have been changed outside of Vim.
set hidden " Allows you to hide buffers with unsaved changes without being prompted.
set sessionoptions-=options " Options for `mksession` command.
set splitbelow " Splitting a window will put the new window below of the current one.
set splitright " Splitting a window will put the new window right of the current one.
set switchbuf=useopen,usetab,newtab " Jump to first open window that contains the buffer.

" - Command {{{2
set cmdheight=1 " Number of screen lines to use for the command-line.
set noshowmode " Disable native mode indicator.
set ruler " Show line and column numbers in command-line.
set showcmd " Display key presses in the bottom right.

" - Display {{{2
set diffopt=filler,vertical,hiddenoff,foldcolumn:0,algorithm:patience " Settings for diff mode.
set display=lastline " As much as possible of the last line in a window will be displayed.
set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:\  " Characters used in UI elements.
set laststatus=2 " Always show the status line.
set showmatch " When a bracket is inserted, briefly jump to the matching one.
set synmaxcol=300 " Maximum column in which to search for syntax items.
set viewoptions-=options " Options used by `mkview` and `loadview` commands.

if s:windows
  set listchars=tab:>\ ,trail:.,eol:$,nbsp:_,extends:>,precedes:< " Unicode strings to use
else
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:»,precedes:« " when 'list' option set.
endif

if has('patch-8.1.1564')
  set signcolumn=number " Recently vim can merge signcolumn and number column into one.
else
  set signcolumn=auto " Always draw the sign column even if there is no sign in it.
endif

" - Edit {{{2
set backspace=indent,eol,start " Allow backspacing over anything in insert mode.
set clipboard^=unnamed,unnamedplus " Sync system clipboard with vim registers.
set complete-=i " Options for keyword completion.
set completeopt=menuone,preview,longest " Options for insert mode completion.
set nojoinspaces " Disable inserting two spaces after '.', '?', '!' with join command.

" - Error {{{2
set belloff=all " Never ring the bell for any reason.
set noerrorbells " Never ring the bell for error messages.
set visualbell " Use visual bell instead of beeping on errors.
set t_vb= " No errorbell beep or visualbell flash for errors.

" - Fold {{{2
set foldlevelstart=0 " Start editing with all folds open.
set foldmethod=marker " Markers are used to specify the folding mechanism.
set foldopen+=insert " Specifies for which type of commands folds will be opened.
set foldtext=Foldy() " Use custom fold text function for folds.

" - Format {{{2
set autoindent " Copy indent from current line when starting a new line.
set smartindent " Automatically inserts one extra level of indentation in some cases.
set expandtab " Use the appropriate number of spaces instead of tab characters.
set smarttab " Make <Tab>, <BS> indent and remove indent in leading whitespaces.
set shiftround " Round indent to multiple of 'shiftwidth'. Applies to > and < commands.
set shiftwidth=2 " Number of spaces to use for each step of auto indent operators.
set softtabstop=2 " Number of spaces that a <Tab> counts.
set tabstop=2 " Length of a <Tab> character.
set linebreak " Wrap lines in 'breakat', rather than at the last character.
set startofline " Move cursor to the start of each line when jumping with certain commands.
set textwidth=0 " Prevent auto wrapping when using affecting keys.
set wrap " Wrap lines longer than the width of the window.

if has('patch-7.4.338')
  let &showbreak = '↪ '
  let &showbreak = '↳ '
  set breakindent " Wrapped lines will be visually indented with same amount of space.
  set breakindentopt=sbr
endif

" - General {{{2
set cpoptions+=q " Standard compatibility options for Vim's default behaviour.
set encoding=utf-8 " Default character encoding. (vim-only)
set fileformats=unix,dos,mac " Use compatible end-of-line <EOL> format.
set formatoptions=tcroqnj " General text formatting options used by many mechanics.
set history=10000 " Define maximum command history size.
set lazyredraw " Don't redraw screen while executing macros.
set modelines=0 " Set number of lines that is checked for set commands.
set nomodeline " Disable modeline altogether.
set nrformats=bin,hex " Only accept binary and hexadecimal numbers.
set report=0 " Threshold for reporting number of lines changed.
set shortmess+=ac " Use abbreviations and short messages in command-line menu.
set ttyfast " More characters will be sent to the screen for redrawing in terminal.

" - Motion {{{2
set matchpairs+=<:> " Use % to jump between pairs.
set mouse=a " Enable the use of the mouse.
set scrolloff=5 " Minimum number of screen lines to keep above and below the cursor.
set sidescrolloff=5 " Minimum number of screen columns to keep to cursor right.
set whichwrap+=h,l,<,> " Allow keys that move left/right to move to the prev/next line.

" - Search {{{2
set grepformat=%f:%l:%c:%m,%f:%l:%m " Format to recognize for the :grep command output.
set hlsearch " Highlight the matched search results by default.
set incsearch " Instantly show results when you start searching.
set ignorecase " Makes sure default search is not case sensitive.
set smartcase " If a uppercase character is entered, the search will be case sensitive.
set path=.,, " List of directories which will be searched when using related features.
set tags=./.git/tags;,./tags;,tags " Look for `tags` file in .git/ directory.
set magic " Regex special characters can be used in search patterns.

" - Time {{{2
set matchtime=2 " Tenths of a second to show the matching parenthesis.
set timeoutlen=500 " Mapping delays in milliseconds.
set ttimeoutlen=50 " Key code delays in milliseconds.
set updatetime=300 " If this many milliseconds nothing is typed, CursorHold will trigger.

" - Wild {{{2
set wildmenu " Command-line completion operates in an enhanced mode.
set wildmode=full " Wildmenu completion options.
set wildignore=*.o,*~,*.pyc " Ignore compiled files.
set wildignorecase " Ignore case when completing in command menu.

if s:windows
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" - Backup {{{2
set nobackup
set noswapfile
set nowritebackup

if has('persistent_undo')
  set undodir=$v/undodir
  if !isdirectory(&undodir) | call mkdir(&undodir) | endif
  set undofile
  set undolevels=10000 " Maximum undo limit.
endif

if has('nvim')
  set shada=!,%,'1000,<50,s10,h " Saves buffers, marks, registers and history.
else
  set viminfo=!,%,'1000,<50,s10,h " Saves buffers, marks, registers and history.
endif

" - Color {{{2
set background=dark " Choose dark colors if available.
colorscheme dracula " Set dracula as colorscheme.

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors " Enable True Color.
endif

" Mappings {{{1
" Set leader.
let mapleader = ' '
let maplocalleader = ' '

" - Abbrev {{{2
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

function! s:command_abbrev(from, to)
  exec 'cnoreabbrev <expr> '.a:from
    \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
    \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

call s:command_abbrev('C', 'CocConfig')

iabbrev Licence License
iabbrev xdate <C-r>=strftime('%x')<cr>
iabbrev zdate <C-r>=strftime('%b %d, %Y')<cr>

" #!! | Shebang
inoreabbrev <expr> #!! "#!/usr/bin/env" . (empty(&filetype) ? '' : ' '.&filetype)

" - Buffer {{{2
" Close all buffers.
nnoremap <leader>ba :bufdo bd<cr>
" Close the current buffer.
nnoremap <leader>bd :Bclose<cr>

" Navigate buffers.
nnoremap <leader>bf :bfirst<cr>
nnoremap <leader>bl :blast<cr>
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bp :bprevious<cr>

" Search buffers.
nnoremap <leader>bs :cex []<BAR>bufdo vimgrepadd @@g %<BAR>cw<s-left><s-left><right>

" - Command {{{2
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

" - Display {{{2
" Reveal syntax group under cursor.
nnoremap <leader>sx :echo
  \ map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<cr>

" Use a block cursor in normal mode, i-beam cursor in insertmode.
if !has('nvim') && !has('gui')
  if has('unix')
    let &t_EI = "\<Esc>[2 q" " [E]nd [I]nsert
    let &t_SI = "\<Esc>[6 q" " [S]tart [I]nsert
    let &t_SR = "\<Esc>[4 q" " [S]tart [R]eplace
  elseif has('macuinx')
    if empty($TMUX)
      let &t_EI = "\<Esc>]50;CursorShape=0\x7"
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    else
      let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
      let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
      let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    endif
  endif
endif

" - Edit {{{2
" Override Ex mode with run @q.
nnoremap Q @q

" Yank from cursor to end of line.
nnoremap Y y$

" Reselect last visual area.
onoremap gv :<c-u>normal! gv<cr>

" Highlight last inserted text.
nnoremap g. :<c-u>normal! `[v`]<cr><left>

" New line above or below.
inoremap <leader>o <C-o>o
inoremap <leader>O <C-o>O

" - File {{{2
" Open in IntelliJ.
if s:darwin
  nnoremap <silent> <leader>ij :call
    \ system('nohup "/Applications/IntelliJ IDEA.app/Contents/MacOS/idea"
    \ '.expand('%:p').'> /dev/null 2>&1 < /dev/null &')<cr>
endif

" - Format {{{2
" Auto indent pasted text.
nnoremap <leader>p p=`]
nnoremap <leader>P P=`]

" Stay in visual mode when indenting.
xnoremap < <gv
xnoremap > >gv

" Indent lines/blocks of text using Alt+[hl].
nnoremap <M-h> <<
nnoremap <M-l> >>
xnoremap <M-h> <gv
xnoremap <M-l> >gv

" - General {{{2
" Quick close current window.
nnoremap <leader>q :q<cr>
" Quick close all windows.
nnoremap <leader>Q :qa<cr>

" Quick save the current file.
nnoremap <leader>w :w<cr>
" Sudo save the current file (read-only).
nnoremap <leader>W :w !sudo tee % > /dev/null<cr>

" Quick editing of the $MYVIMRC.
nnoremap <leader>ev :vs $MYVIMRC<cr>
" Quick reload of the $MYVIMRC.
nnoremap <leader>so :so $MYVIMRC<cr>

" Switch CWD to that of the open buffer.
nnoremap <leader>cd :lcd %:p:h<cr>:pwd<cr>

" - Jump {{{2
" Jump list centered.
nnoremap <silent> <C-o> <C-o>zzzv
nnoremap <silent> <C-i> <C-i>zzzv

" Jump list (newer).
nnoremap <C-p> <C-i>

" Jump to tag directly when there is only one match.
nnoremap <C-]> g<C-]>zt
nnoremap g[ :pop<cr>
nnoremap <bs> <c-t>

" - Motion {{{2
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

" Scroll viewport faster.
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

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

" - Python {{{2
" URL encode/decode selection.
vnoremap <leader>de :!python -c 'import sys,urllib;
  \ print urllib.unquote(sys.stdin.read().strip())'<cr>
vnoremap <leader>en :!python -c 'import sys,urllib;
  \ print urllib.quote(sys.stdin.read().strip())'<cr>

" - Search {{{2
" Center search results.
nnoremap <silent> n :normal! nzzzv<cr>
nnoremap <silent> N :normal! Nzzzv<cr>
nnoremap <silent> * :normal! *zzzv<cr>
nnoremap <silent> # :normal! #zzzv<cr>
nnoremap <silent> g* :normal! g*zzzv<cr>
nnoremap <silent> g# :normal! g#zzzv<cr>
nnoremap <silent> g; :normal! g;zzzv<cr>
nnoremap <silent> g, :normal! g,zzzv<cr>

nnoremap } }zz
nnoremap { {zz
nnoremap ]] ]]zz
nnoremap [[ [[zz
nnoremap [] []zz
nnoremap ][ ][zz

" Visual mode * or # searches for the current selection.
vnoremap <silent> * :call <sid>visual_search('f')<cr>
vnoremap <silent> # :call <sid>visual_search('b')<cr>

" Visual mode <leader>r can search and replace the selected text.
vnoremap <silent> <leader>r :call <sid>visual_search('r')<cr>

" Visual mode <leader>gv can Ag search after the selected text.
vnoremap <silent> <leader>gv :call <sid>visual_search('g')<cr>

" Search devdocs.io
nnoremap <silent> <leader>do :exe 'sil !open'
  \ fnameescape(printf('https://devdocs.io/#q=%s%%20%s',
  \ &ft, expand('<cword>')))<cr>

" - Spell {{{2
" Check spelling.
nnoremap <leader>s? z=
nnoremap <leader>sa zg
nnoremap <leader>sn ]s
nnoremap <leader>sp [s

" - Tab {{{2
" Manage tabs.
nnoremap <leader>td :tabclose<cr>
nnoremap <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/
nnoremap <leader>tf :tabfirst<cr>
nnoremap <leader>tl :tablast<cr>
nnoremap <leader>tm :tabmove<cr>
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>

" Toggle between this and the last accessed tab.
let g:lasttab = 1
nnoremap <leader>ts :exe "tabn ".g:lasttab<cr>
autocmd TabLeave * let g:lasttab = tabpagenr()

" - Tmux {{{2
" Send to tmux.
function! s:tmux_send(content, dest) range
  let dest = empty(a:dest) ? input('To which pane? ') : a:dest
  let tempfile = tempname()
  call writefile(split(a:content, "\n", 1), tempfile, 'b')
  call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
    \ shellescape(tempfile), shellescape(dest)))
  call delete(tempfile)
endfunction

function! s:tmux_map(key, dest)
  execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
  execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
endfunction

call s:tmux_map('<leader>tt', '')
" call s:tmux_map('<leader>th', '.left')
" call s:tmux_map('<leader>tj', '.bottom')
" call s:tmux_map('<leader>tk', '.top')
" call s:tmux_map('<leader>tl', '.right')
" call s:tmux_map('<leader>ty', '.top-left')
" call s:tmux_map('<leader>to', '.top-right')
" call s:tmux_map('<leader>tn', '.bottom-left')
" call s:tmux_map('<leader>t.', '.bottom-right')

" - Toggle {{{2
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

" - Window {{{2
" Circular navigation.
nnoremap <tab> <c-w>w
nnoremap <S-tab> <c-w>W

" Resize windows.
nnoremap <S-Up> 2<C-w>+
nnoremap <S-Down> 2<C-w>-
nnoremap <S-Left> 2<C-w>>
nnoremap <S-Right> 2<C-w><

" Split `h`orizontal or `v`ertical.
nnoremap <leader>h :split<cr>
nnoremap <leader>v :vsplit<cr>

" Zoom/Restore window.
nnoremap <leader>z :Zoom<cr>
inoremap <leader>z <esc>:Zoom<cr>a

" Terminal emulation.
nnoremap <leader>sh :terminal<cr>
tnoremap <Esc> <C-\><C-n>

" Navigate windows.
" nnoremap <C-h> <C-w>h
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-l> <C-w>l

" Switch windows.
" nnoremap <C-H> <C-w>H
" nnoremap <C-J> <C-w>J
" nnoremap <C-K> <C-w>K
" nnoremap <C-L> <C-w>L

" Commands {{{1
if s:darwin
  command! -range=% -nargs=? -complete=customlist,
    \s:colors CopyRTF call s:copy_rtf(<line1>, <line2>, <f-args>)
endif

augroup vimrc
  " Automatic renaming of the tmux window.
  if exists('$TMUX') && !exists('$NORENAME')
    autocmd BufEnter *
      \  if empty(&buftype)
      \|   call system('tmux rename-window '.expand('%:t:S'))
      \| endif
    autocmd VimLeave * call system('tmux set-window automatic-rename on')
  endif

  " Help in new tabs.
  autocmd BufEnter *.txt call s:help_tab()

  " Strip trailing whitespaces automatically when saving files of certain type.
  autocmd BufWritePre *.js,*.py,*.sh,*.txt,*.wiki call s:trim_whitespace()

  " Automatically load .vimrc source when saved.
  autocmd BufWritePost .vimrc nested source $MYVIMRC

  " Update on buffer entry or focus change.
  autocmd FocusGained,BufEnter * checktime
augroup END

" Functions {{{1
" :Bclose | Don't close window, when deleting a buffer.
function! s:buffer_close()
  let l:currentBufNum = bufnr('%')
  let l:alternateBufNum = bufnr('#')

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr('%') == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute('bdelete! '.l:currentBufNum)
  endif
endfunction
command! Bclose call <sid>buffer_close()

" Command-line helper.
function! s:cmd_line(str)
  call feedkeys(a:str)
endfunction

" Set 'foldtext'.
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

" Help in new tabs.
function! s:help_tab()
  if &buftype == 'help'
    wincmd T
    nnoremap <buffer> q :q<cr>
  endif
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
  execute 'normal! vgvy'

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", '', '')

  if a:direction == 'b'
    call s:cmd_line('?' . l:pattern . "\<cr>" )
  elseif a:direction == 'f'
    call s:cmd_line('/' . l:pattern . "\<cr>" )
  elseif a:direction == 'g'
    call s:cmd_line(":Ag '" . l:pattern . "' " )
  elseif a:direction == 'r'
    call s:cmd_line(':%s' . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" :Zoom
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
" Plugin: editorconfig {{{2
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

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
autocmd! User indentLine doautocmd indentLine Syntax

let g:indentLine_bufTypeExclude = ['help', 'nofile', 'terminal']
let g:indentLine_fileTypeExclude = ['markdown', 'nerdtree', 'startify']
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
nnoremap <leader>N :NERDTreeFind<cr>
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
" nmap <leader>s <Plug>(easymotion-s2)
" nmap <leader>s <Plug>(easymotion-overwin-f2)

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

" Filetypes {{{1

" Local {{{1
let $local = expand('~/.vimrc.local')
if filereadable($local)
  source $local
endif
" }}}

" vim: fdm=marker sw=2 ts=2 tw=0
