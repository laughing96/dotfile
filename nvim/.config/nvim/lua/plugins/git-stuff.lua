return {
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			local gs = require("gitsigns")
			vim.keymap.set("n", "<leader>gb", gs.blame_line, { desc = "Gitsigns: blame_line" })
			vim.keymap.set("n", "<leader>ga", gs.stage_hunk, { desc = "Stage hunk" })
			vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
			vim.keymap.set("n", "<leader>df", gs.diffthis, { desc = "diffthis" })
			vim.keymap.set("n", "]c", gs.next_hunk, { desc = "Next hunk" })
			vim.keymap.set("n", "[c", gs.prev_hunk, { desc = "Prev hunk" })
		end,
	},
}
