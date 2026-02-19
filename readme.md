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
- **UI**: lualine, which-key, fidget, dressing, snacks
- **Editing**: vim-surround, vim-exchange, Comment.nvim, targets.vim, TreeSJ
- **Utilities**: toggleterm, grug-far (find/replace), undotree, venn.nvim, vim-table-mode

### Tmux (`.tmux.conf`)

- Prefix: `Ctrl-a`
- Vi-mode copy with system clipboard integration
- `hjkl` pane navigation, `Alt+1-9` window switching
- Plugins (via tpm): tmux-sensible, tmux-yank, tmux-fzf, tmux-fzf-url
- Dracula theme with CPU/RAM widgets

### Ghostty (`.config/ghostty/`)

- Dracula theme, FiraCode Nerd Font (size 20)
- Auto-attaches to a tmux session on launch
- Option-as-Alt, hidden titlebar

### Vim (`.vimrc`)

Legacy Vim configuration kept for reference.

### Rectangle (`RectangleConfig.json`)

Window snapping utility configuration for macOS.

### Vifm (`.vifm/`)

Vi-like file manager configuration.

## External Dependencies

These tools are expected to be installed (e.g., via Homebrew):

`neovim` `tmux` `ghostty` `fzf` `ripgrep` `eza` `bat` `starship` `atuin` `zoxide` `fnm` `jq` `delta`

## Setup

1. Clone the repo
2. Symlink or copy files to their expected locations (`~`, `~/.config/`, etc.)
3. Plugin managers bootstrap themselves on first run:
   - **Neovim**: lazy.nvim auto-installs plugins; Mason auto-installs LSP servers
   - **Zsh**: zinit auto-installs plugins on first shell start
   - **Tmux**: run `<prefix> I` to install tpm plugins
