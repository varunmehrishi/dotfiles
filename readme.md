# dotfiles

macOS-focused, keyboard-driven development environment with a consistent Dracula theme.

## What's Included

### Zsh (`.zshrc`)

- [zinit](https://github.com/zdharma-continuum/zinit) plugin manager with turbo-mode async loading
- Plugins: zsh-autosuggestions, fzf-tab, zsh-syntax-highlighting, oh-my-zsh git
- [starship](https://starship.rs/) prompt
- [atuin](https://atuin.sh/) shell history (replaces Ctrl-r)
- [zoxide](https://github.com/ajeetdsouza/zoxide) for directory jumping
- [fnm](https://github.com/Schniz/fnm) for Node version management (lazy-loaded)
- [SDKMAN](https://sdkman.io/) for Java SDK management (lazy-loaded)
- Modern CLI replacements: [eza](https://github.com/eza-community/eza) (ls), [bat](https://github.com/sharkdp/bat) (cat)
- Global pipe aliases: `C` (pbcopy), `F` (fzf), `G` (grep), `J` (jq), `L` (less), `R` (rg), `H` (head), `T` (tail)
- Missing optional tools are skipped; `ls` and `cat` retain their system defaults when replacements are unavailable
- Machine-specific functions and private settings load from `~/.zshrc.local`

### Neovim (`.config/nvim/`)

Modular Lua configuration using [lazy.nvim](https://github.com/folke/lazy.nvim).

**LSP** (via Mason + lspconfig): Rust (rustaceanvim), Java (nvim-jdtls with Bemol/Lombok), Python (pyright), TypeScript, Lua, C/C++ (clangd), JSON, YAML, Bash, HTML, CSS

**Key plugins:**

- **Completion**: nvim-cmp, LuaSnip, lspkind
- **Navigation**: Telescope (fzf-native, file-browser, ui-select, undo), Leap.nvim
- **Formatting/Linting**: conform.nvim, nvim-lint
- **Git**: fugitive, gitsigns
- **Debugging**: nvim-dap + dap-ui
- **File explorer**: Oil.nvim
- **UI**: lualine, which-key, fidget, dressing
- **Editing**: vim-surround, vim-exchange, Comment.nvim, targets.vim, TreeSJ
- **Utilities**: toggleterm, grug-far (find/replace), undotree, venn.nvim, vim-table-mode

**Development workflows:**

- Firenvim uses manual browser activation and leaves complex editors such as Quip and Google Docs/Sheets/Slides alone
- `:FRust`, `<leader>rf`, or `<leader>xr` creates a temporary Cargo-backed Rust buffer with the LeetCode `Solution` helper
- `:FPython` / `<leader>xp` creates a Pyright-backed Python scratch buffer
- `<leader>xx` runs the current file; `<leader>xn`, `<leader>xf`, and `<leader>xa` run the nearest, current-file, or complete test suite
- Python nearest-test selection includes the enclosing class; all-project tests save modified files before running
- Project roots use the nearest supported manifest, including `requirements.txt`, so nested packages run in their own directory
- `<leader>xc` selects Cargo, Python, or npm project tasks; `<leader>xl` repeats the last task
- `<F5>`, `<F10>`, `<F11>`, and `<F12>` control debugging; additional actions are under `<leader>D`
- Project sessions save automatically; `<leader>ws`, `<leader>wo`, and `<leader>wp` save, load, or switch sessions
- Normal completion hides standalone snippets; press `<C-k>` in Insert mode to request snippet/postfix completions for one invocation
- `:ConfigHealth` (`<leader>ch`) checks language tools, debugger adapters, Firenvim, and the Chrome native-messaging manifest
- Files larger than 1.5 MiB skip automatic formatting, linting, completion, and Treesitter highlighting/indentation
- Undo history uses Neovim's state directory and also reads existing `~/.undodir` history

Treesitter and its textobjects plugin explicitly use their `master` branches to match this configuration's `nvim-treesitter.configs` API. Other plugin versions remain recorded in `lazy-lock.json`. Formatting uses Conform's documented [`lsp_format = "fallback"`](https://github.com/stevearc/conform.nvim) API.

Surfingkeys configuration is tracked in `.config/surfingkeys/config.js`. It uses Chrome's native PDF viewer and enters lurking mode on Quip and Google productivity editors.

### Tmux (`.tmux.conf`)

- Prefix: `Ctrl-a`
- Vi-mode copy with system clipboard integration
- `hjkl` pane navigation, `Alt+1-9` window switching
- Plugins (via tpm): tmux-sensible, tmux-yank, tmux-fzf, tmux-fzf-url
- Dracula theme with CPU/RAM widgets

### Ghostty (`.config/ghostty/`)

- Shared config for the M1 and M5 MacBook Pros; Ghostty manages rendering without chip-specific overrides
- Dracula theme, FiraCode Nerd Font Mono (size 20, Retina weight), balanced window padding
- First terminal attaches to or creates the `mac` tmux session; later tabs/windows open a login shell
- Opens a normal Zsh shell when tmux is unavailable, including on a fresh Mac
- Remembers window size/layout on each device; Option-as-Alt, hidden titlebar

On each Mac, install the same font with `brew install --cask font-fira-code-nerd-font` ([Homebrew cask](https://formulae.brew.sh/cask/font-fira-code-nerd-font)). The shared config uses [Ghostty's window state and optional config-file settings](https://ghostty.org/docs/config/reference#window-save-state).

For device-specific font sizes or appearance, create `.config/ghostty/config.local` in that Mac's clone (also available through the `~/.config/ghostty` symlink). This file is ignored by Git and loaded after the shared settings:

```ini
# Example: smaller text on one device's display.
font-size = 18
```

Reload with `Cmd+Shift+,`. Restart Ghostty for launch-command and window-restoration changes. Install the dotfiles independently on both devices; tmux sessions and saved window layouts stay local to each Mac.

### Vim (`.vimrc`)

Legacy Vim configuration kept for reference.

### Rectangle (`RectangleConfig.json`)

Window snapping utility configuration for macOS.

### Logi Options+ (`logi-options-plus/`)

On this Mac, run `python3 logi-options-plus/sync.py backup` to refresh the tracked settings. On another Mac, install and open Logi Options+ once, quit it and its agent, then run `python3 logi-options-plus/sync.py restore` from the cloned repo. Reopen Logi Options+ afterward. Restore requires the same settings schema version and saves the previous database as `settings.pre-restore.db`.

### Vifm (`.vifm/`)

Vi-like file manager configuration.

## External Dependencies

Use Python 3.11+ for the installation/check script and Neovim 0.11+ for the editor configuration. These tools are expected to be installed (e.g., via Homebrew):

`neovim` `tmux` `ghostty` `fzf` `ripgrep` `eza` `bat` `starship` `atuin` `zoxide` `fnm` `jq` `delta`

## Setup

1. Clone the repo
2. Preview and install the managed symlinks:

   ```sh
   python3 scripts/dotfiles.py install --dry-run
   python3 scripts/dotfiles.py install
   ```

   Existing files are refused before making changes. Use `--backup` to move conflicting files/directories to timestamped backups beside their original paths. `--dry-run --backup` previews that plan. Installation is safe to repeat and honors `XDG_CONFIG_HOME`; `--home` and `--config-home` can target another location. Preserve local additions in `~/.zshrc.local` before replacing an existing shell configuration.

3. Plugin managers bootstrap themselves on first run:
   - **Neovim**: lazy.nvim auto-installs plugins; Mason auto-installs LSP servers
   - **Zsh**: zinit auto-installs plugins on first shell start
   - **Tmux**: install TPM with `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`, then run `<prefix> I` to install plugins
4. For browser editing, install the Firenvim and Surfingkeys Chrome extensions. Firenvim's Neovim plugin installs its native-messaging host; verify it with `:ConfigHealth`.
5. Paste `.config/surfingkeys/config.js` into Surfingkeys' advanced settings.

The installer manages Zsh, tmux, Vifm, Neovim, Ghostty, and Starship. Legacy Vim/YCM, Yabai/Skhd, Rectangle, browser settings, and Logi Options+ exports are kept for manual setup. Skhd uses `ctrl+cmd+alt+x` for the recent desktop and `shift+alt+x` for mirroring, avoiding conflicts with window focus/swap shortcuts. The Yabai configuration targets an older release; review it before enabling that service.

## Verification

```sh
python3 -m unittest discover -s tests -v
python3 scripts/dotfiles.py check
```

The tests cover conflict detection, backup preservation, repeat installation, dry runs, missing shell tools, and fnm initialization/failure recovery. The check command validates JSON/TOML/Python/Zsh/Lua syntax, starts Neovim, runs editor behavior checks, validates Ghostty when installed, and sources tmux settings in a separate server with a temporary home. Neovim behavior checks require installed plugins and the Python Treesitter parser. Startup can bootstrap missing plugins/Mason tools. Browser extensions and desktop interactions still need a manual check in their applications.
