-- 在 init.lua 文件的第一行
package.cpath = package.cpath .. ";/opt/homebrew/lib/lua/5.1/?.so"
package.path = package.path .. ";/opt/homebrew/share/lua/5.1/?.lua"

-- 告诉 magick 库在哪里 (根据你 ls 的结果修改版本号)
vim.env.MAGICK_WAND_PATH = "/opt/homebrew/lib/libMagickWand-7.Q16HDRI.dylib"
-- config 
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
require("easy_func")
require("reading").setup()


require("lazy").setup({
 spec = {
    { import = "plugins" },   -- 👈 plugins 目录
  },
  rocks = {
    enabled = false,   -- ❗全局禁用 luarocks loader
  },
})

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "vue",
--   callback = function()
--     vim.opt_local.foldmethod = "indent"
--     vim.opt_local.foldexpr = ""
--     vim.opt_local.foldlevel = 99
--   end,
-- })
-- read html in neovim
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "http://*", "https://*" },
  callback = function(ev)
    local url = ev.match

    -- 用 curl 下载
    local cmd = { "curl", "-L", url }
    local output = vim.fn.system(cmd)

    -- 放进当前 buffer
    vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, vim.split(output, "\n"))

    -- 标记这是一个“虚拟文件”
    vim.bo[ev.buf].buftype = "acwrite"
    vim.bo[ev.buf].swapfile = false
    vim.bo[ev.buf].modifiable = true

    -- 防止再走文件系统
    vim.api.nvim_buf_set_name(ev.buf, url)
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "silent! write"
})
