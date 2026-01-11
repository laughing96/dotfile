return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		lazy = false,
	},
	{
		"simrat39/rust-tools.nvim",
		config = function()
            vim.lsp.config["rust-tools"] = ({
				server = {
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = true,
							["checkOnSave.command"] = "clippy",
							procMacro = { enable = true },
						},
					},
				},
			})
            vim.lsp.enable("rust-tools")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
        submodules=false,
        shallow=true,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config["lua_ls"] = {
				capabilities = capabilities,
			}
			vim.lsp.enable("lua_ls")

            vim.lsp.config("clangd", {
                cmd = { "clangd", "--background-index" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                -- root_dir = require('lspconfig.util').root_pattern("compile_commands.json", ".git")
            })
            vim.lsp.enable("clangd")

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
