#!/usr/bin/env zsh

# ------------------------
# 历史设置
# ------------------------
HISTFILE=${HISTFILE:-~/.zsh_history}
HISTSIZE=10000
SAVEHIST=10000
setopt share_history       # 多终端共享历史
setopt inc_append_history  # 命令实时写入历史
setopt hist_ignore_dups    # 忽略重复命令
setopt extended_history    # 包含时间戳

# ------------------------
# 自动补全提示 (像 fish)
# ------------------------
if [[ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
else
    # 克隆插件到 ~/.zsh/ 目录一次即可：
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555'
fi

# ------------------------
# 历史子串搜索（上下键搜索历史）
# ------------------------

if [[ ! -f "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh/zsh-history-substring-search
fi
if [[ -f "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
    source "$HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"
    
    # 绑定上下箭头
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    # 备用：兼容不同终端发送的序列
    bindkey '\eOA' history-substring-search-up
    bindkey '\eOB' history-substring-search-down
fi

# ------------------------
# Ctrl + Arrow 支持（跨平台）
# ------------------------
bindkey '\e[1;5D' backward-word  # Ctrl+Left
bindkey '\e[1;5C' forward-word   # Ctrl+Right
bindkey '\e[1;3D' backward-word  # Alt+Left
bindkey '\e[1;3C' forward-word   # Alt+Right
bindkey '\e[1;2D' backward-word  # Shift+Left
bindkey '\e[1;2C' forward-word   # Shift+Right

# ------------------------
# 提示符简单设置
# ------------------------
export PS1='%F{cyan}%n@%m%f %F{yellow}%~%f %# '
