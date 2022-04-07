source ~/.vimrc.shared

set undodir=~/.vim/undodir
set undofile

" Automatic installation for vim-plug IFF not currently installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'rhysd/vim-healthcheck'
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdcommenter' " toggle comments
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter' " search from project dir and respect .gitignore
Plug 'vim-airline/vim-airline'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mattn/emmet-vim'

" Themes
Plug 'morhetz/gruvbox'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Gruvbox
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme gruvbox
:set background=dark
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_termcolors = 256

nnoremap <silent> <Leader><Space> :call gruvbox#hls_toggle()<CR>
" inoremap <silent> <Leader><Space> <ESC>:call gruvbox#hls_toggle()<CR>a
vnoremap <silent> <Leader><Space> <ESC>:call gruvbox#hls_toggle()<CR>gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => FZF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('rg')
  let g:rg_derive_root='true'
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Remap Keys
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Easy Sourcing .vimrc
nnoremap <Leader>a :source ~/.vimrc<CR>

nnoremap <Leader>u :UndotreeShow<CR>
" nnoremap <Leader>z :UndotreeShow<CR>

nnoremap <Leader>f :Files<CR>
nnoremap <Leader>r :Rg<CR>

" Make adjusing split sizes a bit more friendly
noremap <silent> <Leader>h :vertical resize +8<CR>
noremap <silent> <Leader>l :vertical resize -8<CR>
noremap <silent> <Leader>k :resize +8<CR>
noremap <silent> <Leader>j :resize -8<CR>
noremap <silent> <Leader><Left> :vertical resize +8<CR>
noremap <silent> <Leader><Right> :vertical resize -8<CR>
noremap <silent> <Leader><Up> :resize +8<CR>
noremap <silent> <Leader><Down> :resize -8<CR>

" Testing this for coc.nvim ....
" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
