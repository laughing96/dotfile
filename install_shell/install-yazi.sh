#/bin/sh

set -e

# --------------------------
# 1. 系统检测
# --------------------------
OS=""
PACKAGE_MANAGER=""

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    PACKAGE_MANAGER="brew"
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "arch" || "$ID_LIKE" =~ "arch" ]]; then
        OS="arch"
        PACKAGE_MANAGER="pacman"
    elif [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
        OS="debian"
        PACKAGE_MANAGER="apt"
    else
        echo "Unsupported Linux distro: $ID"
        exit 1
    fi
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo "Detected OS: $OS, Package Manager: $PACKAGE_MANAGER"

#
install_yazi_arch() {
    if command -v yazi >/dev/null 2>&1; then
        echo "yazi 已安装"
    else
        echo "yazi 未安装,开始安装"
        sudo pacman -Syu --needed --noconfirm yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick
    fi
}
install_yazi_debian() {
    echo "need manualy install"
    apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
}

install_yazi_macos() {
    brew update 
    brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font
}

# 3 install
case "$OS" in 
    arch)
        echo "Installing yazi on Arch Linux..."
        install_yazi_arch
        ;;
    macos)
        echo "Installing yazi on macOS..."
        install_yazi_macos
        ;;
    debain)
        echo "Installing yazi on Debian/Ubuntu..."
        install_yazi_debian
        ;;
esac


