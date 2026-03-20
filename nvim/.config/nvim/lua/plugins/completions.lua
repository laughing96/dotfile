return {
	-- {
	-- 	"hrsh7th/cmp-nvim-lsp",
	-- 	lazy = false,
	-- },
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					numbers = "none",
					max_name_length = 18,
					max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
					tab_size = 18,
					diagnostics = "nvim_lsp",
					diagnostics_update_in_insert = false,
					show_buffer_icons = true,
					show_buffer_close_icons = true,
					show_close_icon = false,
					show_tab_indicators = true,
				},
			})

			vim.keymap.set("n", "<leader>bfn", "<Cmd>BufferLineCycleNext<CR>", { desc = "BufferLineCycleNext" })
			vim.keymap.set("n", "<leader>bfp", "<Cmd>BufferLineCyclePrev<CR>", { desc = "BufferLineCyclePrev" })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				-- disable_filetype = { "TelescopePrompt", "spectre_panel" },
			})
		end,
	},
	{
		"supermaven-inc/supermaven-nvim",
        disable = true,
		event = "InsertEnter",

		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>", -- 用 Tab 接受 AI 补全
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
			})
		end,
	},
	-- {
	-- 	"monkoose/neocodeium",
	-- 	event = false,
	-- 	config = function()
	-- 		local neocodeium = require("neocodeium")
	-- 		neocodeium.setup({
	-- 			manual = true,
	-- 		})
	-- 		vim.keymap.set("i", "<A-e>", function()
	-- 			neocodeium.cycle_or_complete()
	-- 		end)
	-- 		vim.keymap.set("i", "<A-f>", neocodeium.accept)
	-- 	end,
	-- },
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "super-tab",
				["<Tab>"] = {
					"select_next",
					"snippet_forward",
					"fallback",
				},

				["<S-Tab>"] = {
					"select_prev",
					"snippet_backward",
					"fallback",
				},

				["<CR>"] = { "accept", "fallback" },

				["<C-Space>"] = { "show", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = { documentation = { auto_show = true } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	dependencies = {
	-- 		"neovim/nvim-lspconfig",
	-- 		"hrsh7th/cmp-nvim-lsp",
	-- 		"hrsh7th/cmp-buffer",
	-- 		"hrsh7th/cmp-path",
	-- 		"hrsh7th/cmp-cmdline",
	-- 		"onsails/lspkind.nvim",
	-- 		"monkoose/neocodeium",
	-- 	},
	-- 	config = function()
	-- 		local cmp = require("cmp")
	-- 		local ls = require("luasnip")
	-- 		local neocodeium = require("neocodeium")
	-- 		local commands = require("neocodeium.commands")
	-- 		require("luasnip.loaders.from_vscode").lazy_load()
	-- 		-- python
	-- 		ls.add_snippets("python", {
	-- 			ls.snippet("sec", {
	-- 				ls.text_node("# " .. string.rep("-", 8) .. " "),
	-- 				ls.insert_node(1, "HEADER"),
	-- 				ls.text_node(" " .. string.rep("-", 40)),
	-- 			}),
	-- 		})
	-- 		cmp.event:on("menu_opened", function()
	-- 			neocodeium.clear()
	-- 		end)
	--
	-- 		neocodeium.setup({
	-- 			filter = function()
	-- 				return not cmp.visible()
	-- 			end,
	-- 		})
	--
	-- 		-- create an autocommand which closes cmp when ai completions are displayed
	-- 		vim.api.nvim_create_autocmd("User", {
	-- 			pattern = "NeoCodeiumCompletionDisplayed",
	-- 			callback = function()
	-- 				require("cmp").abort()
	-- 			end,
	-- 		})
	--
	-- 		-- set up some sort of keymap to cycle and complete to trigger completion
	-- 		cmp.setup({
	-- 			performance = {
	-- 				max_view_entries = 8, -- ⭐ 最多显示8条
	-- 			},
	-- 			completion = {
	-- 				keyword_length = 2, -- 至少2个字符才触发
	-- 				-- autocomplete = false,
	-- 			},
	-- 			snippet = {
	-- 				expand = function(args)
	-- 					ls.lsp_expand(args.body)
	-- 				end,
	-- 			},
	-- 			window = {
	-- 				completion = cmp.config.window.bordered(),
	-- 				documentation = cmp.config.window.bordered(),
	-- 			},
	-- 			formatting = {
	-- 				-- fields 决定了补全菜单中内容的排列顺序
	-- 				fields = { "kind", "abbr", "menu" },
	-- 				format = require("lspkind").cmp_format({
	-- 					mode = "symbol_text", -- 强烈建议用 symbol_text，左边图标右边文字，很有 IDEA 感
	-- 					maxwidth = 50,
	-- 					ellipsis_char = "...",
	-- 					symbol_map = {
	-- 						Codeium = "",
	-- 						Snippet = "", -- 为代码片段增加识别度
	-- 					},
	-- 					before = function(entry, vim_item)
	-- 						-- 在这里可以为不同的 Source 加上来源标签
	-- 						local menu_map = {
	-- 							nvim_lsp = "[LSP]",
	-- 							luasnip = "[Snip]",
	-- 							codeium = "[AI]",
	-- 							buffer = "[Buf]",
	-- 							path = "[Path]",
	-- 						}
	--
	-- 						vim_item.menu = menu_map[entry.source.name]
	--
	-- 						-- ⭐ AI 高亮一点（关键）
	-- 						if entry.source.name == "codeium" then
	-- 							vim_item.kind = " AI"
	-- 						end
	--
	-- 						return vim_item
	-- 					end,
	-- 				}),
	-- 			},
	-- 			mapping = cmp.mapping.preset.insert({
	-- 				["<C-e>"] = cmp.mapping.abort(),
	-- 				-- 手动触发补全
	-- 				["<C-Space>"] = cmp.mapping.complete(),
	-- 				["<CR>"] = cmp.mapping.confirm({ select = true }),
	-- 				["<Tab>"] = cmp.mapping(function(fallback)
	-- 					-- 1️⃣ Codeium 有建议 → 优先接受
	-- 					-- local vt = require("codeium.virtual_text")
	-- 					-- -- if vt and vt.get_current_completion_item() ~= nil then
	-- 					-- -- 	vt.accept()
	-- 					-- -- 	return
	-- 					-- -- end
	--
	-- 					-- 2️⃣ cmp 菜单存在 → 选下一个
	-- 					if cmp.visible() then
	-- 						cmp.select_next_item()
	-- 						return
	-- 					end
	--
	-- 					-- 3️⃣ snippet 可跳 → 跳
	-- 					if ls.expand_or_jumpable() then
	-- 						ls.expand_or_jump()
	-- 						return
	-- 					end
	-- 					-- 4️⃣ fallback
	-- 					fallback()
	-- 				end, { "i", "s" }),
	-- 				["<S-Tab>"] = cmp.mapping(function(fallback)
	-- 					if cmp.visible() then
	-- 						cmp.select_prev_item()
	-- 						return
	-- 					end
	--
	-- 					if ls.jumpable(-1) then
	-- 						ls.jump(-1)
	-- 						return
	-- 					end
	--
	-- 					fallback()
	-- 				end, { "i", "s" }),
	-- 			}),
	-- 			sources = cmp.config.sources({
	-- 				{ name = "codeium", priority = 1000 },
	-- 				{ name = "nvim_lsp", priority = 600, max_item_count = 5 },
	-- 				{ name = "luasnip", priority = 500, max_item_count = 3 },
	-- 				{ name = "buffer", max_item_count = 3 },
	-- 			}),
	-- 		})
	-- 	end,
	-- },
}
