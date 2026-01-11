return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        {
            "folke/flash.nvim",
            event = "VeryLazy",
            opts = {},
            keys = {
                {
                    "s",
                    mode = { "n", "x", "o" },
                    function()
                        require("flash").jump()
                    end,
                    desc = "Flash",
                },
                {
                    "S",
                    mode = { "n", "x", "o" },
                    function()
                        require("flash").treesitter()
                    end,
                    desc = "Flash Treesitter",
                },
                {
                    "r",
                    mode = "o",
                    function()
                        require("flash").remote()
                    end,
                    desc = "Remote Flash",
                },
                {
                    "R",
                    mode = { "o", "x" },
                    function()
                        require("flash").treesitter_search()
                    end,
                    desc = "Treesitter Search",
                },
                {
                    "<c-s>",
                    mode = { "c" },
                    function()
                        require("flash").toggle()
                    end,
                    desc = "Toggle Flash Search",
                },
            },
        },
    },
}
