
# git（轻量）
alias lg='lazygit'
alias g='git'
#alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate'
alias gf="git fetch"
alias gsb="git status -sb"
alias gls="git rev-list --objects --all | grep -E \"\$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -5 | awk '{print \$1}' | tr '\n' '|' | sed 's/|\$//')\""

