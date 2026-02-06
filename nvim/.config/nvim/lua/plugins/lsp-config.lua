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
			vim.lsp.config["rust-tools"] = {
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
			}
			vim.lsp.enable("rust-tools")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		submodules = false,
		shallow = true,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config["lua_ls"] = {
				capabilities = capabilities,
			}
			vim.lsp.enable("lua_ls")
			-- TOML (taplo)
			vim.lsp.config["taplo"] = {
				capabilities = capabilities,
				filetypes = { "toml" },
			}
			vim.lsp.enable("taplo")

			-- Harper (disable formatting so it doesn't fight taplo)
			vim.lsp.config["harper_ls"] = {
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
			}
			vim.lsp.enable("harper_ls")

			-- vim.lsp.config["vue_ls"] = {
			--     filetypes = { "vue" },
			--     init_options = {
			--         typescript = {
			--             tsdk = vim.fn.expand(
			--                 vim.fn.stdpath("data") ..
			--                 "/mason/packages/typescript-language-server/node_modules/typescript/lib"
			--             ),
			--         },
			--         vue = { hybridMode = false },
			--     },
			-- }
			-- vim.lsp.enable("vue_ls")
			-- vim.lsp.enable("ts_ls")

			-- managed to get vue-language-server working with tsserver following https://github.com/vuejs/language-tools/wiki/Neovim
			local vue_language_server_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = vue_language_server_path,
				languages = { "vue" },
				configNamespace = "typescript",
			}
			local tsserver_config = {
				settings = {
					tsserver = {
						tsserver = {
							globalPlugins = {
								vue_plugin,
							},
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			}

			local vue_ls_config = {
				on_init = function(client)
					client.handlers["tsserver/request"] = function(_, result, context)
						local clients = vim.lsp.get_clients({ bufnr = context.bufnr })

						for _, c in ipairs(clients) do
							print(c.name, c.config.cmd[1])
						end
						local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "tsserver" })

						if #clients == 0 then
							vim.notify(
								"Could not found `tsserver` lsp client, vue_lsp would not work without it.",
								vim.log.levels.ERROR
							)
							return
						end
						local ts_client = clients[1]

						local param = unpack(result)
						local id, command, payload = unpack(param)
						ts_client:exec_cmd({
							title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
							command = "typescript.tsserverRequest",
							arguments = {
								command,
								payload,
							},
						}, { bufnr = context.bufnr }, function(_, r)
							local response_data = { { id, r.body } }
							---@diagnostic disable-next-line: param-type-mismatch
							client:notify("tsserver/response", response_data)
						end)
					end
				end,
			}
			-- nvim 0.11 or above
			vim.lsp.config("tsserver", tsserver_config)
			vim.lsp.config("vue_ls", vue_ls_config)
			vim.lsp.enable({ "tsserver", "vue_ls" })
			vim.lsp.config("clangd", {
				cmd = { "clangd", "--background-index" },
				filetypes = { "c", "cpp", "objc", "objcpp" },
				-- root_dir = require('lspconfig.util').root_pattern("compile_commands.json", ".git")
			})
			vim.lsp.enable("clangd")

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {desc="definition"})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {desc="references"})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {desc="code action"})

			-- Only format TOML with taplo
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.toml",
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							return client.name == "taplo"
						end,
						async = false,
					})
				end,
			})
		end,
	},
}
