#!/usr/bin/env bash
# install_dev_env.sh
# 自动安装 Linux 内核开发及常用开发工具（Arch / Debian / macOS）

set -e  # 遇到错误立即退出

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

# --------------------------
# 2. 安装函数
# --------------------------
install_arch() {
    sudo pacman -Syu --needed --noconfirm \
        base-devel gcc make git lazygit exuberant-ctags \
        ncurses libelf openssl bison flex bc dwarves zstd esmtp mutt
}

install_debian() {
    sudo apt update
    sudo apt-get -y install \
        build-essential git lazygit exuberant-ctags \
        libncurses5-dev libelf-dev libssl-dev bison flex bc dwarves zstd git-email \
        esmtp mutt
}

install_macos() {
    # 安装 Homebrew
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew update
    brew install \
        git lazygit ctags ncurses libelf openssl bison flex bc dwarves zstd esmtp mutt
}

# --------------------------
# 3. 执行安装
# --------------------------
case "$OS" in
    arch)
        echo "Installing packages on Arch Linux..."
        install_arch
        ;;
    debian)
        echo "Installing packages on Debian/Ubuntu..."
        install_debian
        ;;
    macos)
        echo "Installing packages on macOS..."
        install_macos
        ;;
esac

# --------------------------
# 4. 安装完成提示
# --------------------------
echo "--------------------------------------------------"
echo "✅ 开发环境安装完成！"
echo "推荐："
echo "- 配置 ~/.zshrc / ~/.bashrc，加入 PATH、pyenv、nvm 初始化"
echo "- 安装 Starship 终端提示符：https://starship.rs/"
echo "- 安装 zoxide: https://github.com/ajeetdsouza/zoxide"
echo "--------------------------------------------------"

