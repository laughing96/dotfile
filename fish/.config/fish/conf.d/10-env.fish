eval (/opt/homebrew/bin/brew shellenv)
# Set up zoxide key bindings
zoxide init fish | source
# Set up fzf key bindings
fzf --fish | source
# # add user man path fish 会覆盖原有的，暂时先放到homebrew下面了 后面在调整
# set -gx MANPATH $HOME/.local/share/man $MANPATH
set -gx PATH $HOME/.local/bin $PATH
