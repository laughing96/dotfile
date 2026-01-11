---
id: Mac 环境搭建 - 设置了系统代理 终端不生效
aliases: []
tags: []
---

阅读人群：国内使用mac的读者 未使用全局代理

# Git
Q ：能使用 ssh 下载，但是不能使用 https 下载。
A：解决方式有两种，第一可以通过设置 insteadof 把 所有的 https 下载链接转化成 github的ssh链接。 第二种就是 设置 http_proxy 代理，指向实际的端口地址。v2raya 默认是20171 端口。
 这样所有使用git 进行下载的内容都可以通过了。
# Curl
Q: LibreSSL/3.3.6: error:1404B42E:SSL routines:ST_CONNECT:tlsv1 alert protocol version
A:  在 ～/.curlrc 里面设置 proxy = localhost:20170 即可。 但是 [[#nvm]] 使用curl 安装时 默认使用了 -q 命令，造成即使有 curlrc 文件也不能下载，需要手动调整 nvm.sh 的内容，去掉 -q 即可。
# pip
[config](https://pip.pypa.io/en/stable/topics/configuration/)
/Library/Application Support/pip /pip.conf
[global]
proxy = http://localhost:20171
# homebrew
修改 brew 中 从环境变量获取 http_proxy, https_proxy  的部分。
```sh
FILTERED_ENV=()
ENV_VAR_NAMES=(
  HOME SHELL PATH TERM TERMINFO TERMINFO_DIRS COLUMNS DISPLAY LOGNAME USER CI SSH_AUTH_SOCK SUDO_ASKPASS
  http_proxy https_proxy ftp_proxy no_proxy all_proxy HTTPS_PROXY FTP_PROXY ALL_PROXY
)
# Filter all but the specific variables.
for VAR in "${ENV_VAR_NAMES[@]}" "${!HOMEBREW_@}"
do
  # Skip if variable value is empty.
  [[ -z "${!VAR:-}" ]] && continue
  if [[ "$VAR" == "http_proxy" || "$VAR" == "https_proxy" ]]; then
    FILTERED_ENV+=("${VAR}=http://localhost:20171")
  else
    FILTERED_ENV+=("${VAR}=${!VAR}")
  fi
#  FILTERED_ENV+=("${VAR}=${!VAR}")
done
```
# nvm
打开 nvm.sh ,去掉 curl 中使用 -q 的命令。 然后 source ～/.zshrc 即可。
# pyenv
😅忘记咋配的代理了。。。。这个使用的也是 [[#Curl]]
# uv
一个和pyenv功能类似的python包管理器，使用的curl，在下载 anki 的时候使用了，一直不能解决uv 的python版本和 mac本身的3.9版本冲突的问题，后来直接下载了anki 二进制绕过去了

# nvim
set mouse=a This sets your vim into visual mode whenever you select something with the mouse. And for some mad reason one is not allowed to copy when in visual mode.
change to set mouse =v

# plugin
If your file is your config file, and inside it you do `require("todo-comments")`, it tries to load itself recursively, causing errors.  
**Rename your config file** to something like `todo-comments-config.lua` or put your configuration inside `init.lua` or a different module name to avoid conflict.

# npm
npm config set proxy http://localhost:20171
npm config set https-proxy http://localhost:20171

# rust
export https_proxy=https://127.0.0.1:20171

# docker
use curl , system admin versus user are different
1.  docker desktop ->setting->preference->proxies->manualy-> https 也要用 http的代理。绑到具体的端口


# tmux
 plugin:tpm catputtic
 tmux select-pane -T test :rename pane


# zsh
p10k

##  spotify
 install spotify without ads :
 bash <(curl -sSL https://spotx-official.github.io/run.sh) --installmac
then [[spotify]]

# yazi
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font
[zoxide](https://github.com/ajeetdsouza/zoxide)



# stow
stow  "function name"

![[Pasted image 20250925233728.png]]

# key 禁用mac 内置的键盘
[key-some-element](https://blog.lishude.xyz/2019/06/29/tool/%E7%A6%81%E7%94%A8-Mac-%E5%86%85%E7%BD%AE%E9%94%AE%E7%9B%98%E5%92%8C%E8%A7%A6%E6%8E%A7%E6%9D%BF/)

# ubuntu server
ssh-copy-id ubuntu@192.168.64.7
**nvim hererock 安装失败**
sudo apt update
sudo apt install -y lua5.1 luarocks
/etc/update / release. /neverjk

# tailscale
## Debain
https://tailscale.com/kb/1038/install-debian-bullseye
## pacman
sudo pacman -S tailscale 
## mac 
使用官方pkg
## ios
app store
