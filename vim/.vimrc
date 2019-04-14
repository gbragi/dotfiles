" More efficient escape key
:inoremap jk <esc>

" Always show current position
set ruler
set relativenumber
set number

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" backpace behaves normally
set backspace=indent,eol,start

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
nnoremap <SPACE> <Nop>
"let mapleader = " "
map <SPACE> <leader>


"--------------------------------------------------
" General settings

" stop vim from trying to be compatible with vi
set nocompatible

" enable filetype auto detection
filetype plugin indent on

" auto update file... use :e to really update
set autoread
set autowrite

" keep abandoned buffers hidden and open in the background
set hidden

" show tab completion on files
set wildmenu

" display incomplete commands
set showcmd

" time out for key codes
" wait up to 100ms after Esc for special key
set ttimeout
set ttimeoutlen=100

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg

"--------------------------------------------------
" File management

" search down into subfolders of current path
set path+=**

"--------------------------------------------------
" Search Settings
nmap <leader>h :set hlsearch!<cr>

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw


"--------------------------------------------------
" Other

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

"--------------------------------------------------
" Manage Swap Files
" set backupdir=~/.vim/tmp
" set directory=~/.vim/tmp
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"--------------------------------------------------
" Indentation

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


"--------------------------------------------------
" Visual mode related

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

"--------------------------------------------------
" Status line

" Always show the status line
set laststatus=2

"--------------------------------------------------
" Folds
set foldmethod=indent
set nofoldenable    "disable folding by default"

"--------------------------------------------------
" Custom commands

" Source faster
:nnoremap <leader>rr :source $MYVIMRC<cr>

" Open vimrc
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Yank across multiple instances
set clipboard=unnamedplus

"--------------------------------------------------
" From Arch default.vim

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" Set cursor style for insert and normal mode
let &t_SI = "\<esc>[5 q"
let &t_SR = "\<esc>[5 q"
let &t_EI = "\<esc>[2 q"

nmap <C-O> :vsc View.NavigateBackward<CR> 
nmap <C-I> :vsc View.NavigateForward<CR> 
vmap <C-O> :vsc View.NavigateBackward<CR> 
vmap <C-I> :vsc View.NavigateForward<CR>
