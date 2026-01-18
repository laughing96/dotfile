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
                    -- 左侧：只放 scopes（变量）
                    elements = {
                        { id = "scopes", size = 1.0 },
                    },
                    size = 40,
                    position = "left",
                },
                {
                    -- 底部：只放 repl（调试交互）
                    elements = {
                        { id = "console", size = 1.0 },
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
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close({ layout = 1 })
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close({ layout = 1 })
        end

        vim.keymap.set("n", "<leader>dw", function()
            dapui.elements.watches.add(vim.fn.expand("<cword>"))
        end, { silent = true })
        vim.keymap.set("n", "<leader>de", function()
            dapui.eval()
        end, { silent = true })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})
        vim.keymap.set("n", "<leader>dc", dap.continue, {})
        vim.keymap.set("n", "<leader>ds", dap.step_into, {})
        vim.keymap.set("n", "<leader>dd", function()
            dap.terminate()
            dapui.close()
            -- dap.clear_breakpoints()
        end, { desc = "dap terminate " })

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
        vim.keymap.set("n", "<leader>dpb", function()
            dapui.float_element("breakpoints")
            dapui.float_element("breakpoints")
        end, { desc = "DAP Breakpoints" })
    end,
}
