function f --description 'fzf file finder with preview'
    set days ""
    set args $argv

    # 解析 -recent N
    if test (count $args) -ge 2
        if test $args[1] = "-rec"
            set days $args[2]
            # 移除已解析的参数
            set args $args[3..-1]
        end
    end

    # 构造 fd 命令
    if test -n "$days"
        set cmd fd --type f --hidden --exclude .git --changed-within {$days}d
    else
        set cmd fd --type f --hidden --exclude .git
    end

    set file (
        $cmd \
        | fzf --preview='bat --style=numbers --color=always --line-range :300 {}'
    )

    test -n "$file"; and nvim $file
end
