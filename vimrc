set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Align'
NeoBundle 'ctrlp.vim'

NeoBundle 'bogado/file-line'

NeoBundle 'jhsu/tomorrow-vim'

NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'

NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'mileszs/ack.vim'

NeoBundle 'scrooloose/syntastic'

" Filetypes
NeoBundle 'vim-ruby/vim-ruby'

NeoBundle 'groenewege/vim-less'
NeoBundle 'hail2u/vim-css3-syntax'

NeoBundle 'mustache/vim-mustache-handlebars'

NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'mxw/vim-jsx'

NeoBundle 'jtratner/vim-flavored-markdown'

NeoBundle 'StanAngeloff/php.vim'

NeoBundle 'vim-scripts/paredit.vim'
NeoBundle 'tpope/vim-fireplace'
" NeoBundle 'guns/vim-clojure-static'
NeoBundle 'amdt/vim-niji'
NeoBundle 'guns/vim-clojure-highlight'

NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'Shougo/neocomplete.vim'

call neobundle#end()

syntax on
filetype plugin indent on

set autoindent
set autoread
set autowrite
set backspace=2 " make backspace work like most other apps
set complete-=i
set display=lastline
if exists('+breakindent')
  set breakindent showbreak=\ +
endif
set expandtab
set foldmethod=marker
set foldopen+=jump
set history=200
set hlsearch
set ignorecase
set incsearch       " Incremental search
set laststatus=2    " Always show status line
set lazyredraw
set linebreak
set listchars=tab:\▸\ ,trail:·
set list
set mouse=nvi
set listchars=tab:\▸\ ,trail:·
set mousemodel=popup
set nocompatible
set nobackup
set noswapfile
set number
set shiftwidth=2
set smartcase
set softtabstop=2
set smartindent
set showmatch
set t_Co=256
set tabstop=2
set visualbell
set whichwrap+=<,>,h,l,[,]
set wildmenu
set wildmode=longest:full,full
set wildignore+=tags,.*.un~,*.pyc,*/tmp/*

set clipboard=unnamed
set showbreak=\\

set wildmode=longest,list,full
set wildmenu


if has("statusline")
  set statusline=%<%F\ %#ErrorMsg#%{fugitive#statusline()}%#StatusLine#%=%([%M%R%H%W]\ %)%l,%c%V\ %P\ (%n)
  " set statusline+=%{buftabs#statusline()} " BufTabs, conflicts with powerline
endif                     " set statusline format

colorscheme Tomorrow-Night

"""
" Mappings
"""
let mapleader = ","
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>
nmap <C-c> <esc>

nnoremap <C-e> :Eval<CR>
nnoremap E :%Eval<CR>

"""
" Plugin Settings
"""

let g:ctrlp_match_window = 'top,order:ttb,min:1,max:10,results:10'
map <C-t> :CtrlP<CR>
nmap ; :CtrlPBuffer<CR>
let g:ctrlp_match_window_reversed=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_map = ''
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_working_path_mode = ''

let g:NERDTreeHijackNetrw = 0
map <silent> <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
map <silent> <leader>f :execute 'NERDTreeFind '<CR>

let g:syntastic_auto_loc_list=1 " auto open/close location-list
if file_readable('.jshintrc')
  let g:syntastic_javascript_jshint_args = '--config .jshintrc'
elseif file_readable('~/.jshintrc')
  let g:syntastic_javascript_jshint_args = '--config ~/.jshintrc'
endif
let g:syntastic_html_checkers=['']

let g:ackprg="ack -H --nocolor --nogroup --column"
cabbrev ack Ack

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-i>'
let g:multi_cursor_prev_key='<C-y>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<C-c>'

"""
" Filetype
"""

augroup FTOptions
  autocmd FileType css setlocal iskeyword+=-
  autocmd Syntax   javascript             setlocal isk+=$
  autocmd FileType javascript             setlocal expandtab
  autocmd FileType xml,xsd,xslt,javascript setlocal ts=2
  autocmd FileType ruby setlocal tw=79 comments=:#\  isfname+=: expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType ruby
        \ let b:start = executable('pry') ? 'pry -r "%:p"' : 'irb -r "%:p"' |
        \ if expand('%') =~# '_test\.rb$' |
        \   let b:dispatch = 'testrb %' |
        \ elseif expand('%') =~# '_spec\.rb$' |
        \   let b:dispatch = 'rspec %' |
        \ elseif !exists('b:dispatch') |
        \   let b:dispatch = 'ruby -wc %' |
        \ endif
augroup END

NeoBundleCheck
