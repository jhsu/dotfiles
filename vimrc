set t_Co=256
set nocompatible              " We're running Vim, not Vi!
syntax on                     " Enable syntax highlighting
filetype plugin indent on

set background=dark

" Vundle packages

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" Plugin helpers
Bundle 'L9'
Bundle 'Align'

Bundle 'scrooloose/syntastic'
Bundle 'rbgrouleff/bclose.vim'
Bundle 'searchfold.vim'

Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

Bundle 'rvm.vim'

" Themes
Bundle 'jhsu/tomorrow-vim'
Bundle 'effkay/argonaut.vim'

" Syntax
Bundle 'JSON.vim'
Bundle 'tpope/vim-rails'
Bundle 'Rubytest.vim'
Bundle 'henrik/vim-ruby-runner'
Bundle 'vim-ruby/vim-ruby'
Bundle 'Handlebars'
Bundle 'go.vim'
Bundle 'vim-coffee-script'
Bundle 'coffee.vim'
Bundle 'Markdown'
Bundle 'jelera/vim-javascript-syntax'

Bundle 'ack.vim'
Bundle 'surround.vim'
Bundle 'bogado/file-line'

" SCM
"" hg
Bundle 'thermometer'
"" git
Bundle 'tpope/vim-fugitive'
Bundle 'Gundo'
Bundle 'airblade/vim-gitgutter'

Bundle 'taglist-plus'
Bundle 'SuperTab-continued.'
Bundle 'Vim-Rspec'
Bundle 'endwise.vim'

Bundle 'tpope/vim-commentary'

" Gist
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'

" navigation
Bundle 'ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'netrw.vim'
Bundle 'unimpaired.vim'

""""""""""""""""""""""""""""""""""""""

set lazyredraw

" Mouse controls (iterm2)
set ttymouse=xterm2
set mouse=i " only allow mouse in insert mode to allow command+click

" Tabs / Spacing
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set listchars=tab:▸\ ,eol:¬,trail:☠
set list

set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu " show tab completion results
" set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set relativenumber
" set undofile
set ignorecase
set smartcase
" set gdefault " This messes up search and replace
set incsearch
set showmatch

nnoremap <leader><space> :let @/=''<cr>

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=80

set title
set guifont="Inconsolata 14"

nnoremap ; :

set viminfo^=!
set clipboard=unnamed

set history=50        " have fifty lines of command-line (etc) history:
set nobackup          " Don't leave backup files (swp is good)
set complete=.,w,b,t  " Word completion rules

set noruler
set number

" MatchIt - included n vim
runtime! macros/matchit.vim   " Load matchit (% to bounce from do to end, etc.)
let &guicursor = &guicursor . ",a:blinkon0" " stops blink wake up
set guicursor=

""""""""""""""""""""""""""""""""""""""

" FileType
" most this stuff should be moved to ~/.vim/ftplugin/<filetype>.vim
augroup myfiletypes
  autocmd FileType ruby,eruby,yaml,ru set ai sw=2 sts=2 ts=2 ofu=syntaxcomplete#Complete
  autocmd FileType python set ts=8 expandtab shiftwidth=4 softtabstop=4 ofu=syntaxcomplete#Complete
  autocmd FileType html,css set ai sw=2 sts=2 ts=2 ofu=syntaxcomplete#Complete
  autocmd FileType css set  omnifunc=csscomplete#Complete
  autocmd FileType php set ai sw=2 sts=2 ts=2
  autocmd FileType go  setl noexpandtab shiftwidth=0 tabstop=8 softtabstop=8 nolist
  autocmd FileType coffee setl foldmethod=indent shiftwidth=2 expandtab
  autocmd FileType json setlocal autoindent formatoptions=tcq2l textwidth=78 shiftwidth=2 softtabstop=2 tabstop=8 expandtab foldmethod=syntax
augroup END

autocmd BufNewFile,BufReadPost Vagrantfile,Guardfile setlocal filetype=ruby
autocmd BufNewFile,BufReadPost *.go setlocal filetype=go
autocmd BufNewFile,BufReadPost *.coffee setlocal filetype=coffee

""""""""""""""""""""""""""""""""""""""

" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" KEYBOARD BINDINGS

nnoremap ' `
nnoremap ` '
let mapleader = ","

vnoremap . :norm.<CR>

" yank current line to unnamed register
vnoremap Y "*y
noremap <leader>p :set paste<CR>"*p<CR>:set nopaste<CR>

"faster scrolling using <C-e> and <C-y>
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Better jump to beginning of line to be like regex
" nnoremap 0 ^
" nnoremap ^ 0

" save
map <C-s> :w<CR>
map <C-c> <esc>

" bash hotkeys
" vmap <C-c> y
" vmap <C-x> x
imap <C-v> <esc>p

" highlight search
set hlsearch

set shortmess=atI " rid interruptive prompts

set visualbell

set nobackup          " Don't leave backup files (swp is good)
set noswapfile
set complete=.,w,b,t  " Word completion rules

if has("statusline")
  set statusline=%<%F\ %#ErrorMsg#%{fugitive#statusline()}%#StatusLine#%=%([%M%R%H%W]\ %)%l,%c%V\ %P\ (%n)
  " set statusline+=%{buftabs#statusline()} " BufTabs, conflicts with powerline
  set statusline+=%{rvm#statusline()}
  set laststatus=2
endif                     " set statusline format

set showbreak=\\          " show line break
" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
" set formatoptions-=t

" have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" use <Ctrl>+N/<Ctrl>+P to cycle through files:
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>
inoremap jj <Esc>

" have % bounce between angled brackets, as well as t'other kinds:
set matchpairs+=<:>

" Up and down visually, including wrap
map j gj
map k gk

" Snippets
imap <C-q> <C-]>

" tab navigation
map bn :bn<CR>
map bp :bp<CR>
" uses BClose plugin
nnoremap <silent> bd :Bclose<CR>

" Smart sentence recognition
set cpo+=J

" Quickfix window
map <leader>c :ccl<cr>

" NERD_tree
map <silent> <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" Git
let g:git_branch_status_head_current=1
let g:git_branch_status_ignore_remotes=1 
let g:git_branch_status_nogit=""
let g:git_branch_status_text="text"

" Ruby
command! FR set filetype=ruby
if has("autocmd")
  au FileType ruby map  <buffer> <C-e>   :RunRuby<CR>
endif

" VimClojure
let clj_highlight_builtins = 1

" Ack
let g:ackprg="ack -H --nocolor --nogroup --column"
cabbrev ack Ack

"Ctrp
" map <leader>t :CtrlP<cr>
map <leader>t :CtrlPMixed<cr>
let g:ctrlp_match_window_reversed=0
let g:ctrlp_match_window_bottom=0
let g:ctrlp_map = ''

nmap ; :CtrlPBuffer<CR>
set wildignore+=doc/**,tmp/**,

set noequalalways

" Gitv
nmap <leader>gv :Gitv --all<cr>
nmap <leader>gV :Gitv! --all<cr>
cabbrev git Git
highlight diffAdded guifg=#00bf00
highlight diffRemoved guifg=#bf0000

" Gundo
nnoremap <F5> :GundoToggle<CR>

" Vim-powerline
let g:Powerline_symbols = 'fancy'

" RubyTest
let g:rubytest_in_quickfix = 1
let g:rubytest_cmd_test = "testdrb %p"
let g:rubytest_cmd_testcase = "testdrb %p -n '/%c/'"
map <Leader>\ <Plug>RubyTestRun<cr>
map <leader>r <Plug>RubyFileRun<cr>

" Syntastic
let g:syntastic_auto_loc_list=1 " auto open/close location-list

" UltiSnips
let g:UltiSnipsEditSplit="horizontal"

let g:UltiSnipsExpandTrigger="<tab>"

" Folding ----------------------------------------------------------------- {{{

set nofoldenable
set foldnestmax=10
set foldlevel=1
nnoremap <Space> za
vnoremap <Space> za

" Refocus folds
nnoremap ,z zMzvzz

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO
