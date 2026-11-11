function late() {
    if [ $# -eq 0 ]; then 
        echo "Usage: late 'test' 2"
        return 1
    fi
    echo "osascript -e 'display dialog \"$1\" with title \"系统提示\"'" | at now + "$2" minutes
}

