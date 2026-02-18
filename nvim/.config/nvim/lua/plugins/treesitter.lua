return {
    -- UFO Dependencies and Plugin
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        event = "BufReadPost", -- Load when you actually open a file
        init = function()
            -- These settings are highly recommended for ufo
            vim.o.foldcolumn = '1' -- '0' is also fine if you don't want the side bar
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        opts = {
            provider_selector = function(bufnr, filetype, buftype)
                return { "treesitter", "indent" }
            end,
        },
    },

    -- Treesitter Configuration
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                highlight = { enable = true },
                ensure_installed = {
                    "javascript",
                    "typescript",
                    "html",
                    "vue",
                    "lua", -- Highly recommended for editing your own config!
                },
            })
        end,
    },
}
