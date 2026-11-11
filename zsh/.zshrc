# 转义
# 让 Ctrl + Left/Right 正常移动单词，不要转义序列
bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word


# PATH env
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/trash/bin:$PATH"
export PATH="/usr/local/opt/postgresql/bin:$PATH"
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"

export XDG_CONFIG_HOME="$HOME/.config"

#In short, Tmuxifier allows you to easily create, edit, and load "layout" files, which are simple shell scripts where you use the tmux command and helper commands provided by tmuxifier to manage Tmux sessions and windows
# eval "$(tmuxifier init -)"
eval "$(zoxide init zsh)"

# 1. Zsh 补全
autoload -U compinit && compinit

# 2. 兼容 Bash 补全
autoload -U bashcompinit && bashcompinit

ZSH_ALIAS_FILE="$HOME/.zsh/zsh_alias.sh"
if [[ -f "$ZSH_ALIAS_FILE" ]];then
    source "$ZSH_ALIAS_FILE"
fi

ZSH_ENV_DIR="$HOME/.zsh/zsh_env"
if [[ -d "$ZSH_FUNC_DIR" ]]; then
    for file in "$ZSH_FUNC_DIR"/*.sh; do
        [[ -f "$file" ]] || continue
        source "$file"
    done
fi


# 加载func
ZSH_FUNC_DIR="$HOME/.zsh/zsh_func"
if [[ -d "$ZSH_FUNC_DIR" ]]; then
    for file in "$ZSH_FUNC_DIR"/*.sh; do
        [[ -f "$file" ]] || continue
        source "$file"
    done
fi

eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

if [ -f ~/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

sayhi
