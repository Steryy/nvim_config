
local editor = {}
function leap_to_window()
	target_windows = require("leap.util").get_enterable_windows()
	local targets = {}
	for _, win in ipairs(target_windows) do
		local wininfo = vim.fn.getwininfo(win)[1]
		local pos = { wininfo.topline, 1 } -- top/left corner
		table.insert(targets, { pos = pos, wininfo = wininfo })
	end

	require("leap").leap({
		target_windows = target_windows,
		targets = targets,
		action = function(target)
			vim.api.nvim_set_current_win(target.wininfo.winid)
		end,
	})
end
editor.flint = function()
	---@type LazyKeys[]
	local ret = {}
	for _, key in ipairs({ "f", "F", "t", "T" }) do
		ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
	end
	return ret
end
editor.leap = {
	{ "s", mode = { "n", "x", "o" }, desc = "Leap gorward to" },
	{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
	{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
}
editor.hop = {
	{
		"s",
		function()
			require("hop").hint_char2({
				direction = require("hop.hint").HintDirection.AFTER_CURSOR,
			})
		end,
		mode = { "n", "x", "o" },
		desc = "Hop forward to",
	},
	{
		"S",
		function()
			require("hop").hint_char2({
				direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
			})
		end,
		mode = { "n", "x", "o" },
		desc = "Hop backward to",
	},
	{
		"gs",
		function()
			require("hop").hint_char2({
				multi_windows = true,
			})
		end,
		mode = { "n", "x", "o" },
		desc = "Hop to window",
	},
	{
		"\\s",
		function()
			require("hop").hint_char2({
				direction = require("hop.hint").HintDirection.AFTER_CURSOR,
			})
		end,
		mode = { "n", "x", "o" },
		desc = "Hop forward to",
	},
	{
		"\\S",
		function()
			require("hop").hint_char2({
				direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
			})
		end,
		mode = { "n", "x", "o" },
		desc = "Hop backward to",
	},
	{
		"\\gs",
		function()
			require("hop").hint_char2({
				multi_windows = true,
			})
		end,
		mode = { "n", "x", "o" },
		desc = "Hop to window",
	},
	{
		"\\w",
		function()
			require("hop").hint_words({
				direction = require("hop.hint").HintDirection.AFTER_CURSOR,
			})
		end,
		mode = { "n", "x", "o" },
		desc = "Hop to word",
	},
	{
		"\\b",
		function()
			require("hop").hint_words({
				direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
			})
		end,
		mode = { "n", "x", "o" },
		desc = "Hop backward",
	},
}

editor.neotree = {
	{
		"<leader>fe",
		function()
			require("neo-tree.command").execute({ toggle = true, dir = require("util").get_root() })
		end,
		desc = "Explorer NeoTree (root dir)",
	},
	{
		"<leader>fE",
		function()
			require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
		end,
		desc = "Explorer NeoTree (cwd)",
	},
	{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
	{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
}
editor.witchkey = {
	mode = { "n", "v" },
	["g"] = { name = "+goto" },
	["gz"] = { name = "+surround" },
	["]"] = { name = "+next" },
	["["] = { name = "+prev" },
	["<leader>b"] = { name = "+buffer" },
	["<leader>c"] = { name = "+code" },
	["<leader>f"] = { name = "+file/find" },
	["<leader>g"] = { name = "+git" },
	["<leader>gh"] = { name = "+hunks" },
	["<leader>q"] = { name = "+quit/session" },
	["<leader>s"] = { name = "+search" },
	["<leader>u"] = { name = "+ui" },
	["<leader>w"] = { name = "+windows" },
	["<leader>x"] = { name = "+diagnostics/quickfix" },
}
editor.bufremove = {
	{
		"<leader>bd",
		function()
			require("mini.bufremove").delete(0, false)
		end,
		desc = "Delete Buffer",
	},
	{
		"<leader>bD",
		function()
			require("mini.bufremove").delete(0, true)
		end,
		desc = "Delete Buffer (Force)",
	},
}
editor.trouble = {
	{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
	{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
	{ "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
	{ "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
	-- {
	--   "[q",
	--   function()
	--     if require("trouble").is_open() then
	--       require("trouble").previous({ skip_groups = true, jump = true })
	--     else
	--       vim.cmd.cprev()
	--     end
	--   end,
	--   desc = "Previous trouble/quickfix item",
	-- },
	-- {
	--   "]q",
	--   function()
	--     if require("trouble").is_open() then
	--       require("trouble").next({ skip_groups = true, jump = true })
	--     else
	--       vim.cmd.cnext()
	--     end
	--   end,
	--   desc = "Next trouble/quickfix item",
	-- },
}
editor.todo_comments = {
	{
		"]t",
		function()
			require("todo-comments").jump_next()
		end,
		desc = "Next todo comment",
	},
	{
		"[t",
		function()
			require("todo-comments").jump_prev()
		end,
		desc = "Previous todo comment",
	},
	{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
	{ "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
	{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
}
editor.spectre = {

	{
		"<leader>sr",
		function()
			require("spectre").open()
		end,
		desc = "Replace in files (Spectre)",
	},
}
editor.gitsigns = function(buffer)
	local gs = package.loaded.gitsigns

	local function map(mode, l, r, desc)
		vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
	end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
end
return editor
