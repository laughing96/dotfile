
function cdp() {
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



function f() {
    local days=""
    local args=("$@")
    local file
    local cmd

    # 解析 -rec N
    if [ "${#args[@]}" -ge 2 ] && [ "${args[0]}" = "-rec" ]; then
        days="${args[1]}"
        args=("${args[@]:2}")
    fi

    # 构造 fd 命令（完全保留 fd 原有参数能力）
    if [ -n "$days" ]; then
        cmd=(fd --type f --hidden --exclude .git --changed-within "${days}d" "${args[@]}")
    else
        cmd=(fd --type f --hidden --exclude .git "${args[@]}")
    fi

    # fzf 选择
    file="$("${cmd[@]}" | fzf \
        --preview='bat --style=numbers --color=always --line-range :300 {}')"

    # 打开文件
    [ -n "$file" ] && nvim "$file"
}


