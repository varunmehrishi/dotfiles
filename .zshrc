### History & Zsh Options ###
setopt HIST_IGNORE_DUPS SHARE_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS
setopt NO_HUP AUTO_CD

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000

### Locale ###
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8

### Paths (set early, with deduplication) ###
typeset -U PATH path
export PATH="$HOME/Utils:$HOME/.scripts:$HOME/.local/bin:/opt/homebrew/opt/mysql-client/bin:/opt/homebrew/opt/libpq/bin:$PATH"

### Zinit Setup ###
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
  mkdir -p ~/.zinit && git clone https://github.com/zdharma-continuum/zinit ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

### Plugin Load (turbo mode for async loading) ###
zinit wait lucid light-mode for \
  zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab

zinit ice wait lucid
zinit snippet OMZL::directories.zsh

zinit ice wait lucid
zinit snippet OMZP::sudo

zinit ice wait lucid pick"plugins/git/git.plugin.zsh"
zinit light ohmyzsh/ohmyzsh

# syntax-highlighting must be last, compinit runs here via zicompinit
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zsh-users/zsh-syntax-highlighting

### Tool Inits ###

# zoxide (cached init, unalias zinit's zi for zoxide's interactive mode)
unalias zi 2>/dev/null
_zoxide_cache="$HOME/.cache/zoxide-init.zsh"
if [[ ! -f "$_zoxide_cache" || "$(whence -p zoxide)" -nt "$_zoxide_cache" ]]; then
  mkdir -p "${_zoxide_cache:h}"
  zoxide init zsh > "$_zoxide_cache"
fi
source "$_zoxide_cache"
unset _zoxide_cache

# fnm - Node version manager (lazy loaded with node/npm/npx shims)
fnm() {
  unfunction fnm node npm npx 2>/dev/null
  eval "$(command fnm env --shell=zsh)"
  fnm "$@"
}
node() { unfunction node; fnm; command node "$@"; }
npm() { unfunction npm; fnm; command npm "$@"; }
npx() { unfunction npx; fnm; command npx "$@"; }

# Starship prompt (not lazy - needed immediately)
eval "$(starship init zsh)"

# Load fzf key bindings and completion
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# SDKMAN lazy loader
sdk() {
  unfunction sdk
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  sdk "$@"
}

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
alias gd='git delta'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vimdiff='nvim -d'
alias ls='eza'
alias ll='eza -l'
alias la='eza -al'
alias cat='bat'
alias socks_tunnel='ssh -N -C -D 1080 clouddesk'

# Suffix aliases
alias -s {ape,avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,ogm,wav,webm}=mpv
alias -s {csv,tsv,psv,xslx}=vd

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
bindkey "ç" fzf-cd-widget
