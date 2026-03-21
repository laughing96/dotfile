-- 格式化 JSON
local function json_format()
	fix_invalid_json()
	vim.cmd("%!jq .")
end

-- 压缩 JSON（变一行）
local function json_minify()
	fix_invalid_json()
	vim.cmd("%!jq -c .")
end

-- 只格式化选中的 JSON
local function json_format_selection()
	vim.cmd("'<,'>!jq .")
end

-- 修复常见非法 JSON
local function fix_invalid_json()
	vim.cmd([[
    %s/\<nan\>/null/gie
    %s/\<none\>/null/gie
    %s/\<true\>/true/gie
    %s/\<false\>/false/gie
    %s/'/"/ge
  ]])
end

vim.keymap.set("n", "<leader>dab", ":g/^$/d<CR>", { desc = "Delete empty lines" })
-- JSON
vim.keymap.set("v", "<leader>jf", function()
	fix_invalid_json()
	vim.cmd("%!jq .")
end, { desc = "Fix invalid JSON + format" })

vim.keymap.set("n", "<leader>jf", function()
	fix_invalid_json()
	vim.cmd("%!jq .")
end, { desc = "Fix invalid JSON + format" })

vim.keymap.set("n", "<leader>jk", ":%!jq 'keys'<CR>", { desc = "Show JSON keys" })

vim.keymap.set("n", "<leader>jm", ":%!jq -c .<CR>", { desc = "Minify JSON" })

vim.keymap.set("n", "<leader>jl", function()
	vim.cmd(":g/^{/d<CR>}")
end, { desc = "Keep only JSON lines start with {}" })
