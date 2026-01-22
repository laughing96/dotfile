#!/usr/bin/env bash
set -e

echo "==> Homebrew 基础"
brew update

echo "==> CLI / Terminal 核心"
brew install \
  git gh \
  zsh starship \
  tmux \
  fzf ripgrep fd \
  bat eza zoxide \
  neovim \
  lua luarocks \
  python \
  cmake 

# echo "==> 程序开发交流"
brew install --cask \
    telegram \
#     element 

echo "==> GUI / 开发工具"
brew install --cask \
  wezterm@nightly \
  # visual-studio-code \
  # fork \
  orbstack \
  wireshark \
  proxyman \
  imhex

echo "==> 知识 / 效率"
brew install --cask \
  obsidian \
  raindropio \
  alfred \ #Terminal 替代
  # bettermouse \
  # 1password \
  squirrel \
  # dash \
  sip # system integrity protection?

echo "==> 截图 / 录屏"
brew install --cask \
  shottr \
  kap # use

echo "==> 影音"
brew install --cask \
  iina \
  spotify 
  # jstkdng/programs/ueberzugpp # pic preview A LITTLE heavy



echo "==> App Store 应用"
mas install 1529448980   # Reeder 5
mas install 966085870    # TickTick

echo "==> Done. 建议重启一次。"
