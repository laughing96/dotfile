#!/bin/sh

DIR="$HOME/.zsh/util/specity_node"

if [ -d "$DIR" ]; then
    # cd "$DIR" || exit
    if lsof -i :3000 > /dev/null;then
        :
        # echo "port 3000 in use"
    else
        node $DIR//mock_curl.js  2>&1 &
    fi
fi
