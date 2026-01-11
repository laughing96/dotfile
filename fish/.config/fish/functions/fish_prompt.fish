function fish_prompt
    set_color cyan
    echo -n (prompt_pwd)
    set_color normal

    # Git branch
    if command -sq git
        set -l branch (git symbolic-ref --short HEAD 2>/dev/null)
        if test -n "$branch"
            set_color magenta
            echo -n "  $branch"
            set_color normal
        end
    end

    # Python virtualenv / conda
    if set -q VIRTUAL_ENV
        set_color yellow
        echo -n " 🐍 "(basename $VIRTUAL_ENV)
        set_color normal
    else if set -q CONDA_DEFAULT_ENV
        set_color yellow
        echo -n " 🐍 $CONDA_DEFAULT_ENV"
        set_color normal
    end

    # Node (nvm / system)
    if command -sq node
        set -l node_ver (node -v 2>/dev/null)
        if test -n "$node_ver"
            set_color green
            echo -n " ⬢ $node_ver"
            set_color normal
        end
    end

    echo
    set_color blue
    echo -n "❯ "
    set_color normal
end
