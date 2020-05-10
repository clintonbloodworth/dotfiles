" ================ Plugins ================

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'bling/vim-bufferline'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sleuth' " Automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
Plug 'tpope/vim-surround'
Plug 'wellsjo/vim-save-cursor-position'
call plug#end()

" ================ Plugin Settings ================

let g:bufferline_show_bufnr = 0
let g:bufferline_echo = 0
let g:fzf_layout = { 'window': '' }
let g:lightline = {
  \ 'colorscheme': 'seoul256',
  \ 'active': {
  \   'left': [['bufferline']],
  \   'right': [['lineinfo'], ['percent'], ['readonly']]
  \ },
  \ 'inactive': {
  \     'right': [['filename']]
  \  },
  \ 'component_function': {
  \   'bufferline': 'Bufferline'
  \ }
  \ }

function! Bufferline()
  call bufferline#refresh_status()
  let b = g:bufferline_status_info.before
  let c = g:bufferline_status_info.current
  let a = g:bufferline_status_info.after
  return b . c . a
endfunction

" ================ Vim Settings ================

let g:netrw_banner=0

set autoread | au CursorHold * checktime | call feedkeys("lh") " Autoreload changed files (https://stackoverflow.com/a/48296697)
set backupdir=$HOME/.config/nvim/backups
set clipboard=unnamedplus
set directory=$HOME/.config/nvim/swaps
set expandtab " always uses spaces instead of tab characters
set fileencoding=utf-8
set hidden " Allow switching buffers without saving
set hlsearch " Highlight search text
set ignorecase
set incsearch " Highlight search text as pattern is typed
set mouse= " https://github.com/neovim/neovim/issues/5052
set noerrorbells " No error bells
set noshowmode
set scrolloff=5 " Scroll some columns before vertical border of window
set shiftwidth=4 " size of an "indent"
set shortmess=IF
set sidescroll=5 " Scroll some lines before horizontal border of window
set smartcase " Case sensitive searches only when caps are present
set splitbelow
set splitright
set tabstop=4 " size of a hard tabstop
set textwidth=100
set ttimeoutlen=50  " Make Esc work faster
set undodir=$HOME/.config/nvim/undo
set undofile
set viminfo=%,'50,\"100,:100,n$HOME/.config/nvim/viminfo
set wildignorecase

silent! !mkdir -p $HOME/.config/nvim/backups
silent! !mkdir -p $HOME/.config/nvim/swaps
silent! !mkdir -p $HOME/.config/nvim/undo

" ================ Key Bindings ================

let mapleader=" "

nnoremap <leader>0 :set list!<cr> " Toggle whitespace
nnoremap <leader>d :bd<cr>
nnoremap <leader>e :Explore<cr>
nnoremap <leader>o :Files <CR>
nnoremap <leader>n :enew<CR>
nnoremap <leader>p :Commands<CR>
noremap <leader>q :q<CR>
noremap <leader>w :w<cr>
noremap <leader>z :w<cr>:q<cr>
noremap <S-h> :update<CR>:bprevious<CR>
noremap <S-l> :update<CR>:bnext<CR>
nnoremap Q <nop> " Disable Ex Mode

" Split panes
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Clear highlighting on escape in normal mode
" https://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting
" https://vi.stackexchange.com/questions/4907/mouse-wheel-scrolling-inserts-characters
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

" Maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" ================ Autocmds ================

autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o " Disable next-line comment insertion
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd FileType help wincmd L " Split help to right
autocmd FileType crontab setlocal nobackup nowritebackup
