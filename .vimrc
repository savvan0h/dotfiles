let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  "let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  "call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

set number
set nobackup
set noswapfile
set noundofile
set encoding=utf-8
set fileencodings=cp932
set fileformats=unix,dos,mac
"set guifont=Migu_1M:h12
set autoread
set showcmd
set cursorline
"set cursorcolumn
set smartindent
set visualbell
set showmatch
set laststatus=2
set hlsearch

map <C-g> :Gtags
map <C-h> :Gtags -f %<CR>
map <C-j> :GtagsCursor<CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>

au QuickfixCmdPost make,grep,grepadd,vimgrep copen

let NERDTreeShowHidden = 1
let g:NERDTreeWinSize=38
nnoremap <silent><C-e> :NERDTreeToggle<CR>
"autocmd VimEnter * execute 'NERDTree'

let g:winresizer_start_key = '<C-T>'

syntax on
let mapleader = ","

" neocomplete
inoremap <expr><C-l>     neocomplete#complete_common_string()

" open-browser
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" make setting
nnoremap <F5> :w<CR>:make build<CR>
inoremap <F5> <Esc>:w<CR>:make build<CR>
nnoremap <F6> :w<CR>:make run<CR>
inoremap <F6> <Esc>:w<CR>:make run<CR>
