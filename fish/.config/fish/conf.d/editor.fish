if type -q nvim
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    alias v 'nvim'
else if type -q vim
    set -gx EDITOR vim
    set -gx VISUAL vim
end
eval (/opt/homebrew/bin/brew shellenv)

