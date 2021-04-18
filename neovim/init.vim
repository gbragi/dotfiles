call plug#begin('~/.vim/plugged')

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Undotree
Plug 'mbbill/undotree'

" Color schemes
Plug 'gruvbox-community/gruvbox'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'preservim/nerdcommenter'

call plug#end()

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set exrc
set relativenumber
set nu
set nohlsearch

"set hidden
"Autosave
set nohidden
set autowriteall
set autoread

set noerrorbells
set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect
set signcolumn=yes
set colorcolumn=80

" Give more space for displaying messages
set cmdheight=2

" Having longer update time (default is 4000 ms = 4 s) leads to noticable
" delays and poor user experience
set updatetime=50

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

colorscheme gruvbox
" highlight Normal guibg=None

nnoremap <SPACE> <Nop>
let mapleader = " "


lua require('customization')

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for > ")})<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <leader>pf :lua require('telescope.builtin').find_files()<CR>

nnoremap <leader>pw :lua require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>")})<CR>
nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>vrc :lua require('customization').search_dotfiles()<CR>

nnoremap <leader>gc :lua require('telescope.builtin').git_branches()<CR>


nnoremap <C-j> :cn<CR>
nnoremap <C-k> :cp<CR>

nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv
