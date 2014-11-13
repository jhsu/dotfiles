set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/jhsu/vimbundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Align'
NeoBundle 'ctrlp.vim'

NeoBundle 'jhsu/tomorrow-vim'

NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/nerdtree'

NeoBundle 'scrooloose/syntastic'

" Filetypes
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'StanAngeloff/php.vim'
NeoBundle 'hail2u/vim-css3-syntax'

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
set foldmethod=marker
set foldopen+=jump
set history=200
set hlsearch
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
set tabstop=2
set smartindent
set showmatch
set t_Co=256
set tabstop=2
set visualbell
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
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>


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

augroup FTOptions
	autocmd FileType css setlocal iskeyword+=-
	autocmd Syntax   javascript             setlocal isk+=$
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
