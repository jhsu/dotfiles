# Dotfiles

Make anyplace feel like :house:.

## Setup

```bash
# Run full setup (Homebrew packages, rc sourcing, symlinks)
bun scripts/setup.ts

# Or run individual tasks
bun scripts/setup.ts symlink     # Create symlinks for config files
bun scripts/setup.ts osx         # Install Homebrew packages (macOS only)
bun scripts/setup.ts source-rc   # Source rc files into existing configs
```
