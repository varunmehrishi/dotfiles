### History & Zsh Options ###
setopt HIST_IGNORE_DUPS SHARE_HISTORY EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS
setopt NO_HUP AUTO_CD

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000

### Resource Limits ###
if (( $(ulimit -n) < 8192 )); then
  ulimit -n 8192 2>/dev/null || true
fi

### Locale ###
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8

### Paths (set early, with deduplication) ###
typeset -U PATH path
export PATH="$HOME/Utils:$HOME/.scripts:$HOME/.local/bin:/opt/homebrew/opt/mysql-client/bin:/opt/homebrew/opt/libpq/bin:$PATH"

### Zinit Setup ###
_zinit_home="${ZINIT_HOME:-$HOME/.zinit/bin}"
if [[ ! -f "$_zinit_home/zinit.zsh" ]] && (( $+commands[git] )); then
  mkdir -p "${_zinit_home:h}"
  git clone --depth=1 https://github.com/zdharma-continuum/zinit "$_zinit_home" ||
    print -u2 'zinit bootstrap failed; continuing without plugins'
fi
if [[ -r "$_zinit_home/zinit.zsh" ]]; then
  source "$_zinit_home/zinit.zsh"

  zinit wait lucid light-mode for \
    zsh-users/zsh-autosuggestions \
    Aloxaf/fzf-tab
  zinit ice wait lucid
  zinit snippet OMZL::directories.zsh
  zinit ice wait lucid
  zinit snippet OMZP::sudo
  zinit ice wait lucid pick"plugins/git/git.plugin.zsh"
  zinit light ohmyzsh/ohmyzsh
  # syntax-highlighting must be last; compinit runs here via zicompinit.
  zinit ice wait lucid atinit"zicompinit; zicdreplay"
  zinit light zsh-users/zsh-syntax-highlighting
else
  autoload -Uz compinit
  compinit
fi
unset _zinit_home

### Tool Inits ###
if (( $+commands[zoxide] )); then
  unalias zi 2>/dev/null
  eval "$(zoxide init zsh)"
fi

# Initialize fnm once, on the first Node command, without running `fnm`
# with no arguments or swallowing initialization errors.
if (( $+commands[fnm] )); then
  _load_fnm() {
    local fnm_env
    fnm_env="$(command fnm env --shell=zsh)" || return
    eval "$fnm_env" || return
    unfunction fnm node npm npx _load_fnm
  }
  fnm() { _load_fnm && command fnm "$@"; }
  node() { _load_fnm && command node "$@"; }
  npm() { _load_fnm && command npm "$@"; }
  npx() { _load_fnm && command npx "$@"; }
fi

(( $+commands[starship] )) && eval "$(starship init zsh)"

# Use current fzf integration, with the older installation as a fallback.
if (( $+commands[fzf] )); then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  elif [[ -r "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
  fi
fi
(( $+commands[atuin] )) && eval "$(atuin init zsh)"

if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
  sdk() {
    unfunction sdk
    export SDKMAN_DIR="$HOME/.sdkman"
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk "$@"
  }
fi

# pnpm's standalone installer uses this location on macOS.
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
[[ -d "$PNPM_HOME/bin" ]] && path=("$PNPM_HOME/bin" $path)

# Quick AWS profile switch
awsp() { export AWS_PROFILE="${1:-}"; echo "AWS_PROFILE=${AWS_PROFILE:-<unset>}"; }

### Editor ###
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim +Man!'
export MANWIDTH=999
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^X^E' edit-command-line

### Partial history search with arrow keys ###
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

### Aliases ###
alias q='exit'
alias tunnel='ssh -L 2009:localhost:2009 clouddesk -f -N'
alias ddk='mosh clouddesk -- zsh -c "tmux attach -t cloud || tmux new -s cloud"'
if (( $+commands[delta] )); then
  alias gd='git -c core.pager=delta diff'
else
  alias gd='git diff'
fi
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'
if (( $+commands[eza] )); then
  alias ls='eza' ll='eza -l' la='eza -al'
else
  alias ll='ls -l' la='ls -al'
fi
(( $+commands[bat] )) && alias cat='bat'
alias socks_tunnel='ssh -N -C -D 1080 clouddesk'

# Suffix aliases
alias -s {ape,avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,ogm,wav,webm}=mpv
alias -s {csv,tsv,psv,xlsx}=vd

# Global aliases
alias -g C='| pbcopy'
alias -g F='| fzf'
alias -g G='| grep'
alias -g H='| head'
alias -g J='| jq'
alias -g L='| less'
alias -g R='| rg'
alias -g T='| tail'
alias -g V='| vim -'
alias -g X='| xargs'

### Custom Keybind ###
(( $+widgets[fzf-cd-widget] )) && bindkey "ç" fzf-cd-widget

# Machine-specific functions and private settings belong outside the repo.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
true
