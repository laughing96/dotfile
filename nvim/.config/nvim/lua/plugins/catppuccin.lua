-- return {
--   {
--     "catppuccin/nvim",
--     lazy = false,
--     name = "catppuccin",
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme "catppuccin-mocha"
--     end
--   }
-- }
--
return {
    {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = {
                    treesitter = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                    },
                    -- 既然你用了 ufo，建议也开启这个
                    nvim_ufo = true,
                },
                custom_highlights = function(colors)
                    return {
                        -- 普通行号
                        LineNr = { fg = colors.overlay1 },
                        -- 当前行行号
                        CursorLineNr = { fg = colors.peach, style = { "bold" } },
                        -- relativenumber 用
                        LineNrAbove = { fg = colors.overlay1 },
                        LineNrBelow = { fg = colors.overlay1 },
                    }
                end,
            })

            vim.cmd.colorscheme("catppuccin-mocha")
        end,
    },
}
