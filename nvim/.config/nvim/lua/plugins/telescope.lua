return {

	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "3rd/image.nvim" },
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
							-- require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
							-- 清空缓冲区，准备贴图
							-- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})

							-- 延迟渲染，确保 Telescope 的窗口已经完全打开并计算好坐标
							vim.schedule(function()
								-- local image_api = require("image")
								--
								-- -- 获取当前窗口（预览窗）的 ID
								-- local win_id = vim.fn.bufwinid(bufnr)
								-- if win_id == -1 then
								-- 	return
								-- end
								--
								-- -- 获取预览窗口在屏幕上的起始坐标 (row, col)
								-- local pos = vim.api.nvim_win_get_position(win_id)
								-- local win_width = vim.api.nvim_win_get_width(win_id)
								-- local win_height = vim.api.nvim_win_get_height(win_id)
								-- -- 在预览窗位置创建图像
								-- image_api
								-- 	.from_file(filepath, {
								-- 		buffer = bufnr,
								-- 		window = win_id, -- 绑定窗口 ID 关键！
								-- 		x = pos[2], -- 列坐标
								-- 		y = pos[1], -- 行坐标
								-- 		width = win_width,
								-- 		height = win_height,
								-- 		with_virtual_padding = true, -- 自动添加空格占位，防止文字重叠
								-- 	})
								-- 	:render()
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
			vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "find_files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "live grep" })
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "oldfiles" })
			vim.keymap.set("n", "<leader>bf", builtin.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
			vim.keymap.set("n", "<leader>ff", builtin.git_status, { desc = "git status" })

			require("telescope").load_extension("ui-select")
		end,
	},
}
