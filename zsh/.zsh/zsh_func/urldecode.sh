function urldecode() {
    if [[ $# -gt 0 ]]; then
        printf '%s' "$*" | python3 -c \
            'import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))'
    else
        python3 -c \
            'import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))'
    fi
}
