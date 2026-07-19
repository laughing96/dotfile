# 背景
spotify 引入 last.fm 后,很多链接仍然继承了 last.fm 的内容,点击会去last 里面,
last.fm 自带的cookie 会拦截变成406,

# 方案
chrome 启动一个 extension,实现页面先访问 home,刷新cookie .

# icon
./png.sh lastfm.png
