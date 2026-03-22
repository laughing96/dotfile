-- 修复常见非法 JSON
local function fix_invalid_json()
	-- 先保存原内容
	local original = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local content = table.concat(original, "\n")
	-- vim.notify("当前文件行数: " .. #original)
	-- vim.notify(content:sub(1, 200))
	vim.cmd([[
    %s/\<nan\>/null/gie
    %s/\<none\>/null/gie
    %s/\<true\>/true/gie
    %s/\<false\>/false/gie
    %s/'/"/ge
    %!jq .
  ]])
	-- 再尝试用 jq 格式化
	local ok2 = pcall(function()
		vim.cmd("%!jq .")
	end)
    -- vim.notify(ok2)
	if not ok2 then
		-- jq 失败就恢复原内容
		vim.api.nvim_buf_set_lines(0, 0, -1, false, original)
		vim.notify("jq 解析失败，已恢复原文件", vim.log.levels.ERROR)
		return
	end

	-- vim.notify("JSON 修复完成", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>dab", ":g/^$/d<CR>", { desc = "Delete empty lines" })
-- JSON
vim.keymap.set("v", "<leader>jf", function()
	fix_invalid_json()
end, { desc = "Fix invalid JSON + format" })

vim.keymap.set("n", "<leader>jf", function()
	fix_invalid_json()
end, { desc = "Fix invalid JSON + format" })

vim.keymap.set("n", "<leader>jk", ":%!jq 'keys'<CR>", { desc = "Show JSON keys" })

vim.keymap.set("n", "<leader>jm", ":%!jq -c .<CR>", { desc = "Minify JSON" })

vim.keymap.set("n", "<leader>jl", function()
	vim.cmd(":g/^{/d<CR>}")
end, { desc = "Keep only JSON lines start with {}" })
