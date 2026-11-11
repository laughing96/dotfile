
proxy_ip=127.0.0.1
no_proxy="127.0.0.1,localhost,.localdomain.com,192.168.*.*"
no_proxy=$no_proxy,${proxy_ip}
export no_proxy

export http_proxy="http://${proxy_ip}:20171"
export https_proxy="http://${proxy_ip}:20171"
export sock_proxy="socks5://${proxy_ip}:20170"

export PYTHON_BUILD_CURL_OPTS=" -x localhost:20171" 

# export ALL_PROXY=" -x localhost:20171"
