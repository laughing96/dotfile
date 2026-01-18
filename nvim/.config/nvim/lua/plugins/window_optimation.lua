return {
	{
		"kevinhwang91/nvim-bqf",
		lazy = false,
	},

	{
		"szw/vim-maximizer",
		config = function()
			vim.keymap.set("n", "<leader>m", "<cmd>MaximizerToggle<CR>", { desc = "Maximizer Toggle" })
		end,
	},
}
