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
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

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

set hidden
set expandtab
set tabstop=2
set shiftwidth=2
set number
set nobackup
set nowritebackup
set noswapfile
set noundofile
set fileencodings=utf-8,iso-2022-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,ucs-bom,euc-jp,eucjp-ms,cp932
set encoding=utf-8
set fileformats=unix,dos,mac
"set guifont=Migu_1M:h12
set guifont=Ricty\ Diminished:h12
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

set hlsearch

" Don't autofold
set foldmethod=syntax
let perl_fold=1
set foldlevel=100

au QuickfixCmdPost make,grep,grepadd,vimgrep copen | wincmd p

syntax on
let mapleader = ","

" terminal settings
noremap <f10> :rightbelow sp \| resize 10 \| term<CR>
" change to Terminal-Normal with ESC
tnoremap <Esc> <C-\><C-n>
" change to Terminal-Job when entering terminal window
if has('nvim')
  autocmd WinEnter * if &buftype ==# 'terminal' | startinsert | endif
else
  autocmd WinEnter * if &buftype ==# 'terminal' | normal i | endif
endif


" key mappings for moving between windows
noremap <Space>j <C-W>j
noremap <Space>k <C-W>k
noremap <Space>h <C-W>h
noremap <Space>l <C-W>l

" yank to clipboard
" Use pastefix.vim to avoid https://github.com/neovim/neovim/issues/1822
if has('nvim')
  set clipboard+=unnamedplus
else
  set clipboard=unnamed,autoselect
endif

nnoremap <Leader>y "*y
vnoremap <Leader>y "*y

hi ColorColumn ctermbg=235 guibg=#2c2d27
augroup cobolSettings
	autocmd!
        autocmd BufRead,BufNewFile *.ecb setfiletype cobol
        autocmd BufRead,BufNewFile *.lst setfiletype cobol
        autocmd FileType cobol execute "setlocal colorcolumn=" . join(range(73, 9999), ',')
        autocmd FileType cobol setlocal sw=2 foldmethod=expr foldexpr=CBLFoldSetting(v:lnum) foldcolumn=3 foldlevel=1
	"autocmd FileType cobol set sw=2 sts=4 et sta tw=72
augroup END

function! CBLFoldSetting(lnum)
  let l:line = getline(a:lnum)
  if l:line =~ '^.*SECTION\.'
    return '>1'
  elseif getline(a:lnum) =~ '^.*EXIT\.'
    return '<1'
  elseif getline(a:lnum - 1) =~ '^.*EXIT\.'
    return 0
  else
    return '='
  endif
endfunction

inoremap <silent> jj <ESC>

noremap <Tab> :cn<CR>
noremap <S-Tab> :cp<CR>

noremap <f1> :bprev<CR>
noremap <f2> :bnext<CR>
