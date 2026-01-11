function recent --description 'recent files with preview'
    set days 2
    set -q argv[1]; and set days $argv[1]

    fd . --type f --changed-within {$days}d \
    | fzf --preview='bat --style=numbers --color=always {}'
end
