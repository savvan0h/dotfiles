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

" vim-airline
set laststatus=2
let g:airline_theme = 'tomorrow'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#hunks#enabled = 0

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

"""""""""""""""""""
" Plugin settings
"""""""""""""""""""

noremap <Tab> :cn<CR>
noremap <S-Tab> :cp<CR>

"NERDTree
let NERDTreeShowHidden = 1
let g:NERDTreeWinSize=38
nnoremap <silent><C-e> :NERDTreeToggle<CR>
"autocmd VimEnter * execute 'NERDTree'

let g:winresizer_start_key = '<C-T>'

" open-browser
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

noremap <f1> :bprev<CR>
noremap <f2> :bnext<CR>

" markdown preview
au BufRead,BufNewFile *.md set filetype=markdown
let g:previm_open_cmd = 'open -a "Google Chrome"'

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" vim-gitgutter & coc.nvim
set updatetime=250

" vim-table-mode
" Markdown-compatible tables
let g:table_mode_corner='|'

" ctrlp
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_prompt_mappings = {
    \   'PrtCurRight()':   ['<right>'],
    \   'PrtClearCache()': ['<F5>', '<C-l>'],
    \ }

" coc.nvim

let g:coc_global_extensions = [
    \'coc-css',
    \'coc-eslint',
    \'coc-html',
    \'coc-java',
    \'coc-json',
    \'coc-pairs',
    \'coc-phpls',
    \'coc-pyright',
    \'coc-tsserver',
    \'coc-prettier',
    \'coc-yaml',
    \'coc-highlight'
    \]

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

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
