return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("dapui").setup({
			layouts = {
				{
					-- 底部：只放 repl（调试交互）
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size = 20,
					position = "bottom",
				},
			},
			floating = {
				border = "rounded",
			},
		})
		require("dap-python").setup(vim.g.python3_host_prog)
		require("dap-python").test_runner = "pytest"

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		-- dap.listeners.before.event_terminated.dapui_config = function()
		-- 	dapui.close({ layout = 1 })
		-- end
		-- dap.listeners.before.event_exited.dapui_config = function()
		-- 	dapui.close({ layout = 1 })
		-- end

		vim.keymap.set({ "n", "v" }, "<leader>dw", function()
			local expr
			if vim.fn.mode():match("v") then
				vim.cmd('normal! "vy')
				expr = vim.fn.getreg("v")
			else
				expr = vim.fn.expand("<cword>")
			end
			dapui.elements.watches.add(expr)
		end, { silent = true })

		vim.keymap.set({ "n", "v" }, "<leader>de", function()
			dapui.eval()
		end, { silent = true })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {desc='toggle breakpoint'})
		vim.keymap.set("n", "<leader>dc", dap.continue, {desc='continue'})
		vim.keymap.set("n", "<leader>ds", dap.step_over, {desc='step over'})
		vim.keymap.set("n", "<leader>di", dap.step_into, {desc='step into'})
		vim.keymap.set("n", "<leader>do", dap.step_out, {desc='step out'})
		vim.keymap.set("n", "<leader>dr", dap.repl.open, {desc='repl open'})
		vim.keymap.set("n", "<leader>dd", function()
			dap.terminate()
			dapui.close()
			-- dap.clear_breakpoints()
		end, { desc = "dap terminate " })

        --------
        --- dap ui
        --------
		vim.keymap.set("n", "<leader>dpu", function()
			dapui.toggle()
		end, { desc = "DAP UI Toggle" })

		vim.keymap.set("n", "<leader>dps", function()
			dapui.float_element("stacks")
			dapui.float_element("stacks")
		end, { desc = "DAP Stacks" })
		vim.keymap.set("n", "<leader>dpw", function()
			dapui.float_element("watches")
			dapui.float_element("watches")
		end, { desc = "DAP Watches" })
		vim.keymap.set("n", "<leader>dpc", function()
			dapui.float_element("console")
			dapui.float_element("console")
		end, { desc = "console" })

		vim.keymap.set("n", "<leader>dpr", function()
			dapui.float_element("repl")
			dapui.float_element("repl")
		end, { desc = "repl（调试交互）" })
		vim.keymap.set("n", "<leader>dpo", function()
			dapui.float_element("scopes")
			dapui.float_element("scopes")
		end, { desc = "availabe scopes and variables" })

		vim.keymap.set("n", "<leader>dpb", function()
			dapui.float_element("brekpoints")
			dapui.float_element("breakpoints")
		end, { desc = "DAP Breakpoints" })
	end,
}
