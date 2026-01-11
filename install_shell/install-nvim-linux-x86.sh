#/bin/sh

mkdir -p ~/software
if ! test -f ~/software/nvim-linux-x86_64.tar.gz; then
	curl -L -o ~/software/nvim-linux-x86_64.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
fi
mkdir -p ~/local/nvim
# for obsidian
mkdir -p "/Users/dl/obsidian/dl note"
tar -zxvf ~/software/nvim-linux-x86_64.tar.gz -C ~/local/nvim --strip-components=1
echo "export PATH=$PATH:~/local/nvim/bin" >> ~/.myenv
echo "alias vim=nvim" >> ~/.myenv
source ~/.myenv
echo "source ~/.myenv" >> ~/.bashrc
nvim --version

