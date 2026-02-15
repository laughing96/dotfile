return {
	{
		"MeanderingProgrammer/render-markdown.nvim",

		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	},
	config = function()
		require("render-markdown").setup({
			checkbox = { enabled = false },
			indent = { enabled = true },
		})
	end,
	{
		"vhyrro/luarocks.nvim",
		priority = 1001, -- 优先级调最高
		lazy = false, -- 启动时就加载
		opts = {
			rocks = { "dkjson", "magick" }, -- 显式要求安装 magick
			lua_version = "5.1",
		},
	},
	{
		"3rd/image.nvim",
		event = "VeryLazy",
		dependencies = {
			-- 必须要安装 luarocks 才能驱动 magick
			{ "vhyrro/luarocks.nvim" },
		},

		opts = {
			backend = "kitty", -- 如果用 WezTerm，这里也可以改为 "ueberzug" 或保持自动检测
			processor = "magick_cli",
			integrations = {
				telescope = {
					enabled = true,
				},
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = true, -- 是否只显示光标下的图片
					only_render_image_at_cursor_mode = "popup", -- "popup" or "inline", defaults to "popup"

					floating_windows = false, -- if true, images will be rendered in floating markdown windows
					filetypes = { "markdown", "vimwiki", "obsidian" }, -- 兼容 Obsidian 笔记
				},
				neorg = {
					enabled = false,
				},
			},
			max_width = 100, -- 图片最大宽度
			max_height = 20, -- 图片最大高度
			max_width_window_percentage = 50,
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = true, -- 浮窗覆盖时是否清除图片
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			editor_only_render_when_focused = false, -- 失去焦点时是否保留图片
			tmux_show_only_in_active_window = true, -- Tmux 兼容性
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- 直接打开图片文件
			-- rocks = {
			-- 	hererocks = true, -- 🔥关键
			-- },
		},
	},
	{
		"epwalsh/obsidian.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter",
		},
		config = function()
			local home = os.getenv("HOME")
			local obsidian_path = home .. "/obsidian/mynote"
			require("obsidian").setup({
				workspaces = {
					{
						name = "mynote",
						-- path = "/Users/dl/obsidian/dl note",
						path = obsidian_path,
					},
				},
				daily_notes = {
					folder = "Daily",
					date_format = "%Y-%m-%d",
					default_tags = {},
					template = obsidian_path .. "/templates/DailyTemp.md",
				},
				completion = {
					nvim_cmp = true,
					min_chars = 1,
				},

				ui = {
					enable = false, -- Obsidian handles checkboxes correctly
				},
				templates = {
					folder = "templates",
					date_format = "%Y-%m-%d-%a",
					time_format = "%H:%M",
				},

				-- Specify how to handle attachments.
				attachments = {
					-- The default folder to place images in via `:ObsidianPasteImg`.
					-- If this is a relative path it will be interpreted as relative to the vault root.
					-- You can always override this per image by passing a full path to the command instead of just a filename.
					img_folder = "Attachment", -- This is the default

					-- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
					---@return string
					img_name_func = function()
						-- Prefix image names with timestamp.
						-- return string.format("%s-", os.time())
                        return os.date("%Y%m%d-%H%M%S-")
					end,

					-- A function that determines the text to insert in the note when pasting an image.
					-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
					-- This is the default implementation.
					---@param client obsidian.Client
					---@param path obsidian.Path the absolute path to the image file
					---@return string
					img_text_func = function(client, path)
						path = client:vault_relative_path(path) or path
						-- 2. 转成字符串
						local rel_str = "/" .. tostring(path)

						-- 3. 拼你的 obsidian_path 前缀
						local full = obsidian_path .. rel_str
						return string.format("![%s](%s)", path.name, full)
					end,
				},

				follow_img_func = function(url)
					vim.notify("url", url)
					vim.fn.jobstart({ "open", url }) -- Mac OS
				end,
				follow_url_func = function(url)
					vim.notify("url", url)
					vim.fn.jobstart({ "open", url }) -- Mac OS
				end,
			})
		end,
		vim.keymap.set("n", "<leader>obb", "<cmd>ObsidianBacklinks<cr>", { desc = "Backlinks" }),
		vim.keymap.set("n", "<leader>opp", "<cmd>ObsidianPasteImg<cr>", { desc = "Paste Pic" }),
		vim.keymap.set("n", "<leader>ond", "<cmd>ObsidianDailies<cr>", { desc = "New Dailies" }),
		-- vim.keymap.set('n',"<leader>ch","<cmd>ObsidianBacklinks<cr>", {desc = "Backlinks"})
		-- keys = {
		--     {"<leader>obb", "<cmd>ObsidianBacklinks<cr>", desc= "Backlinks"},
		-- },
	},
}
