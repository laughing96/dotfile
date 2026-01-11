# ls 系列（现代化）
alias ls 'eza --icons --group-directories-first'
alias ll 'eza -lh --icons --group-directories-first'
alias la 'eza -lha --icons --group-directories-first'
alias tree 'eza --tree --icons'

# cd / 路径
alias .. 'cd ..'
alias ... 'cd ../..'

# cat 替代
alias cat 'bat'

# grep / find
alias grep 'rg'
alias find 'fd'

# 编辑
alias v 'nvim'
alias vi 'nvim'

# mkdir
alias mkd 'mkdir -p'

# rm（安全）
alias rm 'trash'

# git（轻量）
alias lg 'lazygit'
alias g 'git'
alias gs 'git status -sb'
alias gl 'git log --oneline --graph --decorate'

# 进程
alias ps 'ps aux'
alias top 'htop'
