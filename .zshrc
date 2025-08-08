### History & Zsh Options ###
setopt HIST_IGNORE_DUPS SHARE_HISTORY INC_APPEND_HISTORY EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_SAVE_NO_DUPS
setopt NO_HUP

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000000
export SAVEHIST=10000000

### Locale ###
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8

### Zinit Setup ###
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
  mkdir -p ~/.zinit && git clone https://github.com/zdharma-continuum/zinit ~/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

## Plugin Load ###
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
zinit ice pick"plugins/git/git.plugin.zsh"
zinit light ohmyzsh/ohmyzsh

### Tool Inits ###
eval "$(zoxide init zsh)"

# fnm (Node version manager)
zinit ice wait'1' lucid
zinit light Schniz/fnm
eval "$(fnm env --shell=zsh)"


# Starship prompt
zinit ice wait'0' lucid
zinit light starship/starship
eval "$(starship init zsh)"


# Load fzf key bindings and completion
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh


# SDKMAN lazy loader
sdk_lazy() {
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
  unset -f sdk_lazy
}
alias sdk=sdk_lazy

awsuse() {
  local profile="$1"
  [[ -z "$profile" ]] && { echo "usage: awsuse <profile>" >&2; return 1 }

  # fetch the JSON block (requires AWS CLI v2.10+ and jq)
  local json
  if ! json=$(ada credentials print --profile="$profile" 2>/dev/null); then
    echo "awsuse: could not obtain creds for '$profile'" >&2
    return 1
  fi

  # export the three SigV4 vars (+ profile & region for convenience)
  export AWS_ACCESS_KEY_ID=$(jq -r '.AccessKeyId'      <<<"$json")
  export AWS_SECRET_ACCESS_KEY=$(jq -r '.SecretAccessKey' <<<"$json")
  export AWS_SESSION_TOKEN=$(jq -r '.SessionToken'     <<<"$json")
  export AWS_PROFILE="$profile"
  # export AWS_REGION=$(aws configure get region --profile "$profile" 2>/dev/null)

  echo "awsuse: now using '$profile'  (expires $(jq -r '.Expiration' <<<"$json"))"
}

### Paths ###
export PATH="$HOME/Utils:$HOME/.scripts:$HOME/.toolbox/bin:$HOME/.local/bin:/opt/homebrew/opt/mysql-client/bin:/opt/homebrew/opt/libpq/bin:$PATH"

### Editor ###
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim +Man!'
export MANWIDTH=999
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^X^E' edit-command-line


### Completions ###
autoload -Uz compinit && compinit -C

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
# alias mcurl=curl -L --cookie-jar ~/.midway/cookie --cookie ~/.midway/cookie

# Suffix aliases
alias -s {ape,avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,ogm,wav,webm}=mpv
alias -s {csv,tsv,psv,xslx}=vd

# Global aliases
alias -g C='| pbcopy'
alias -g F='| fzf'
alias -g G='| grep'
alias -g L='| less'
alias -g R='| rg'
alias -g V='| vim -'

### Custom Keybind ###
bindkey "ç" fzf-cd-widget
