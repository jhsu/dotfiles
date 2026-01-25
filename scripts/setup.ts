#!/usr/bin/env bun

import { $ } from "bun";
import { existsSync, lstatSync, mkdirSync, readFileSync, symlinkSync, unlinkSync, appendFileSync } from "fs";
import { homedir } from "os";
import { join, resolve } from "path";

const CONFIG_DIR = resolve(import.meta.dir, "..");
const HOME = homedir();

const FILES_TO_LINK = ["bashrc", "gitconfig"];

// Directories to symlink into ~/.config/
const CONFIG_DIRS_TO_LINK = ["niri", "noctalia"];

const HOMEBREW_PACKAGES = ["vim", "postgresql", "weechat", "ffmpeg", "imagemagick"];

let DRY_RUN = false;

function log(msg: string) {
  console.log(`- ${msg}`);
}

function dryLog(msg: string) {
  console.log(`  [dry-run] would ${msg}`);
}

function linkFile(file: string) {
  const source = join(CONFIG_DIR, file);
  const target = join(HOME, `.${file}`);

  if (!existsSync(source)) {
    log(`source ${file} does not exist, skipping`);
    return;
  }

  if (existsSync(target)) {
    const stats = lstatSync(target);
    if (stats.isSymbolicLink()) {
      log(`~/.${file} symlink already exists, skipping`);
      return;
    }
    log(`~/.${file} exists and is not a symlink, skipping (backup manually if needed)`);
    return;
  }

  if (DRY_RUN) {
    dryLog(`link ~/.${file} -> ${source}`);
    return;
  }

  symlinkSync(source, target);
  log(`linked ~/.${file}`);
}

function linkConfigDir(dir: string) {
  const source = join(CONFIG_DIR, dir);
  const configHome = join(HOME, ".config");
  const target = join(configHome, dir);

  if (!existsSync(source)) {
    log(`source ${dir} does not exist, skipping`);
    return;
  }

  // Ensure ~/.config exists
  if (!existsSync(configHome)) {
    if (DRY_RUN) {
      dryLog(`create ~/.config`);
    } else {
      mkdirSync(configHome, { recursive: true });
      log(`created ~/.config`);
    }
  }

  if (existsSync(target)) {
    const stats = lstatSync(target);
    if (stats.isSymbolicLink()) {
      log(`~/.config/${dir} symlink already exists, skipping`);
      return;
    }
    log(`~/.config/${dir} exists and is not a symlink, skipping (backup manually if needed)`);
    return;
  }

  if (DRY_RUN) {
    dryLog(`link ~/.config/${dir} -> ${source}`);
    return;
  }

  symlinkSync(source, target);
  log(`linked ~/.config/${dir}`);
}

async function setupSymlinks() {
  console.log("\n📁 Setting up symlinks...\n");
  for (const file of FILES_TO_LINK) {
    linkFile(file);
  }
  for (const dir of CONFIG_DIRS_TO_LINK) {
    linkConfigDir(dir);
  }
}



async function setupOsx() {
  console.log("\n🍺 Installing Homebrew packages...\n");

  const isMac = process.platform === "darwin";
  if (!isMac) {
    log("skipping Homebrew setup (not macOS)");
    return;
  }

  for (const pkg of HOMEBREW_PACKAGES) {
    if (DRY_RUN) {
      dryLog(`install ${pkg}`);
    } else {
      log(`installing ${pkg}...`);
      await $`brew install ${pkg}`.quiet();
    }
  }
  if (!DRY_RUN) {
    log("Homebrew packages installed");
  }
}

async function setupSourceRc() {
  console.log("\n📝 Setting up rc file sourcing...\n");

  const rcMappings: Record<string, string> = {
    vimrc: join(HOME, ".vimrc"),
  };

  for (const [file, rcFile] of Object.entries(rcMappings)) {
    if (!existsSync(rcFile)) {
      log(`${rcFile} does not exist, skipping`);
      continue;
    }

    const configLine = `source ${CONFIG_DIR}/${file}`;
    const content = readFileSync(rcFile, "utf-8");

    if (content.includes(configLine)) {
      log(`${rcFile} already sources ${file}`);
      continue;
    }

    if (DRY_RUN) {
      dryLog(`append "source ${CONFIG_DIR}/${file}" to ${rcFile}`);
      continue;
    }

    appendFileSync(rcFile, `\n${configLine}\n`);
    log(`added source line to ${rcFile}`);
  }
}

function printUsage() {
  console.log(`
Usage: bun scripts/setup.ts [task] [options]

Tasks:
  (none)      Run all setup tasks
  symlink     Create symlinks for config files
  osx         Install Homebrew packages (macOS only)
  source-rc   Source rc files into existing configs

Options:
  --dry       Show what would be done without making changes

Examples:
  bun scripts/setup.ts
  bun scripts/setup.ts --dry
  bun scripts/setup.ts symlink
  bun scripts/setup.ts symlink --dry
`);
}

async function runAll() {
  await setupOsx();
  await setupSourceRc();
  await setupSymlinks();
  console.log("\n Setup complete!\n");
}

// Main
const args = process.argv.slice(2);
DRY_RUN = args.includes("--dry");
const showHelp = args.includes("--help") || args.includes("-h") || args.includes("help");
const task = args.find(arg => !arg.startsWith("-") && arg !== "help");

if (showHelp) {
  printUsage();
  process.exit(0);
}

if (DRY_RUN) {
  console.log("Running in dry-run mode (no changes will be made)\n");
}

switch (task) {
  case "symlink":
    await setupSymlinks();
    break;
  case "osx":
    await setupOsx();
    break;
  case "source-rc":
    await setupSourceRc();
    break;
  case undefined:
    await runAll();
    break;
  default:
    console.error(`Unknown task: ${task}`);
    printUsage();
    process.exit(1);
}
