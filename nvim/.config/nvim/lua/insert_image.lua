local function smart_image_insert()
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- 获取光标所在的行和位置
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before_cursor = line:sub(1, col)

    -- 判断是插入图片链接还是普通链接
    local is_image = before_cursor:match("!%[.-%]$")
    local find_command = { "fd", "--type", "f" }
    
    if is_image then
        -- 如果是 ![] 则只搜寻图片格式
        find_command = { "fd", "--type", "f", "-e", "png", "-e", "jpg", "-e", "jpeg", "-e", "gif", "-e", "webp", "-e" ,"heif", }
    end

    builtin.find_files({
        prompt_title = is_image and "插入图片" or "插入链接",
        find_command = find_command,
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                
                -- 构造插入文本：如果前面没写括号则补齐，如果写了则只填路径
                local path = selection.value
                local insert_text = "(" .. path .. ")"
                
                -- 如果光标前已经有 '('，我们就不重复补括号
                if before_cursor:sub(-1) == "(" then
                    insert_text = path .. ")"
                end

                vim.api.nvim_put({ insert_text }, "c", true, true)
            end)
            return true
        end,
    })
end

-- 绑定快捷键（插入模式下按 <C-g> 触发）
vim.keymap.set("i", "<C-g>", smart_image_insert, { desc = "智能插入图片/链接" })
