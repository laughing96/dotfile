return {
    {
        "robitx/gp.nvim",
        config = function()
            require("gp").setup({
                openai_api_key = os.getenv("OPENAI_API_KEY"),

                -- 支持 OpenAI 兼容接口（比如自建 API / 反向代理 / 其它模型）
                openai_api_endpoint = os.getenv("OPENAI_API_BASE") or "https://api.openai.com/v1",

                -- 默认模型
                model = os.getenv("OPENAI_MODEL") or "gpt-4o-mini",

                -- 推荐开启
                chat_confirm_delete = false,
                chat_dir = vim.fn.stdpath("data") .. "/gp_chats",

                -- 常用快捷键
                chat_shortcut = "<leader>ac",
                command_shortcut = "<leader>aa",
            })

            -- 我帮你补上最实用的快捷键
            vim.keymap.set("v", "<leader>af", ":GpRewrite<CR>", { desc = "AI Rewrite Code" })
            vim.keymap.set("v", "<leader>ae", ":GpExplain<CR>", { desc = "AI Explain Code" })
            vim.keymap.set("v", "<leader>ai", ":GpImprove<CR>", { desc = "AI Improve Code" })
            vim.keymap.set("n", "<leader>ac", ":GpChatNew<CR>", { desc = "AI Chat" })
        end,
    },
    {
        "nickjvandyke/opencode.nvim",
        enabled = false,
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
