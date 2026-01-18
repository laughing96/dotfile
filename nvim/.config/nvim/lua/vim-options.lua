vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set mouse=v")
vim.cmd("set clipboard=unnamedplus")
vim.cmd("set nu")
vim.cmd("set relativenumber")
vim.cmd("set conceallevel=2")

vim.g.mapleader = " "
vim.g.background = "light"

vim.wo.number = true
vim.opt.swapfile = false
-- Automatically reload files if they have changed outside of Neovim 
vim.o.autoread = true
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold", "CursorHoldI"}, {
  command = "if mode() != 'c' | checktime | endif"
})

-- default vim.keymap.set create a non-recursive  mapping 
vim.keymap.set("n", "<Leader>w", ":w<CR>")
vim.keymap.set("n", "<Leader>q", ":q<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")


-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

-- Prevent recursive silent feedback
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- vim python 只支持Unix
local python3 = vim.fn.exepath("python3")  -- 查找系统环境中的 python3
if python3 ~= "" then
    vim.g.python3_host_prog = python3
end

-- vim folder
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99        -- Open folds by default
vim.opt.foldenable = false    -- Don't fold automatically on open

-- it show error warning hints information on the virtual text and signs
vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})


if vim.fn.has('unix') == 1 and os.getenv("USER") == "root" then
  vim.env.HOME = "/Users/dl"
end

-- translate
vim.g.translator_target_lang = 'zh'

