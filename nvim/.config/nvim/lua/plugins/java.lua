return {
    ----
    ---maven
    -----
    -- {
    --     "eatgrass/maven.nvim",
    --     cmd = { "Maven", "MavenExec" },
    --     dependencies = "nvim-lua/plenary.nvim",
    --     config = function()
    --         require("maven").setup({
    --             executable = "mvn", -- `mvn` should be in your `PATH`, or the path to the maven exectable, for example `./mvnw`
    --             cwd = nil, -- work directory, default to `vim.fn.getcwd()`
    --             settings = nil, -- specify the settings file or use the default settings
    --             commands = { -- add custom goals to the command list
    --                 { cmd = { "clean", "compile" }, desc = "clean then compile" },
    --             },
    --         })
    --     end,
    -- },
    --------------------------------------------------
    -- JAVA
    --------------------------------------------------
    {
        "mfussenegger/nvim-jdtls",

        ft = "java",

        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            "williamboman/mason.nvim",
        },

        config = function()
            local jdtls = require("jdtls")
            local util = require("lspconfig.util")

            --------------------------------------------------
            -- PATHS
            --------------------------------------------------
            local mason = vim.fn.stdpath("data") .. "/mason/packages"

            local jdtls_path = mason .. "/jdtls"

            local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

            local config_os = vim.fn.has("mac") == 1 and jdtls_path .. "/config_mac" or jdtls_path .. "/config_linux"

            --------------------------------------------------
            -- DEBUG + TEST bundles
            --------------------------------------------------
            local bundles = {}

            vim.list_extend(
                bundles,
                vim.split(
                    vim.fn.glob(mason .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
                    "\n"
                )
            )

            vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/java-test/extension/server/*.jar"), "\n"))

            --------------------------------------------------
            -- ROOT (Maven support)
            --------------------------------------------------
            local root_dir = util.root_pattern("pom.xml", "gradlew", "mvnw", ".git")(vim.fn.getcwd())

            if root_dir == nil then
                return
            end

            --------------------------------------------------
            -- WORKSPACE
            --------------------------------------------------
            local project = vim.fn.fnamemodify(root_dir, ":p:h:t")

            local workspace = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project

            vim.fn.mkdir(workspace, "p")

            --------------------------------------------------
            -- CMD
            --------------------------------------------------
            local cmd = {

                "java",

                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",

                "-Dlog.protocol=true",
                "-Dlog.level=ALL",

                "-Xmx4g",

                "--add-modules=ALL-SYSTEM",
                "--add-opens",
                "java.base/java.util=ALL-UNNAMED",
                "--add-opens",
                "java.base/java.lang=ALL-UNNAMED",

                "-jar",
                launcher,

                "-configuration",
                config_os,

                "-data",
                workspace,
            }

            --------------------------------------------------
            -- CONFIG
            --------------------------------------------------
            local config = {

                cmd = cmd,

                root_dir = root_dir,

                init_options = {
                    bundles = bundles,
                },

                settings = {

                    java = {

                        maven = {
                            downloadSources = true,
                            updateSnapshots = true,
                        },

                        configuration = {
                            updateBuildConfiguration = "interactive",
                        },

                        references = {
                            includeDecompiledSources = true,
                        },
                    },
                },
            }

            --------------------------------------------------
            -- START
            --------------------------------------------------
            jdtls.start_or_attach(config)

            jdtls.setup_dap({
                hotcodereplace = "auto",
            })

            --------------------------------------------------
            -- KEYMAPS
            --------------------------------------------------
            vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { desc = "Organize imports" })

            vim.keymap.set("n", "<leader>jc", function()
                jdtls.compile("full")
            end)

            vim.keymap.set("n", "<leader>jr", function()
                require("jdtls").run_main_class()
            end, { desc = "Run main class" })

            vim.keymap.set("n", "<leader>jd", function()
                require("jdtls").debug_main_class()
            end, { desc = "Debug main class" })
            -- vim.keymap.set("n", "<leader>jd", jdtls.test_nearest_method, { desc = "Debug test" })

            vim.keymap.set("n", "<leader>jD", jdtls.test_class, { desc = "Debug class" })
        end,
    },
}
