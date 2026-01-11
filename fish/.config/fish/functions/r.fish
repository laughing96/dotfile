# ~/.config/fish/functions/r.fish
function r --description 'ripgrep search with preview'
    rg --line-number --no-heading --color=always $argv \
    | fzf --ansi \
          --delimiter : \
          --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
    | read -l result

    test -n "$result"; or return
    set file (echo $result | cut -d: -f1)
    set line (echo $result | cut -d: -f2)
    nvim +$line $file
end
