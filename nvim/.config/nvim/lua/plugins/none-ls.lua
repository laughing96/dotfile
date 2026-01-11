return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.clang_format,

				require("none-ls.diagnostics.flake8"),
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, { noremap = true, silent = true })
		-- vim.keymap.set("n", "<leader>d[", vim.diagnostic.goto_prev, { noremap = true, silent = true })
		-- vim.keymap.set("n", "<leader>d]", vim.diagnostic.goto_next, { noremap = true, silent = true })
		-- vim.keymap.set("n", "<leader>dd", vim.diagnostic.setloclist, { noremap = true, silent = true })
	end,
}
