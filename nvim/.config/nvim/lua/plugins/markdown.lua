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
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	build = "cd app && yarn install",
	-- 	init = function()
	-- 		vim.g.mkdp_filetypes = { "markdown" }
	-- 	end,
	-- 	ft = { "markdown" },
	-- },

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
			local obsidian_path = home .. "/obsidian/dl note"
			require("obsidian").setup({
				workspaces = {
					{
						name = "dl note",
						-- path = "/Users/dl/obsidian/dl note",
						path = obsidian_path,
					},
				},
				ui = {
					enable = false, -- Obsidian handles checkboxes correctly
				},
				templates = {
					folder = "templates",
					date_format = "%Y-%m-%d-%a",
					time_format = "%H:%M",
				},

				follow_url_func = function(url)
					vim.fn.jobstart({ "open", url }) -- Mac OS
				end,
			})

        end,
        vim.keymap.set('n',"<leader>obb","<cmd>ObsidianBacklinks<cr>", {desc = "Backlinks"})
        -- keys = {
        --     {"<leader>obb", "<cmd>ObsidianBacklinks<cr>", desc= "Backlinks"},
        -- },
	
	},
}
