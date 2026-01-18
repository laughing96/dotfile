Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	}

end, 500, Status.RIGHT)

Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

-- ~/.config/yazi/init.lua
require("bookmarks"):setup({
	last_directory = { enable = false, persist = false, mode="dir" },
	persist = "none",
	desc_format = "full",
	file_pick_mode = "hover",
	custom_desc_input = false,
	show_keys = false,
	notify = {
		enable = true,
		timeout = 3,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})


require("mactag"):setup {
	-- Keys used to add or remove tags
	keys = {
		o = "todo",
		i = "doing",
		b = "blocked",
		r = "review",
		d = "done",
		a = "archive",
        t = "temp"

	},
	-- Colors used to display tags
	colors = {
		todo = "#ee7b70", --red 
		doing = "#f59e0b", -- orange
		blocked = "#fbe764", --- yellow
		review = "#91fc87", -- green 
		done = "#5fa3f8", -- blue
		archive = "#cb88f8", -- purple 
        temp = "#111111",
	},
}
