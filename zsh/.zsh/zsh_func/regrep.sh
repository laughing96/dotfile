
function r() {
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

