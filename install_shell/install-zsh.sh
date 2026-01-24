#!/usr/bin/env bash
# install_tools.sh
# 根据系统自动安装常用开发工具和命令行软件

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

# --------------------------
# 2. 安装函数
# --------------------------
install_packages_arch() {
    if command -v pyenv >/dev/null 2>&1; then
        echo "pyenv 已安装"
    else
        echo "pyenv 未安装，开始安装..."
        curl -fsSL https://pyenv.run | bash
        sudo pacman -Syu --needed base-devel openssl zlib xz tk zstd
    fi

    sudo pacman -Syu --needed --noconfirm \
        zsh fzf bat ripgrep fd htop tmux trash-cli starship nodejs npm eza  zoxide
}

install_packages_debian() {

    curl -fsSL https://pyenv.run | bash
    sudo apt update
    sudo apt install -y \
        zsh fzf bat ripgrep fd-find htop tmux trash-cli starship nodejs npm eza zoxide
    sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
}

install_packages_macos() {
    # 确保 brew 安装了
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    fi

    brew update
    brew install \
        zsh fzf bat ripgrep fd htop tmux trash starship pyenv nvm eza zoxide
    brew install openssl readline sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig
}

# --------------------------
# 3. 安装执行
# --------------------------
case "$OS" in
    arch)
        echo "Installing packages on Arch Linux..."
        install_packages_arch
        ;;
    debian)
        echo "Installing packages on Debian/Ubuntu..."
        install_packages_debian
        ;;
    macos)
        echo "Installing packages on macOS..."
        install_packages_macos
        ;;
esac

# --------------------------
# 4. post-install 提示
# --------------------------
echo "Installation complete!"
echo "Remember to:"
echo "- Configure pyenv: export PYENV_ROOT=\"$HOME/.pyenv\" && eval \"\$(pyenv init -)\""
echo "- Configure nvm: export NVM_DIR=\"$HOME/.nvm\" && source \"\$NVM_DIR/nvm.sh\""
echo "- Add starship prompt: eval \"\$(starship init zsh)\" in your .zshrc"
echo "- Source ~/.zsh/auto_complete.sh if you have it"


