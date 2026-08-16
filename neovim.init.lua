-- Core editor settings carried over from ~/dotfiles/vimrc.
-- Plugin-specific configuration was intentionally left out; this file starts
-- Neovim with useful built-in defaults and no package manager dependency.

vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt

-- Editing and files
opt.autoindent = true
opt.autoread = true
opt.autowrite = true
opt.backspace = { "indent", "eol", "start" }
opt.complete:remove("i")
opt.expandtab = true
opt.hidden = true
opt.history = 200
opt.mouse = "nvi"
opt.mousemodel = "popup"
opt.backup = false
opt.swapfile = false
opt.shiftwidth = 2
opt.smartindent = true
opt.softtabstop = 2
opt.tabstop = 2

-- Search, display, and completion
opt.breakindent = true
opt.display = "lastline"
opt.foldmethod = "marker"
opt.foldopen:append("jump")
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.laststatus = 2
opt.lazyredraw = true
opt.linebreak = true
opt.list = true
opt.listchars = { tab = "▸ ", trail = "·" }
opt.number = true
opt.showbreak = "\\"
opt.showmatch = true
opt.smartcase = true
opt.visualbell = true
opt.wildignore:append({
  "*/.git/*",
  "*/.hg/*",
  "*/.svn/*",
  "tags",
  ".*.un~",
  "*.pyc",
  "*/tmp/*",
  "node_modules",
  "bower_components",
})
opt.wildmenu = true
opt.wildmode = { "longest", "list", "full" }
opt.whichwrap = "b,s,<,>,h,l,[,]"

-- Use the system clipboard for the unnamed register, as in the Vim config.
opt.clipboard = "unnamed"
opt.completeopt = { "menu", "menuone", "noselect" }

-- A small built-in statusline replacement for the old Fugitive statusline.
opt.statusline = "%<%f %h%m%r%=%-14.(%l,%c%V%) %P"

-- Fast fuzzy file finding. Neovim 0.12's built-in package manager installs
-- fff.nvim and downloads its native search binary on first install/update.
vim.g.fff = {
  lazy_sync = true,
  keymaps = {
    close = { "<Esc>", "<C-c>" },
  },
}
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "fff.nvim" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("fff.nvim")
      end
      require("fff.download").download_or_build_binary()
    end
  end,
})
vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" })

-- Use a floating fuzzy picker for vim.ui.select(), including LSP code actions.
vim.pack.add({ "https://github.com/folke/snacks.nvim" })
require("snacks").setup({
  picker = {
    enabled = true,
    ui_select = true,
  },
})

-- LSP servers and completion. Mason installs the server executables, while
-- nvim-lspconfig provides their Neovim 0.12 configurations.
vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
})

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, item)
      local completion = entry.completion_item
      local label_details = completion.labelDetails or {}
      local source = label_details.description or completion.detail

      -- ts_ls puts the module path for an auto-import completion here.
      -- Showing it alongside the kind makes similarly named exports useful.
      if entry.source.name == "nvim_lsp" and source and source ~= "" then
        item.menu = "  " .. source:gsub("\n.*", "")
      end
      return item
    end,
  },
})

-- Advertise nvim-cmp's richer completion support to every LSP server.
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- TypeScript's completion items carry the additional edit which inserts an
-- import. Confirming an auto-import candidate in nvim-cmp applies both edits.
vim.lsp.config("ts_ls", {
  init_options = {
    hostInfo = "neovim",
    preferences = {
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      includePackageJsonAutoImports = "auto",
      importModuleSpecifierPreference = "shortest",
    },
  },
})

vim.diagnostic.config({
  severity_sort = true,
  virtual_text = true,
  update_in_insert = false,
  float = { border = "rounded", source = true },
})

-- Keep this available in every buffer with diagnostics. `gh` normally enters
-- Select mode, so override it with the diagnostic float.
vim.keymap.set("n", "gh", vim.diagnostic.open_float, {
  silent = true,
  desc = "Line diagnostics",
})
vim.keymap.set("n", "<C-.>", function()
  vim.lsp.buf.code_action({
    filter = function(_, client_id)
      local client = vim.lsp.get_client_by_id(client_id)
      return client ~= nil and client.name == "oxlint"
    end,
  })
end, {
  silent = true,
  desc = "Oxlint code actions",
})

local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "LSP definition")
    map("gD", vim.lsp.buf.declaration, "LSP declaration")
    map("K", vim.lsp.buf.hover, "LSP hover")
    map("<leader>rn", vim.lsp.buf.rename, "LSP rename")
    map("<leader>ca", vim.lsp.buf.code_action, "LSP code action")
    map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
  end,
})

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "ts_ls", "lua_ls" },
  automatic_enable = true,
})

-- Oxlint is installed from npm (prefer a project's local devDependency), not
-- through Mason. nvim-lspconfig supplies its `oxlint --lsp` configuration.
vim.lsp.config("oxlint", {
  settings = {
    -- Avoid rerunning the linter on every keystroke and flashing diagnostics.
    run = "onSave",
    -- Include safe suggestions in the LSP code-action menu.
    fixKind = "safe_fix_or_suggestion",
  },
})
vim.lsp.enable("oxlint")

-- Format buffers on save. Formatter-specific rules are read from each
-- project's normal config files (pyproject.toml, .prettierrc, biome.json, etc.).
vim.pack.add({ "https://github.com/stevearc/conform.nvim" })
local conform = require("conform")

local function project_has(bufnr, files)
  local root = vim.fs.root(bufnr, { ".git", "package.json" })
  if not root then
    return false
  end

  for _, file in ipairs(files) do
    if vim.uv.fs_stat(root .. "/" .. file) then
      return true
    end
  end
  return false
end

local function project_declares_package(bufnr, name)
  local root = vim.fs.root(bufnr, { ".git", "package.json" })
  if not root then
    return false
  end

  local file = io.open(root .. "/package.json", "r")
  if not file then
    return false
  end
  local contents = file:read("*a")
  file:close()

  local ok, package = pcall(vim.json.decode, contents)
  if not ok or type(package) ~= "table" then
    return false
  end

  for _, section in ipairs({ "dependencies", "devDependencies", "optionalDependencies" }) do
    if package[section] and package[section][name] then
      return true
    end
  end
  return false
end

local function javascript_formatters(bufnr)
  -- Prefer a formatter the project explicitly opts into. Conform's oxfmt
  -- definition resolves the executable from the project's node_modules.
  if project_has(bufnr, {
    ".oxfmtrc.json",
    ".oxfmtrc.jsonc",
    "oxfmt.config.ts",
  }) or project_declares_package(bufnr, "oxfmt") then
    return { "oxfmt" }
  end
  if project_has(bufnr, { "biome.json", "biome.jsonc" }) then
    return { "biome" }
  end
  return { "prettierd", "prettier", stop_after_first = true }
end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format", "black", stop_after_first = true },
    javascript = javascript_formatters,
    javascriptreact = javascript_formatters,
    typescript = javascript_formatters,
    typescriptreact = javascript_formatters,
    json = javascript_formatters,
    jsonc = javascript_formatters,
    css = javascript_formatters,
  },
  format_on_save = {
    timeout_ms = 2000,
    lsp_format = "fallback",
  },
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- Show added, changed, and deleted lines in the sign column.
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
vim.opt.signcolumn = "yes"
require("gitsigns").setup({
  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  numhl = false,
  linehl = false,
  word_diff = false,
  current_line_blame = false,
})

vim.keymap.set("n", "]]", function()
  require("gitsigns").nav_hunk("next")
end, { desc = "Next Git change" })
vim.keymap.set("n", "[[", function()
  require("gitsigns").nav_hunk("prev")
end, { desc = "Previous Git change" })

-- `ff` opens the current repository's fuzzy file picker.
vim.keymap.set("n", "ff", function()
  require("fff").find_files()
end, { desc = "Find files" })

-- Search file contents across the current repository. In the picker,
-- Shift-Tab cycles between plain, regex, and fuzzy matching. The leader alias
-- avoids `f`'s built-in find-character command intercepting a slow `fs`.
local function search_repository()
  require("fff").live_grep()
end
vim.keymap.set("n", "fs", search_repository, {
  nowait = true,
  desc = "Search repository contents",
})
vim.keymap.set("n", "<leader>fs", search_repository, {
  desc = "Search repository contents",
})

-- `git:modified` is an FFF query constraint. It includes worktree/index
-- modifications, staged additions, untracked files, and renames.
vim.keymap.set("n", "fg", function()
  require("fff").refresh_git_status()
  require("fff").find_files({ query = "git:modified " })
end, { desc = "Find changed files" })

-- Keep movement over wrapped display lines while preserving counts.
vim.keymap.set({ "n", "x" }, "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true })

vim.keymap.set("n", "<C-n>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<C-p>", ":bprevious<CR>", { silent = true })
vim.keymap.set({ "n", "i", "x" }, "<C-s>", "<Cmd>update<CR>", {
  silent = true,
  desc = "Save file",
})
vim.keymap.set({ "i", "n" }, "<C-c>", "<Esc>", { silent = true })
vim.keymap.set("n", "<leader>y", function()
  vim.fn.setreg("+", vim.fn.expand("%:~") .. ":" .. vim.fn.line("."))
end, { silent = true, desc = "Copy file and line" })

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

local filetype_group = vim.api.nvim_create_augroup("UserFiletypeOptions", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = "css",
  callback = function()
    vim.opt_local.iskeyword:append("-")
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = "htmlcheetah",
  command = "setlocal ft=html",
})
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = "javascript",
  callback = function()
    vim.opt_local.iskeyword:append("$")
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = { "xml", "xsd", "xslt" },
  callback = function()
    vim.opt_local.tabstop = 2
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = filetype_group,
  pattern = "ruby",
  callback = function()
    vim.opt_local.textwidth = 79
    vim.opt_local.comments = ":# "
    vim.opt_local.isfname:append(":")
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
