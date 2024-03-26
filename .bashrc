alias vim='nvim'
alias view='nvim -R'

# Avoid using slow ghq list
# See: https://github.com/x-motemen/ghq/issues/323
alias gp='cd "$(find $(ghq root) -maxdepth 4 -type d -name .git | xargs -n1 dirname | peco)" && clear && pwd'

alias bp='git checkout $(git branch | tr -d " " | tr -d "*" | peco)'
alias ca='conda activate $(conda env list | grep -v ^# | cut -d" " -f1 | peco)'
alias kzf='kustomize build | yq e "select(.metadata.name == \"$(kustomize build | yq -N e .metadata.name - | sort | uniq | peco)\")" -'
alias kzfns='kustomize build | yq e "select(.metadata.namespace == \"$(kustomize build | yq -N e .metadata.namespace - | sort | uniq | peco)\")" -'

peco-select-history() {
    declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-r": peco-select-history'

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

eval "$(starship init bash)"
alias ls='exa -la -s modified --time-style long-iso'
alias cat='bat'
alias git-root='cd $(git rev-parse --show-cdup)'

export LANG=en_US.UTF-8

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
