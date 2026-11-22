OS=""
PACKAGE_MANAGER=""

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    PACKAGE_MANAGER="brew"
    brew install rustnet
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
