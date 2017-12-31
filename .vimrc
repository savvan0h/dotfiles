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

"""""""""""""""""""
" General settings
"""""""""""""""""""
filetype plugin indent on

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
set visualbell t_vb=
set showmatch
set so=5
" start searching when you type the first character of the search string
set incsearch

" reload file when switching buffer or focusing vim again
set autoread

" always show status line
set laststatus=2
" full path to the file in the buffer.
set statusline=%F
" filetype
set statusline+=%y
" modified flag, text is "[+]"; "[-]" if 'modifiable' is off.  
set statusline+=%m
" readonly flag, text is "[RO]".
set statusline+=%r
" help buffer flag, text is "[help]".
set statusline+=%h
" preview window flag, text is "[Preview]".
set statusline+=%w
" switch to the right side
set statusline+=%=
" file encoding
set statusline+=[ENC=%{&fileencoding}]
" current line/total lines
set statusline+=[LOW=%l/%L]

set hlsearch

au QuickfixCmdPost make,grep,grepadd,vimgrep copen | wincmd p

syntax on
let mapleader = ","

" make setting
nnoremap <F5> :w<CR>:make build<CR>
inoremap <F5> <Esc>:w<CR>:make build<CR>
nnoremap <F6> :w<CR>:make run<CR>
inoremap <F6> <Esc>:w<CR>:make run<CR>

" key mappings for moving between windows
noremap <Space>j <C-W>j
noremap <Space>k <C-W>k
noremap <Space>h <C-W>h
noremap <Space>l <C-W>l

" yank to clipboard
nnoremap <Leader>y "*y
vnoremap <Leader>y "*y

"""""""""""""""""""
" Plugin settings
"""""""""""""""""""

"Gtags
map <C-g> :Gtags
map <C-h> :Gtags -f %<CR>
map <C-j> :GtagsCursor<CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>

"NERDTree
let NERDTreeShowHidden = 1
let g:NERDTreeWinSize=38
nnoremap <silent><C-e> :NERDTreeToggle<CR>
"autocmd VimEnter * execute 'NERDTree'

let g:winresizer_start_key = '<C-T>'

" neocomplete
inoremap <expr><C-l>     neocomplete#complete_common_string()

" open-browser
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
