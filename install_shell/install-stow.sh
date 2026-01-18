#/bin/sh

# sudo apt update
# sudo apt install -y stow
if test -d ~/dot-file; then
    cd ~/dot-file

    sudo apt install -y delta
    stow git -t ~
    echo "alias g=git" >> ~/.myenv
    source ~/.myenv

    if ! test -f "$HOME/obsidain/dl note"; then
        mkdir -p "$HOME/obsidain/dl note"
    fi 
    stow nvim -t ~
fi 


