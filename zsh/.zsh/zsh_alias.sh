
# 设置默认编辑器
if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    export VISUAL="nvim"
    alias v='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR="vim"
    export VISUAL="vim"
    alias v='vim'
fi

# ls 系列（现代化）
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first'
alias la='eza -lha --icons --group-directories-first'
alias tree='eza --tree --icons'

# cd / 路径
alias ..='cd ..'
alias ...='cd ../..'

# cat 替代
alias cat='bat'

# grep / find
# alias grep='rg'
# alias find='fd'

# 编辑
alias v='nvim'
alias vi='nvim'

# mkdir
alias mkd='mkdir -p'

# rm（安全）
alias rm='trash'

# lazysql
alias sql='lazysql'

# 进程
# alias ps='ps aux'
alias ps='ps'
alias top='htop'

