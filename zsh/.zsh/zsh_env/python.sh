
# readline python 编译
export LDFLAGS="-L/opt/homebrew/opt/readline/lib -L/opt/homebrew/opt/sqlite/lib -L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/tcl-tk@8/lib"
export CPPFLAGS="-I/opt/homebrew/opt/readline/include -I/opt/homebrew/opt/sqlite/include -I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/tcl-tk@8/include " 
export PKG_CONFIG_PATH="/opt/homebrew/opt/readline/lib/pkgconfig:/opt/homebrew/opt/sqlite/lib/pkgconfig:/opt/homebrew/opt/zlib/lib/pkgconfig:/opt/homebrew/opt/tcl-tk@8/lib/pkgconfig"
# sqlite
# export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
# tcl-tk@8
# export PATH="/opt/homebrew/opt/tcl-tk@8/bin:$PATH"

