return {
	{
		"robitx/gp.nvim",
		config = function()
			local model = os.getenv("OPENAI_MODEL") or "gpt-4o-mini"
			local openai_api_key = os.getenv("OPENAI_API_KEY")
			local openai_api_endpoint = os.getenv("OPENAI_API_BASE") or "https://api.openai.com/v1"
			local trace = vim.fn.stdpath("cache") .. "/gp_curl_trace.log"
			vim.notify(trace)
			require("gp").setup({
				-- 推荐开启
				chat_confirm_delete = false,
				chat_dir = vim.fn.stdpath("data") .. "/gp_chats",
				providers = {
					openai = {
						disable = true,
						endpoint = openai_api_endpoint,
						secret = openai_api_key,
					},
					ollama = {
						endpoint = "http://localhost:11434/v1/chat/completions",
					},
				},
				curl_params = {
					-- "--noproxy",
					-- "*",
					"--trace-ascii",
					trace,
					"--trace-time",
				},
				default_command_agent = "ChatQwen3-8B",
				default_chat_agent = "ChatQwen3-8B",
				agents = {
					{ name = "ChatGPT4o", disable = true },
					{ name = "ChatGPT-o3-mini", disable = true },
					{ name = "ChatGPT4o-mini", disable = true },
					{ name = "CodeGPT4o", disable = true },
					{ name = "CodeGPT4o-mini", disable = true },
					{ name = "CodeGPT-o3-mini", disable = true },
					{
						provider = "ollama",
						name = "ChatQwen3-8B",
						chat = true,
						command = false,
						-- string with model name or table with model name and parameters
						model = {
							model = "qwen3:8b",
							think = false, -- toggle thinking mode for Ollama's thinking models
						},
						-- system prompt (use this to specify the persona/role of the AI)
						system_prompt = "You are a general AI assistant.",
					},
					{
						provider = "ollama",
						name = "ChatQwen2.5-7B",
						model = {
							model = "qwen2.5:7b",
							think = false,
						},
						chat = true,
						command = true,
						system_prompt = "you are a helpful assistant",
					},
				},
				hooks = {
					-- example of adding command which writes unit tests for the selected code
					UnitTests = function(gp, params)
						local template = "I have the following code from {{filename}}:\n\n"
							.. "```{{filetype}}\n{{selection}}\n```\n\n"
							.. "Please respond by writing table driven unit tests for the code above."
						local agent = gp.get_command_agent()
						gp.Prompt(params, gp.Target.vnew, agent, template)
					end,
					-- example of making :%GpChatNew a dedicated command which
					-- opens new chat with the entire current buffer as a context
					BufferChatNew = function(gp, _)
						-- call GpChatNew command in range mode on whole buffer
						vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
					end,
					-- example of adding command which opens new chat dedicated for translation
					Translator = function(gp, params)
						local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
						gp.cmd.ChatNew(params, chat_system_prompt)

						-- -- you can also create a chat with a specific fixed agent like this:
						-- local agent = gp.get_chat_agent("ChatGPT4o")
						-- gp.cmd.ChatNew(params, chat_system_prompt, agent)
					end,
					-- example of usig enew as a function specifying type for the new buffer
					CodeReview = function(gp, params)
						local template = "I have the following code from {{filename}}:\n\n"
							.. "```{{filetype}}\n{{selection}}\n```\n\n"
							.. "Please analyze for code smells and suggest improvements."
						local agent = gp.get_chat_agent()
						gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
					end,
					-- example of adding command which explains the selected code
					Explain = function(gp, params)
						local template = "I have the following code from {{filename}}:\n\n"
							.. "```{{filetype}}\n{{selection}}\n```\n\n"
							.. "Please respond by explaining the code above."
						local agent = gp.get_chat_agent()
						gp.Prompt(params, gp.Target.popup, agent, template)
					end,
					-- GpInspectPlugin provides a detailed inspection of the plugin state
					InspectPlugin = function(plugin, params)
						local bufnr = vim.api.nvim_create_buf(false, true)
						local copy = vim.deepcopy(plugin)
						local key = copy.config.openai_api_key or ""
						copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
						local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
						local params_info = string.format("Command params:\n%s", vim.inspect(params))
						local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
						vim.api.nvim_win_set_buf(0, bufnr)
					end,

					-- GpInspectLog for checking the log file
					InspectLog = function(plugin, params)
						local log_file = plugin.config.log_file
						local buffer = plugin.helpers.get_buffer(log_file)
						if not buffer then
							vim.cmd("e " .. log_file)
						else
							vim.cmd("buffer " .. buffer)
						end
					end,

					-- GpImplement rewrites the provided selection/range based on comments in it
					ReWrite = function(gp, params)
						local template = "Having following from {{filename}}:\n\n"
							.. "```{{filetype}}\n{{selection}}\n```\n\n"
							.. "Please rewrite this according to the contained instructions."
							.. "\n\nRespond exclusively with the snippet that should replace the selection above."

						local agent = gp.get_command_agent()
						gp.logger.info("Implementing selection with agent: " .. agent.name)

						gp.Prompt(
							params,
							gp.Target.rewrite,
							agent,
							template,
							nil, -- command will run directly without any prompting for user input
							nil -- no predefined instructions (e.g. speech-to-text from Whisper)
						)
					end,

					WriteCodeByComment = function(gp, params)
						local template = "You are an expert software engineer.\n\n"
							.. "The user writes a comment describing a function."
							.. "You must convert that comment into working code.\n\n"
							.. "Requirements:\n\n"
							.. "- Only output code \n\n"
							.. "- Follow the programming language used in the file\n\n"
							.. "- Follow the naming style in the file\n\n"
							.. "- Keep the code short and clean\n\n"
							.. "- Do not add explanations\n\n"
							.. "- If the comment starts with '#', treat it as a function requirement\n"
						local agent = gp.get_command_agent()
						gp.Prompt(params, gp.Target.vnew, agent, template)
					end,
				},
				-- 常用快捷键
				chat_shortcut = "<leader>ac",
				command_shortcut = "<leader>aa",
			})

			-- 我帮你补上最实用的快捷键

			vim.keymap.set("n", "<leader>asa", ":GpSelectAgent<CR>", { desc = "AI Selct agent" })
			vim.keymap.set("v", "<leader>arw", ":GpReWrite<CR>", { desc = "AI Rewrite Code" })
			vim.keymap.set("v", "<leader>aut", ":GpUnitTests<CR>", { desc = "AI unit test Code" })
			vim.keymap.set("v", "<leader>aex", ":GpExplain<CR>", { desc = "AI Explain Code" })
			vim.keymap.set("n", "<leader>ac", ":GpBufferChatNew split<CR>", { desc = "AI Chat" })
		end,
	},
	{
		"nickjvandyke/opencode.nvim",
		enabled = true,
		version = "*", -- Latest stable release
		dependencies = {
			{
				-- `snacks.nvim` integration is recommended, but optional
				---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
				"folke/snacks.nvim",
				optional = true,
				opts = {
					input = {}, -- Enhances `ask()`
					picker = { -- Enhances `select()`
						actions = {
							opencode_send = function(...)
								return require("opencode").snacks_picker_send(...)
							end,
						},
						win = {
							input = {
								keys = {
									["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
								},
							},
						},
					},
				},
			},
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- Your configuration, if any; goto definition on the type or field for details
			}

			vim.o.autoread = true -- Required for `opts.events.reload`

			-- Recommended/example keymaps
			vim.keymap.set({ "n", "x" }, "<C-a>", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask opencode…" })
			vim.keymap.set({ "n", "x" }, "<C-x>", function()
				require("opencode").select()
			end, { desc = "Execute opencode action…" })
			vim.keymap.set({ "n", "t" }, "<C-.>", function()
				require("opencode").toggle()
			end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "go", function()
				return require("opencode").operator("@this ")
			end, { desc = "Add range to opencode", expr = true })
			vim.keymap.set("n", "goo", function()
				return require("opencode").operator("@this ") .. "_"
			end, { desc = "Add line to opencode", expr = true })

			vim.keymap.set("n", "<S-C-u>", function()
				require("opencode").command("session.half.page.up")
			end, { desc = "Scroll opencode up" })
			vim.keymap.set("n", "<S-C-d>", function()
				require("opencode").command("session.half.page.down")
			end, { desc = "Scroll opencode down" })

			-- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
			vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
			vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
		end,
	},
}
