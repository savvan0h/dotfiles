alias vim='nvim'
alias view='nvim -R'

alias gp='cd "$(ghq list --full-path | peco)" && clear && pwd'
alias bp='git checkout $(git branch | tr -d " " | tr -d "*" | peco)'

peco-select-history() {
    declare l=$(HISTTIMEFORMAT= history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-r": peco-select-history'
