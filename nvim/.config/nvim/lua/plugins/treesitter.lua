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
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({ "rust", "javascript", "python", "typescript", "html", "vue" })
			vim.api.nvim_create_autocmd({ "FileType", "BufReadPost" }, {
				group = vim.api.nvim_create_augroup("TreesitterAutoStart", { clear = true }),
				callback = function()
					local buf = vim.api.nvim_get_current_buf()
					-- 检查当前缓冲区是否已经有 Treesitter 解析器
					local ok, _ = pcall(vim.treesitter.get_parser, buf)
					if ok then
						vim.treesitter.start()
					end
				end,
			})
		end,
	},

	-- Treesitter Configuration
}
