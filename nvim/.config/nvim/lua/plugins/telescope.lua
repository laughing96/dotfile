return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	-- pic
	-- {
	-- 	"vhyrro/luarocks.nvim",
	-- 	priority = 1001, -- 优先级调最高
	-- 	lazy = false, -- 启动时就加载
	-- 	opts = {
	-- 		rocks = { "dkjson", "magick" }, -- 显式要求安装 magick
	-- 		lua_version = "5.1",
	-- 	},
	-- },

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local image_api = require("image")

			require("telescope").setup({
				defaults = {
					buffer_previewer_maker = function(filepath, bufnr, opts)
						-- 这里的逻辑确保图片文件不会被判定为 "binary"
						local is_image = function(path)
							local image_extensions = { "png", "jpg", "jpeg", "gif", "webp" }
							local split_path = vim.split(path:lower(), ".", { plain = true })
							return vim.tbl_contains(image_extensions, split_path[#split_path])
						end

						if is_image(filepath) then
							-- 清空缓冲区，准备贴图
							-- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

							-- 延迟渲染，确保 Telescope 的窗口已经完全打开并计算好坐标
							vim.schedule(function()
								image_api
									.from_file(filepath, {
										buffer = bufnr,
										x = 0,
										y = 0,
										width = 100, -- 比例会自动缩放
										height = 20,
									})
									:render()
							end)
						else
							require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
						end
					end,
				},
			})
			-- 快捷键设置保持不变
			local builtin = require("telescope.builtin")
			local telescope = require("telescope")
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "find_files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "live grep" })
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "oldfiles" })
			vim.keymap.set("n", "<leader>bf", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
			vim.keymap.set("n", "<leader>ff", builtin.git_status, { desc = "git status" })
			vim.keymap.set("n", "<leader>ll", builtin.lsp_document_symbols, { desc = "lsp document symbols" })

			telescope.load_extension("ui-select")
		end,
	},
}
