setopt no_beep

# Plugins
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias vim='nvim'
alias view='nvim -R'

# Avoid using slow ghq list
# See: https://github.com/x-motemen/ghq/issues/323
alias gp='cd "$(find $(ghq root) -maxdepth 4 -type d -name .git | xargs -n1 dirname | peco)" && clear && pwd'
alias bp='git checkout $(git branch | tr -d " " | tr -d "*" | peco)'
alias ca='conda activate $(conda env list | grep -v ^# | cut -d" " -f1 | peco)'
alias kc='kubectx | peco | xargs kubectx'
alias kzf='kustomize build | yq e "select(.metadata.name == \"$(kustomize build | yq -N e .metadata.name - | sort | uniq | peco)\")" -'
alias kzfns='kustomize build | yq e "select(.metadata.namespace == \"$(kustomize build | yq -N e .metadata.namespace - | sort | uniq | peco)\")" -'

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history

function peco-select-history() {
  BUFFER=$(history -n 1 | tail -r | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function peco-ssh() {
  local selected_host=$(awk '
  tolower($1)=="host" {
    for (i=2; i<=NF; i++) {
      if ($i !~ "[*?]") {
        print $i
      }
    }
  }
  ' ~/.ssh/config | sort | peco --query "$LBUFFER")
  if [ -n "$selected_host" ]; then
    ssh ${selected_host}
  fi
}
alias s='peco-ssh'

eval "$(starship init zsh)"
alias ls='eza -la -s modified --time-style long-iso'
alias cat='bat'
alias git-root='cd $(git rev-parse --show-cdup)'

export LANG=en_US.UTF-8

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
