function    install_ios() {
    install_ios_file="$HOME/Code/breath-app/build-ios.sh"
    if [ -f "$install_ios_file" ]; then
        "$install_ios_file"
    fi
}
