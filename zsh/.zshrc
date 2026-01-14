# PATH env
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/opt/postgresql/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

#In short, Tmuxifier allows you to easily create, edit, and load "layout" files, which are simple shell scripts where you use the tmux command and helper commands provided by tmuxifier to manage Tmux sessions and windows
# eval "$(tmuxifier init -)"
eval "$(zoxide init zsh)"

proxy_ip=127.0.0.1
no_proxy="127.0.0.1,localhost,.localdomain.com"
no_proxy=$no_proxy,${proxy_ip}
export no_proxy

export http_proxy="http://${proxy_ip}:20171"
export https_proxy="http://${proxy_ip}:20171"
export sock_proxy="socks5://${proxy_ip}:20170"

export PYTHON_BUILD_CURL_OPTS=" -x localhost:20171" 
# export ALL_PROXY=" -x localhost:20171"

# 自启动
#
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
## place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc


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

# readline python 编译
export LDFLAGS="-L/opt/homebrew/opt/readline/lib -L/opt/homebrew/opt/sqlite/lib -L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/tcl-tk@8/lib"
export CPPFLAGS="-I/opt/homebrew/opt/readline/include -I/opt/homebrew/opt/sqlite/include -I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/tcl-tk@8/include " 
export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig:/opt/homebrew/opt/sqlite/lib/pkgconfig:/opt/homebrew/opt/zlib/lib/pkgconfig:/opt/homebrew/opt/tcl-tk@8/lib/pkgconfig"
# sqlite
# export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
# tcl-tk@8
# export PATH="/opt/homebrew/opt/tcl-tk@8/bin:$PATH"

# alias 
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
alias grep='rg'
alias find='fd'

# 编辑
alias v='nvim'
alias vi='nvim'

# mkdir
alias mkd='mkdir -p'

# rm（安全）
alias rm='trash'

# git（轻量）
alias lg='lazygit'
alias g='git'
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate'

# 进程
alias ps='ps aux'
alias top='htop'

# functions
# 交互删除文件到回收站
del() {
    # 如果没传参数，提示
    if [ $# -eq 0 ]; then
        echo "Usage: del <file1> [file2 ...]"
        return 1
    fi

    for f in "$@"; do
        # 提示用户
        read -r "ans?Delete '$f'? [y/N] "
        if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            if command -v trash >/dev/null 2>&1; then
                trash "$f"
            else
                # fallback: rm -i
                rm -i "$f"
            fi
        else
            echo "Skipped $f"
        fi
    done
}

mkcd() {
    if [ $# -eq 0 ]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi

    # 创建目录（包括父目录）
    mkdir -p "$1"

    # 进入第一个参数指定的目录
    cd "$1" || return
}

size() {
    du -sh $@
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# cd with zoxide first, fd fallback, fzf preview
cdp() {
    # 获取候选目录
    local dir
    dir=$(
        {
            # zoxide 最近使用的目录
            zoxide query -ls 2>/dev/null | awk '{print $2}'
            # fallback：fd 查找目录，隐藏文件夹，但排除 .git
            fd --type d --hidden --exclude .git
        } | sort -u | fzf --preview='eza --tree --level=2 --icons {}'
    )

    # 如果用户选择了目录，进入
    if [[ -n "$dir" ]]; then
        cd "$dir" || return
    fi
}

# fzf 文件查找器，带 bat 预览，支持 -rec N
f() {
    local days=""
    local args=("$@")   # 保存所有参数
    local file
    local cmd

    # 解析 -rec N
    if [[ ${#args[@]} -ge 2 ]] && [[ ${args[0]} == "-rec" ]]; then
        days=${args[1]}
        # 移除已解析参数
        args=("${args[@]:2}")
    fi

    # 构造 fd 命令
    if [[ -n "$days" ]]; then
        cmd=(fd --type f --hidden --exclude .git --changed-within "${days}d" "${args[@]}")
    else
        cmd=(fd --type f --hidden --exclude .git "${args[@]}")
    fi

    # 运行 fzf
    file=$("${cmd[@]}" | fzf --preview='bat --style=numbers --color=always --line-range :300 {}')

    # 如果有选择文件，打开 nvim
    if [[ -n "$file" ]]; then
        nvim "$file"
    fi
}

# ripgrep search with fzf preview and nvim jump
r() {
    local result
    local file
    local line

    # 搜索结果通过 fzf
    result=$(rg --line-number --no-heading --color=always "$@" \
        | fzf --ansi --delimiter : \
              --preview 'bat --style=numbers --color=always --highlight-line {2} {1}')

    # 如果没有选择结果，则退出
    [[ -z "$result" ]] && return

    # 分割文件名和行号
    file=$(echo "$result" | cut -d: -f1)
    line=$(echo "$result" | cut -d: -f2)

    # 打开 nvim 到指定行
    nvim +"$line" "$file"
}

# recent files with fzf + bat preview
recent() {
    local days=2

    # 如果传了参数，使用第一个参数覆盖 days
    [[ -n "$1" ]] && days="$1"

    # 查找最近修改的文件
    fd . --type f --changed-within "${days}d" \
        | fzf --preview='bat --style=numbers --color=always {}'
}

lf() {
  local file="${1:?usage: ltf <logfile>}"
  tail -f "$file" | fzf -i --ansi --no-sort --tac
}


le() {
  local file="${1:?usage: lcp <logfile>}"
  tail -n 20000 "$file" \
  | sed 's/error/\x1b[31m&\x1b[0m/Ig' \
  | fzf -i --ansi --no-sort --tac --preview "sed -n \"\$(( {n}-5 )) , \$(( {n}+5 ))p\" $file"
}

eval "$(starship init zsh)"
