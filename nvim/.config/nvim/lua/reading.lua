-- =========================================
-- reading.lua
-- Markdown 阅读 / 批注 工作流
-- Sidecar Notes + Git Worktree
-- worktree dir: wt-anno
-- =========================================

local M = {}

-- ---------- 固定配置 ----------
local ANNO_DIR = "wt-anno"

-- ---------- 工具函数 ----------

local function is_markdown()
	return vim.fn.expand("%:e") == "md"
end

local function is_notes()
	return vim.fn.expand("%:t"):match("%.notes%.md$") ~= nil
end

local function in_annotate()
	return vim.fn.getcwd():match(ANNO_DIR:gsub("%-", "%%-")) ~= nil
end

-- ---------- Sidecar Notes ----------

function M.open_notes()
	if not is_markdown() then
		vim.notify("Not a markdown file", vim.log.levels.WARN)
		return
	end

	local src = vim.fn.expand("%:p")
	local notes = src:gsub("%.md$", ".notes.md")
	local exists = vim.fn.filereadable(notes) == 1

	vim.cmd("edit " .. vim.fn.fnameescape(notes))

	if not exists then
		vim.api.nvim_buf_set_lines(0, 0, -1, false, {
			"# Notes for " .. vim.fn.expand("%:t"),
			"",
			"## 阅读目标",
			"",
			"## 逐段批注",
			"",
			"## 问题汇总",
			"- ❓",
		})
	end
end

function M.open_notes_with_line()
	if not is_markdown() then
		return
	end

	local line = vim.fn.line(".")
	local src = vim.fn.expand("%:p")
	local notes = src:gsub("%.md$", ".notes.md")

	vim.cmd("edit " .. vim.fn.fnameescape(notes))
	vim.cmd("normal! Go")
	vim.api.nvim_put({ "", "> 行 " .. line, "" }, "l", true, true)
end

-- ---------- 原文只读 ----------

function M.setup_readonly()
	vim.bo.readonly = true
	vim.bo.modifiable = false
	-- vim.api.nvim_create_autocmd("BufRead", {
	-- 	pattern = "*.md",
	-- 	callback = function()
	-- 		if not is_notes() then
	-- 			vim.bo.readonly = true
	-- 			vim.bo.modifiable = false
	-- 		end
	-- 	end,
	-- })
end

function M.unlock()
	vim.bo.readonly = false
	vim.bo.modifiable = true
end

-- ---------- Git Worktree ----------

local function in_annotate_file()
  local file = vim.fn.expand("%:p")
  return file:match("/wt%-anno/") ~= nil
end

function M.switch_worktree_file()
  local file = vim.fn.expand("%:p")
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if not git_root or git_root == "" then
    vim.notify("Not inside a git repository", vim.log.levels.ERROR)
    return
  end


  local rel = file:gsub("^" .. git_root .. "/", "")
    vim.notify('rel is: \n' .. rel ,vim.log.levels.WARN)

  local target
  if in_annotate_file() then
    -- wt-anno → main
    rel = rel:gsub("^wt%-anno/", "")
    target = git_root .. "/" .. rel
  else
    -- main → wt-anno
    target = git_root .. "/wt-anno/" .. rel
  end

  if vim.fn.filereadable(target) == 0 then
    vim.notify("File not found in other worktree:\n" .. target, vim.log.levels.WARN)
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(target))
end

--------- Telescope ----------

function M.pick_worktree()
	local ok = pcall(require, "telescope")
	if not ok then
		vim.notify("telescope.nvim not found", vim.log.levels.ERROR)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local output = vim.fn.systemlist("git worktree list")
	if vim.v.shell_error ~= 0 then
		vim.notify("Not a git repository", vim.log.levels.ERROR)
		return
	end

	local entries = {}
	for _, line in ipairs(output) do
		local path, branch = line:match("^(%S+)%s+[%x]+%s+%[(.+)%]")
		if path and branch then
			table.insert(entries, { path = path, branch = branch })
		end
	end

	pickers
		.new({}, {
			prompt_title = "Git Worktrees",
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.branch .. "  →  " .. entry.path,
						ordinal = entry.branch .. " " .. entry.path,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(_, map)
				map("i", "<CR>", function(bufnr)
					local sel = action_state.get_selected_entry()
					actions.close(bufnr)
					vim.cmd("cd " .. vim.fn.fnameescape(sel.value.path))
					vim.notify("Switched to worktree: " .. sel.value.branch)
				end)
				return true
			end,
		})
		:find()
end

-- ---------- 搜索 Notes ----------

function M.search_notes()
	local ok, builtin = pcall(require, "telescope.builtin")
	if not ok then
		vim.notify("telescope.nvim not found", vim.log.levels.ERROR)
		return
	end

	builtin.live_grep({
		prompt_title = "Search Sidecar Notes",
		glob_pattern = "*.notes.md",
	})
end

-- ---------- 快捷键 ----------

function M.setup_keymaps()
	-- local map = vim.keymap.set
	-- map("n", "<leader>n", M.open_notes, { desc = "Open sidecar notes" })
	-- map("n", "<leader>N", M.open_notes_with_line, { desc = "Notes + line number" })
	-- map("n", "<leader>u", M.unlock, { desc = "Unlock readonly buffer" })
	-- map("n", "<leader>wf", M.switch_worktree_file, { desc = "Switch worktree same file" })
	-- map("n", "<leader>ww", M.pick_worktree, { desc = "Pick git worktree" })
	-- map("n", "<leader>ns", M.search_notes, { desc = "Search sidecar notes" })
	-- 方案一
	vim.keymap.set("n", "<leader>nl", M.setup_readonly, { desc = "lock readonly buffer" })
	vim.keymap.set("n", "<leader>nf", M.open_notes, { desc = "Open sidecar notes" })
	vim.keymap.set("n", "<leader>nn", M.open_notes_with_line, { desc = "Notes + line number" })
	vim.keymap.set("n", "<leader>nu", M.unlock, { desc = "Unlock readonly buffer" })
	vim.keymap.set("n", "<leader>ns", M.search_notes, { desc = "Search sidecar notes" })
	-- 方案二
	vim.keymap.set("n", "<leader>sf", M.switch_worktree_file, { desc = "Switch worktree same file" })
	vim.keymap.set("n", "<leader>sw", M.pick_worktree, { desc = "Pick git worktree" })
end

-- ---------- 初始化 ----------

function M.setup()
	-- M.setup_readonly()
	M.setup_keymaps()
end

return M
