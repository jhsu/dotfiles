# AGENTS.md - Agentic Coding Guidelines

This document provides guidelines for AI coding agents operating in this repository.

## Repository Overview

This is a **personal dotfiles repository** containing configuration files for setting up
a consistent development environment across machines. It belongs to Joe Hsu (@jhsu).

**Key characteristics:**
- Configuration files, not a traditional code project
- Multi-editor support (Vim, Neovim, VS Code, Spacemacs)
- Cross-platform (macOS and Linux)
- Symlink-based installation

## Build/Setup Commands

```bash
# Full setup (macOS Homebrew packages, symlinks)
bun scripts/setup.ts

# Individual setup tasks
bun scripts/setup.ts osx         # Install Homebrew packages (macOS only)
bun scripts/setup.ts source-rc   # Source rc files into existing configs
bun scripts/setup.ts symlink     # Create symlinks for config files
```

### Symlinked Files

Files symlinked to `~/.{filename}`: `bashrc`, `gitconfig`

### Verifying Changes

**No formal test suite exists.** To verify:

```bash
bash -n <script>          # Check shell syntax
luac -p neovim.init.lua   # Check Lua syntax
bun scripts/setup.ts      # Check TypeScript syntax (will fail if errors)
```

## Code Style Guidelines

### General Formatting

- **Indentation:** 2 spaces (consistent across all configurations)
- **Tabs vs Spaces:** Use spaces (`expandtab` is enabled)
- **Trailing whitespace:** Remove trailing whitespace

### Shell Scripts (Bash)

```bash
# Use snake_case for functions and variables
function my_function {
  local my_variable="value"
}

# Conditional checks before operations
if [[ -f $file ]]; then
  process_file "$file"
else
  echo "No file found."
fi

# Platform-specific code using case statements
case `uname` in
Linux)
  alias pbcopy='xsel -b'
;;
Darwin)
  alias ls='ls -FG'
;;
esac
```

### TypeScript (Bun)

```typescript
import { $ } from "bun";
import { existsSync, symlinkSync } from "fs";
import { homedir } from "os";
import { join } from "path";

// Use camelCase for functions and variables
function linkFile(file: string) {
  const target = join(homedir(), `.${file}`);
  if (existsSync(target)) {
    console.log(`~/.${file} already exists, skipping`);
    return;
  }
  symlinkSync(source, target);
}

// Use Bun's shell for commands
await $`brew install ${pkg}`.quiet();
```

### Lua (Neovim)

```lua
-- Use snake_case for functions
local function buf_map(bufnr, mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or { silent = true })
end

-- Use local variables
local lspconfig = require("lspconfig")

-- Set vim options using vim.opt
vim.opt.tabstop = 2
vim.opt.expandtab = true
```

### Vim Script

```vim
" Check for features/executables before using
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor'
endif

if exists('+breakindent')
  set breakindent
endif

" Group autocmds
augroup FTOptions
  autocmd FileType ruby setlocal expandtab tabstop=2
augroup END
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Shell functions | snake_case | `link_file`, `prompt_char` |
| Shell variables | snake_case | `filename`, `CONFIG_DIR` |
| TypeScript funcs | camelCase | `linkFile`, `setupSymlinks` |
| Lua functions | snake_case | `buf_map`, `nmap` |
| Config files | No dot prefix | `bashrc` (not `.bashrc`) |
| Git aliases | Short abbreviations | `st`, `cm`, `br`, `co`, `df` |

## Error Handling Patterns

- **Shell:** Use `if [[ -f $file ]]` checks before file operations
- **TypeScript:** Use `existsSync()` checks before file operations
- **Vim:** Use `if executable()`, `if exists()`, `if file_readable()` guards

## Platform Considerations

- **macOS:** Uses Homebrew for package management, `pbcopy` for clipboard
- **Linux:** Uses native package managers, `xsel -b` for clipboard
- **File listing:** `ls -FG` on macOS, `ls --color=auto` on Linux

## Important Notes for Agents

1. **Preserve personal preferences** - This repo contains user-specific settings
2. **Maintain symlink structure** - Files are named without dots, symlinked with dots
3. **Test platform compatibility** - Check both macOS and Linux when applicable
4. **No CI/CD** - Manual verification required
5. **Minimal documentation** - Keep README.md concise
6. **User-specific paths** - Some configs contain hardcoded paths (e.g., `/Users/jhsu`)
