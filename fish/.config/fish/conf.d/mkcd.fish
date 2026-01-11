# ~/.config/fish/functions/mkcd.fish
function mkcd
    mkdir -p $argv
    cd $argv[1]
end
