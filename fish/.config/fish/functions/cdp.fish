function cdp --description 'cd with zoxide first, fd fallback'
    set dir (
        begin
            zoxide query -ls | awk '{print $2}'
            fd --type d --hidden --exclude .git
        end | sort -u \
        | fzf \
            --preview='eza --tree --level=2 --icons {}'
    )

    test -n "$dir"; and cd "$dir"
end
