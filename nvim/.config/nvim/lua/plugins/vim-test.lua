return {
    "vim-test/vim-test",
    dependencies = {
        "preservim/vimux"
    },

    config = function()
        vim.g["test#enabled_runner"] = { "python#pytest" }
        vim.g["test#strategy"] = "vimux"
        vim.g["test#python#runner"] = "pytest"
        vim.g["test#python#pytest#options"] = {
            nearest = "--color yes -lsxvv",
            file = "--color yes --durations=10 -qk ''",
            suite = "--color yes --durations=10 -qk ''",
        }

        vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
        vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
        vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
        vim.keymap.set("n", "<leader>l", ":TestLast<CR>", {})
        -- vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})
        vim.cmd("let test#strategy = 'vimux'")
    end,
}
