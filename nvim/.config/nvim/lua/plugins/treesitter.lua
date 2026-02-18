return {
	-- UFO Dependencies and Plugin
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufReadPost", -- Load when you actually open a file
		init = function()
			-- These settings are highly recommended for ufo
			vim.o.foldcolumn = "1" -- '0' is also fine if you don't want the side bar
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
		-- opts = {
		-- 	provider_selector = function(bufnr, filetype, buftype)
		-- 		return { "treesitter", "indent" }
		-- 	end,
		-- },
		opts = {
			-- 这是一个美化折叠行末尾显示的函数
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ("  󰁂 %d "):format(endLnum - lnum)
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if width >= curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, width - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						if curWidth + chunkWidth < width then
							suffix = suffix .. (" "):rep(width - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end,
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		},
	},

	-- Treesitter Configuration
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		-- 修改 nvim-treesitter 的 config 部分
		config = {
			ensure_installed = { "javascript", "typescript", "python", "html", "vue", "lua" },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			-- 建议开启，让 tab 缩进更智能
			indent = {
				enable = true,
			},
		},
	},
}
