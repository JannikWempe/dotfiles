" Don't try to be vi compatible
set nocompatible

" Turn on syntax highlighting
syntax on

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

set smartindent

set colorcolumn=80
highlight ColorColumn ctermbg=235 guibg=#2c2d27
let &colorcolumn="80,".join(range(120,999),",")

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

set noswapfile
set nobackup

set undodir=~/.vim/undodir
set undofile

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
set hlsearch
set incsearch
set smartcase
set showmatch

call plug#begin('~/.vim/plugged')

Plug 'rhysd/vim-healthcheck'
Plug 'preservim/nerdtree'
Plug 'mbbill/undotree'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter' " search from project dir and respect .gitignore

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Uncomment to autostart the NERDTree
" autocmd vimenter * NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Remap Keys
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=" "

" Remap ESC to ii
:imap ii <Esc>

" Easy Sourcing .vimrc
nnoremap <Leader>a :source ~/.vimrc<CR>

" Disable Arrow Keys
for key in ['<Up>', '<Down>', '<Left>', '<Right>']
  exec 'noremap' key '<Nop>'
  exec 'inoremap' key '<Nop>'
endfor

nnoremap <Leader>u :UndotreeShow<CR>

nnoremap <Leader>f :Files<CR>
nnoremap <Leader>r :Rg<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Move Blocks
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Splits and Tabbed Files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set splitbelow splitright

" Remap splits navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Make adjusing split sizes a bit more friendly
noremap <silent> <Leader>h :vertical resize +8<CR>
noremap <silent> <Leader>l :vertical resize -8<CR>
noremap <silent> <Leader>k :resize +8<CR>
noremap <silent> <Leader>j :resize -8<CR>
