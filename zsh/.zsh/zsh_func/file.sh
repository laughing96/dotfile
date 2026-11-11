
function del() {
    # 如果没传参数，提示
    if [ $# -eq 0 ]; then
        echo "Usage: del <file1> [file2 ...]"
        return 1
    fi

    for f in "$@"; do
        # 提示用户
        read -r "ans?Delete '$f'? [y/N] "
        if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            if command -v trash >/dev/null 2>&1; then
                trash "$f"
            else
                # fallback: rm -i
                rm -i "$f"
            fi
        else
            echo "Skipped $f"
        fi
    done
}

function mkcd() {
    if [ $# -eq 0 ]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi

    # 创建目录（包括父目录）
    mkdir -p "$1"

    # 进入第一个参数指定的目录
    cd "$1" || return
}


function size() {
    du -sh $@
}

