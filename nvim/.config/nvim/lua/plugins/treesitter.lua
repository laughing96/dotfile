return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = {
         auto_install = true,
         highlight = { enable = true },
         indent = { enable = true },

  }
}
