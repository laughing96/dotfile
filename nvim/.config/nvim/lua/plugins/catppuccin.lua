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
  }
}
