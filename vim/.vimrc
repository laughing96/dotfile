
"inoremap <esc> <nop> " nop means no operation
let $PATH = '/Users/dl/.cargo/bin' . $PATH  

"" Enable LSP debug logging
"lua vim.lsp.set_log_level("debug")

let mapleader = " "

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
set mouse=v
set clipboard=unnamedplus
set nu
" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
" vnoremap <C-c> "*y"

syntax on
set tabstop=4       " Number of spaces that a <Tab> counts for
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent
set expandtab       " Use spaces instead of actual tab characters
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup
set ignorecase
set smartcase
set history=40
set report=0
set title
set showcmd
set laststatus=2
set autoindent
set smartindent
set rnu
" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

inoremap jk <esc>
vnoremap jk <esc>
inoremap <c-d> <esc>ddi


""lua require('nvim-treesitter').setup()
"lua require('Comment').setup()
"
""" file explorer
"" Disable netrw (optional but recommended)
"let g:loaded_netrw = 1
"let g:loaded_netrwPlugin = 1
"" Enable true color support
"set termguicolors
"" lua require('nvim-tree-config')
"nnoremap <silent> <C-n> :NvimTreeToggle<CR>
""" end file explorer
"let g:tagbar_ctags_bin = '/opt/homebrew/bin/ctags'
"nmap <F8> :TagbarToggle<CR>
"
"lua require("todo-comments")
"
"lua require("codeformater")
"
if has('unix') && $USER == "root" 
  let $HOME = '/home/dl'
end
