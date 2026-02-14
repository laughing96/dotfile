-- 在 init.lua 文件的第一行
package.cpath = package.cpath .. ";/opt/homebrew/lib/lua/5.1/?.so"
package.path = package.path .. ";/opt/homebrew/share/lua/5.1/?.lua"

-- 告诉 magick 库在哪里 (根据你 ls 的结果修改版本号)
vim.env.MAGICK_WAND_PATH = "/opt/homebrew/lib/libMagickWand-7.Q16HDRI.dylib"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

require("vim-options")
require("insert_image")
require("reading").setup()


require("lazy").setup({
 spec = {
    { import = "plugins" },   -- 👈 plugins 目录
  },
  rocks = {
    enabled = false,   -- ❗全局禁用 luarocks loader
  },
})

