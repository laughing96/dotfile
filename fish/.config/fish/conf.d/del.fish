# ~/.config/fish/functions/del.fish
function del
    for f in $argv
        read -l -P "Delete $f? [y/N] " ans
        if test "$ans" = y
            trash $f
        end
    end
end
