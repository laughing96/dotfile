return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup({
                ensure_installed = { "java-debug-adapter", "java-test" },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        dependencies = { { "mason-org/mason.nvim", opts = {} }, "neovim/nvim-lspconfig" },
        opts = {
            auto_install = true,
            ensure_installed = { "lua_ls", "clangd", "ty", "ruff", "vue_ls", "ts_ls", "jdtls", "taplo", "harper_ls" },
        },
    },
    -- {
    -- 	"simrat39/rust-tools.nvim",
    -- 	config = function()
    -- 		vim.lsp.config["rust-tools"] = {
    -- 			server = {
    -- 				settings = {
    -- 					["rust-analyzer"] = {
    -- 						cargo = { allFeatures = true },
    -- 						checkOnSave = true,
    -- 						["checkOnSave.command"] = "clippy",
    -- 						procMacro = { enable = true },
    -- 					},
    -- 				},
    -- 			},
    -- 		}
    -- 		vim.lsp.enable("rust-tools")
    -- 	end,
    -- },
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
            -- TOML (taplo)
            vim.lsp.config["taplo"] = {
                capabilities = capabilities,
                filetypes = { "toml" },
            }
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

            -- Harper (disable formatting so it doesn't fight taplo)
            -- English
            vim.lsp.config["harper_ls"] = {
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                end,
            }

            -- vue
            local vue_language_server_path = vim.fn.stdpath("data")
                .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

            local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
            local vue_plugin = {
                name = "@vue/typescript-plugin",
                location = vue_language_server_path,
                languages = { "vue" },
                configNamespace = "typescript",
            }
            local vtsls_config = {
                settings = {
                    vtsls = {
                        tsserver = {
                            globalPlugins = {
                                vue_plugin,
                            },
                        },
                    },
                },
                filetypes = tsserver_filetypes,
            }

            local ts_ls_config = {
                init_options = {
                    plugins = {
                        vue_plugin,
                    },
                },
                filetypes = tsserver_filetypes,
            }

            -- If you are not on most recent `nvim-lspconfig` or you want to override
            local vue_ls_config = {
                on_init = function(client)
                    client.handlers["tsserver/request"] = function(_, result, context)
                        local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "ts_ls" })
                        local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
                        local clients = {}

                        vim.list_extend(clients, ts_clients)
                        vim.list_extend(clients, vtsls_clients)

                        if #clients == 0 then
                            vim.notify(
                                "Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.",
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
                            local response = r and r.body
                            -- TODO: handle error or response nil here, e.g. logging
                            -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
                            local response_data = { { id, response } }

                            ---@diagnostic disable-next-line: param-type-mismatch
                            client:notify("tsserver/response", response_data)
                        end)
                    end
                end,
            }
            -- nvim 0.11 or above
            vim.lsp.config("vtsls", vtsls_config)
            vim.lsp.config("vue_ls", vue_ls_config)
            vim.lsp.config("ts_ls", ts_ls_config)

            -- python
            local util = require("lspconfig.util")

            -- vim.lsp.config("pyright", {
            -- 	root_dir = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(
            -- 		vim.fn.getcwd()
            -- 	),
            -- 	settings = {
            -- 		python = {
            -- 			analysis = {
            -- 				-- 核心配置：开启自动导入提示
            -- 				autoImportCompletions = true,
            -- 				typeCheckingMode = "basic", -- 或者 "standard"
            -- 				indexing = true,
            -- 			},
            -- 		},
            -- 	},
            -- })
            --
            -- vim.lsp.enable("pyright")
            vim.lsp.config("clangd", {
                cmd = { "clangd", "--background-index" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                -- root_dir = require('lspconfig.util').root_pattern("compile_commands.json", ".git")
            })
            vim.lsp.enable("clangd")
            vim.lsp.enable({
                "ruff",
                "ty",
                --"basedpyright"
            })
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("harper_ls")
            vim.lsp.enable({ "ts_ls", "vue_ls" }) -- If using `ts_ls` replace `vtsls` to `ts_ls`
            vim.lsp.enable("taplo")

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "hover" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "definition" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "references" })
            vim.keymap.set("n", "<leader>gI", vim.lsp.buf.implementation, { desc = "Implementation" })
            vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Declaration" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "code action" })
            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "format code" })
            vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "Signature help" })
            vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run CodeLens" })
            vim.keymap.set(
                "n",
                "<leader>go",
                vim.diagnostic.open_float,
                { desc = "open diagnostic float",}
            )
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvimtools/none-ls-extras.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua, --Lua 代码格式化工具，用于格式化 .lua 文件。
                    -- null_ls.builtins.formatting.isort, --Python 导入排序工具（整理 import 顺序）。
                    null_ls.builtins.formatting.black, --Python 代码格式化工具 会改代码
                    null_ls.builtins.formatting.clang_format, --C/C++/Objective-C 代码格式化
                    -- null_ls.builtins.code_actions.ruff, --Python 修复import
                    null_ls.builtins.formatting.prettier, --JS/TS/HTML/CSS 等前端代码格式化。
                    null_ls.builtins.formatting.google_java_format, --Java 代码格式化

                    -- null_ls.builtins.diagnostics.eslint_d, --（快速版本 eslint_d） → JavaScript/TypeScript 语法和风格检查（诊断）
                    null_ls.builtins.code_actions.gitsigns, --通过 Git 状态提供 stage hunk, reset hunk 等动作，作为 LSP code actions

                    -- require("none-ls.diagnostics.flake8"), --不修改代码，只报告问题
                },
            })

            -- vim.keymap.set("n", "<leader>d[", vim.diagnostic.goto_prev, { noremap = true, silent = true })
            -- vim.keymap.set("n", "<leader>d]", vim.diagnostic.goto_next, { noremap = true, silent = true })
            -- vim.keymap.set("n", "<leader>dd", vim.diagnostic.setloclist, { noremap = true, silent = true })
        end,
    },
}
