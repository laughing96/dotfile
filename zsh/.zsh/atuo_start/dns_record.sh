#!/bin/sh

DIR="/Users/dl/Code/nmap/dns"
FILE="dns_server_final.py"
PORT=53
START=1

# 检查 UDP 53 是否已经被占用
if lsof -nP -iUDP:$PORT >/dev/null 2>&1; then
    # echo "UDP port $PORT is already in use."
    # lsof -nP -iUDP:$PORT
    START=0
    exit 1
fi

# 检查 Python 文件
if [ ! -f "$DIR/$FILE" ]; then
    echo "File not found: $DIR/$FILE"
    START=0
fi


# 后台启动
if [ $START -eq 1 ];then 
    echo "START"
    cd "$DIR"  || exit 1
    uv run "$FILE" > dns_console.log 2>&1 &
else
    echo "no start"
fi
# nohup uv run "$FILE" > dns_console.log 2>&1 &
# uv run "$FILE" > dns_console.log 2>&1 

# echo "DNS server started, PID=$!"
