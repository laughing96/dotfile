-- local maven_setting_path = ""
return {
	--------------------------------------------------
	-- MAVEN
	--------------------------------------------------
	{
		"eatgrass/maven.nvim",
		cmd = { "Maven", "MavenExec" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		config = function()
			require("maven").setup({
				executable = "mvn",
				cwd = nil,
				settings = nil,
                -- settings = maven_setting_path,

				commands = {
					{
						cmd = { "clean", "compile" },
						desc = "clean then compile",
					},
				},
			})
		end,
	},

	--------------------------------------------------
	-- JAVA / JDTLS
	--------------------------------------------------
	{
		"mfussenegger/nvim-jdtls",

		ft = "java",

		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			"mason-org/mason.nvim",
		},

		config = function()
			local jdtls = require("jdtls")
			local util = require("lspconfig.util")
			local dap = require("dap")

			--------------------------------------------------
			-- PATHS
			--------------------------------------------------

			local mason = vim.fn.stdpath("data") .. "/mason/packages"
			local jdtls_path = mason .. "/jdtls"

			local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

			--------------------------------------------------
			-- JDTLS PLATFORM CONFIG
			--------------------------------------------------

			local config_os

			if vim.fn.has("mac") == 1 then
				local arm = jdtls_path .. "/config_mac_arm"

				if vim.fn.has("arm64") == 1 and vim.fn.isdirectory(arm) == 1 then
					config_os = arm
				else
					config_os = jdtls_path .. "/config_mac"
				end
			elseif vim.fn.has("win32") == 1 then
				config_os = jdtls_path .. "/config_win"
			else
				config_os = jdtls_path .. "/config_linux"
			end

			--------------------------------------------------
			-- DEBUG / TEST BUNDLES
			--------------------------------------------------

			local bundles = {}

			-- Java Debug Adapter
			local debug_bundle =
				vim.fn.glob(mason .. "/java-debug-adapter/extension/server/" .. "com.microsoft.java.debug.plugin-*.jar")

			if debug_bundle ~= "" then
				vim.list_extend(bundles, vim.split(debug_bundle, "\n"))
			end

			-- Java Test
			local test_bundles = vim.fn.glob(mason .. "/java-test/extension/server/*.jar", true, true)

			vim.list_extend(bundles, test_bundles)

			--------------------------------------------------
			-- ROOT DIRECTORY
			--------------------------------------------------

			local bufname = vim.api.nvim_buf_get_name(0)

			local root_dir = util.root_pattern("pom.xml", "gradlew", "mvnw", ".git")(bufname)
				or vim.fn.fnamemodify(bufname, ":h")

			--------------------------------------------------
			-- WORKSPACE
			--------------------------------------------------

			local project = vim.fn.fnamemodify(root_dir, ":t")

			local workspace = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project

			vim.fn.mkdir(workspace, "p")

			--------------------------------------------------
			-- JDTLS COMMAND
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
			-- JDTLS CONFIG
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
-- maven = {
--                 userSettings = vim.fn.expand("~/.m2/settings.xml"),
--             },
						},

						references = {
							includeDecompiledSources = true,
						},
					},
				},
			}

			--------------------------------------------------
			-- START JDTLS
			--------------------------------------------------

			jdtls.start_or_attach(config)

			--------------------------------------------------
			-- DAP
			--------------------------------------------------

			jdtls.setup_dap({
				hotcodereplace = "auto",
			})

			--------------------------------------------------
			-- JAVA DAP CONFIGURATION
			--------------------------------------------------

			dap.configurations.java = {
				{
					type = "java",
					request = "launch",
					name = "Launch Java",

					mainClass = function()
						return vim.fn.input("Main class: ")
					end,
				},
			}

			--------------------------------------------------
			-- KEYMAPS
			--------------------------------------------------

			-- Organize imports
			vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, {
				desc = "Organize imports",
				buffer = true,
			})

			-- Compile
			vim.keymap.set("n", "<leader>jc", function()
				jdtls.compile("full")
			end, {
				desc = "Compile Java",
				buffer = true,
			})

			-- Run main class
			vim.keymap.set("n", "<leader>jR", function()
				local file = vim.api.nvim_buf_get_name(0)
				local dir = vim.fn.fnamemodify(file, ":h")
				local class = vim.fn.fnamemodify(file, ":t:r")

				-- Read package declaration
				local package = nil

				for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 30, false)) do
					local p = line:match("^%s*package%s+([%w%.]+)%s*;")
					if p then
						package = p
						break
					end
				end

				local main_class = package and (package .. "." .. class) or class

				-- Standalone Java file
				local root = vim.fn.fnamemodify(vim.fn.findfile("pom.xml", ".;" .. vim.fn.getcwd()), ":h")

				if root == "." or root == "" then
					root = nil
				end

				if not root then
					vim.cmd("botright split | terminal")

					local cmd = "cd "
						.. vim.fn.shellescape(dir)
						.. " && javac "
						.. vim.fn.shellescape(file)
						.. " && java "
						.. vim.fn.shellescape(main_class)
						.. "\n"

					vim.fn.chansend(vim.b.terminal_job_id, cmd)

					return
				end

				-- Maven project
				require("dap").run({
					type = "java",
					request = "launch",
					name = "Run Java",
					mainClass = main_class,
				})
			end, {
				desc = "Run Java",
				buffer = true,
			})

			vim.keymap.set("n", "<leader>jr", function()
				local root = vim.fs.root(0, {
					"pom.xml",
					"build.gradle",
					"build.gradle.kts",
				})

				if not root then
					vim.notify("Java project root not found", vim.log.levels.ERROR)
					return
				end

				local config_file = root .. "/.nvim/java.lua"

				local main_class

				-- If .nvim/java.lua exists, use the configured mainClass.
				if vim.fn.filereadable(config_file) == 1 then
					local ok, project_config = pcall(dofile, config_file)

					if not ok then
						vim.notify("Failed to load " .. config_file .. "\n" .. project_config, vim.log.levels.ERROR)
						return
					end

					main_class = project_config.mainClass

					if not main_class then
						vim.notify("mainClass is not configured in .nvim/java.lua", vim.log.levels.WARN)
					end
				else
					-- No .nvim/java.lua: notify the user and ask for mainClass.
					vim.notify("No .nvim/java.lua found. Please enter the main class.", vim.log.levels.WARN)
				end

				-- Ask the user when no configured mainClass is available.
				if not main_class or main_class == "" then
                    vim.notify("Main class is required", vim.log.levels.ERROR)
					main_class = vim.fn.input("Main class: ")

					if main_class == "" then
						vim.notify("Main class is required", vim.log.levels.ERROR)
						return
					end
				end

				require("dap").run({
					type = "java",
					request = "launch",
					name = "Run Java",
					mainClass = main_class,
				})
			end, {
				desc = "Run Java project",
				buffer = true,
			})

			--#region
			-- vim.keymap.set("n", "<leader>jr", function()
			-- 	dap.run({
			-- 		type = "java",
			-- 		request = "launch",
			-- 		name = "Run Java",
			--
			-- 		mainClass = function()
			-- 			return vim.fn.input("Main class: ")
			-- 		end,
			-- 	})
			-- end, {
			-- 	desc = "Run Java main",
			-- 	buffer = true,
			-- })
			-- --
			-- Debug main class
			vim.keymap.set("n", "<leader>jd", function()
				dap.run({
					type = "java",
					request = "launch",
					name = "Debug Java",

					mainClass = function()
						return vim.fn.input("Main class: ")
					end,
				})
			end, {
				desc = "Debug Java main",
				buffer = true,
			})

			-- Debug test class
			vim.keymap.set("n", "<leader>jD", jdtls.test_class, {
				desc = "Debug test class",
				buffer = true,
			})

			-- Run nearest test
			vim.keymap.set("n", "<leader>jt", jdtls.test_nearest_method, {
				desc = "Run nearest test",
				buffer = true,
			})
		end,
	},
}
