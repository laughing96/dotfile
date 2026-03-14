return {
    {
        "laughing96/vim-translator",
        lazy=true,
        config = function()
            -- 翻译插件快捷键
            vim.keymap.set("n", "<leader>tw", "<cmd>TranslateW<CR>", { desc = "Translate to window" })

            -- 自定义函数模块
            local M = {}

            function M.save_word_to_file()
                local filename = vim.fn.expand("$HOME/save_word.txt")
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                local line = vim.api.nvim_get_current_line()

                -- Lua 索引从 1 开始，col 从 0 开始，所以 +1
                local cursor_col = col + 1

                -- 匹配光标所在单词（向前向后都匹配）
                local s, e
                for word_start, word_end in line:gmatch("()(%w+)()") do
                    word_end = word_end - 1
                    if cursor_col >= word_start and cursor_col <= word_end then
                        s, e = word_start, word_end
                        break
                    end
                end

                if not s then
                    vim.notify("光标不在单词上", vim.log.levels.WARN)
                    return
                end

                local word = line:sub(s, e)

                -- 追加写入文件
                local file = io.open(filename, "a")
                if not file then
                    vim.notify("无法打开文件: " .. filename, vim.log.levels.ERROR)
                    return
                end
                file:write(word .. "\n")
                file:close()

                vim.notify("已保存单词 '" .. word .. "' 到 " .. filename)
            end

            -- 全局引用模块
            _G.save_word_module = M

            -- 快捷键 <leader>ts 保存光标单词
            vim.keymap.set("n", "<leader>ts", function()
                _G.save_word_module.save_word_to_file()
            end, { noremap = true, silent = true })
        end,
    },
}
