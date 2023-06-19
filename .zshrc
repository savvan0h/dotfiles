alias vim='nvim'
alias view='nvim -R'

alias gp='cd "$(ghq list --full-path | peco)" && clear && pwd'
alias bp='git checkout $(git branch | tr -d " " | tr -d "*" | peco)'
alias ca='conda activate $(conda env list | grep -v ^# | cut -d" " -f1 | peco)'
alias kzf='kustomize build | yq e "select(.metadata.name == \"$(kustomize build | yq -N e .metadata.name - | sort | uniq | peco)\")" -'
alias kzfns='kustomize build | yq e "select(.metadata.namespace == \"$(kustomize build | yq -N e .metadata.namespace - | sort | uniq | peco)\")" -'

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups

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
alias ls='exa -la -s modified --time-style long-iso'
alias cat='bat'
alias git-root='cd $(git rev-parse --show-cdup)'

export LANG=en_US.UTF-8
