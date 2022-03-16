
vim.cmd([[
set runtimepath+=/Users/jhsu/.local/share/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('/Users/jhsu/.config/nvim/dein')

" Let dein manage dein
call dein#add('/Users/jhsu/.local/share/dein/repos/github.com/Shougo/dein.vim')


" lsp
call dein#add('neovim/nvim-lspconfig')
call dein#add('williamboman/nvim-lsp-installer')

call dein#add('jose-elias-alvarez/null-ls.nvim')
call dein#add('jose-elias-alvarez/nvim-lsp-ts-utils')

call dein#add('neoclide/coc.nvim', {'merged': 0, 'rev': 'release'})

" fzf
call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 }) 
call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

" commentary
call dein#add('tpope/vim-commentary')
call dein#add('JoosepAlviste/nvim-ts-context-commentstring')
call dein#add('nvim-treesitter/nvim-treesitter', {
\ 'hook_post_update': ':TSUpdate' })

call dein#add('cocopon/iceberg.vim')
call dein#add('EdenEast/nightfox.nvim')

" copilot
call dein#add('github/copilot.vim')

" git
call dein#add('airblade/vim-gitgutter')
call dein#add('f-person/git-blame.nvim')

" editorconfig
call dein#add('editorconfig/editorconfig-vim')


" Required:
call dein#end()
]])

-- vim.opt.termguicolors = true
vim.cmd('colorscheme duskfox')

vim.opt.wrap = true
vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.cc = 120
vim.opt.laststatus = 2

vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.ttyfast = true
vim.opt.swapfile = false
vim.opt.title = true

vim.g.mapleader = " "

vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

-- vim.opt.titlestring = "%{hostname()}\ \ %F\ \ %{strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}"

-- vim.opt.statusline = "%f \ \\| %{coc#status()}"
vim.cmd([[
set title
set titlestring=%{hostname()}\ \ %F\ \ %{strftime('%Y-%m-%d\ %H:%M',getftime(expand('%')))}

set statusline=%f
set statusline+=\ \\|
set statusline+=%{coc#status()}
]])

vim.opt.rtp:append('/usr/local/opt/fzf')


-- coc config
vim.cmd("command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')")

-- vim.cmd('noremap <C-b> :noh<cr>:call clearmatches()<cr>') -- clear matches Ctrl+b

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

function vmap(shortcut, command)
  map('v', shortcut, command)
end

-- nmap("<leader>a", "<cmd>Git blame<cr>")

nmap('<C-P>', '<cmd>FZF<cr>')
nmap('<C-B>', '<cmd>Buffers<cr>')
nmap('<C-S>', '<cmd>w<cr>')
imap('<C-S>', '<Esc><cmd>w<cr>i')

nmap(']c', "<cmd>call CocAction('diagnosticNext')<cr>")
nmap('{c', "<cmd>call CocAction('diagnosticPrevious')<cr>")


vim.cmd([[
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)

nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>qf <Plug>(coc-fix-current)
]])

nmap('<C-A>', '^')
nmap('<C-E>', '$')

nmap('j', 'gj')
nmap('k', 'gk')
vmap('j', 'gj')
vmap('k', 'gk')

-- git gutter
nmap(']]', "<cmd>GitGutterNextHunk<cr>")
nmap('[[', "<cmd>GitGutterPrevHunk<cr>")

nmap('gp', '<cmd>silent %!prettier --stdin-filepath %<CR>')

vim.cmd([[
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>
]])
-- nmap('K', '<cmd>call <SID>show_documentation()<cr>')

-- lsp

local lspconfig = require("lspconfig")

local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end
-- lspconfig.tsserver.setup({
--     on_attach = function(client, bufnr)
--         client.resolved_capabilities.document_formatting = false
--         client.resolved_capabilities.document_range_formatting = false
--         local ts_utils = require("nvim-lsp-ts-utils")
--         ts_utils.setup({})
--         ts_utils.setup_client(client)
--         buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
--         buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
--         buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
--         on_attach(client, bufnr)
--     end,
-- })
--

--
vim.g.gitblame_message_template = "<summary> • <date> • <author>"

-- vim.cmd([[
-- autocmd FileType typescriptreact,javascriptreact setlocal commentstring={/*\ %s\ */}
-- ]])
