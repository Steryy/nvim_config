local Util = require("core.utils")

local function map(mode, lhs, rhs, opts)
	opts = type(opts) == "string" and { desc = opts } or opts
	opts = opts or {}

	opts.silent = opts.silent ~= false
	if not rhs then
		return
	end
	vim.keymap.set(mode, lhs, rhs, opts)
end
map("n", "gp", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v", "x", "c" }, "<c-z>", "")
map("n", "gy", '"+y', { desc = "Yank to system clipboard" })
map("n", "gY", '"+Y', { desc = "Yank to system clipboard" })
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
map("x", "gp", '"+P', { desc = "Paste from system clipboard" })
map("x", "gy", '"+Y', { desc = "yank to system clipboard" })
map("v", "<a-j>", ":m '>+1<CR>gv=gv")
map("v", "<a-k>", ":m '<-2<CR>gv=gv")
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "<C-z>", "<esc>", { desc = "Dont kill" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
map(
	{ "n", "t", "i" },
	"<C-Up>",
	"<cmd>resize +2<cr>",
	{ desc = "Increase window height" }
)
map(
	{ "n", "t", "i" },
	"<C-Down>",
	"<cmd>resize -2<cr>",
	{ desc = "Decrease window height" }
)
map(
	{ "n", "t", "i" },
	"<C-Left>",
	"<cmd>vertical resize -2<cr>",
	{ desc = "Decrease window width" }
)
map(
	{ "n", "t", "i" },
	"<C-Right>",
	"<cmd>vertical resize +2<cr>",
	{ desc = "Increase window width" }
)

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[c", "<cmd>cprevious<cr>", { desc = "Prev buffer" })
map("n", "]c", "<cmd>cnext<cr>", { desc = "Next buffer" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map(
	"n",
	"<A-h>",
	"<cmd>vertical resize -2<cr>",
	{ desc = "Decrease window width" }
)
map(
	"n",
	"<A-l>",
	"<cmd>vertical resize +2<cr>",
	{ desc = "Increase window width" }
)
map("n", "<leader>us", function()
	Util.toggle("spell")
end, { desc = "Toggle Spelling" })
map(
	"n",
	"<leader>ut",
	"<cmd>TransparentToggle<cr>",
	{ desc = "Toggle transparency" }
)
map("n", "<leader>uf", function()
	Util.toggle("foldcolumn", false, { "0", "2" })
end, { desc = "Toggle foldcolumn" })
map("n", "<leader>ug", function()
	local enable = true
	for key, value in pairs(vim.lsp.get_active_clients()) do
		if value and value.name == "ltex" then
			enable = false
			break
		end
	end
	if enable then
		print("Enabling grammar check")
		vim.cmd([[LspStart ]] .. "ltex")
	else
		print("Disabling grammar check")
		vim.cmd([[LspStop ]] .. "ltex")
	end
end, { desc = "Toggle grammar (ltex)" })
map("n", "<leader>uw", function()
	Util.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function()
	Util.toggle("relativenumber", true)
	Util.toggle("number")
end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
map("n", "<leader>uc", function()
	Util.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })

map("n", "<leader>e", "<cmd>Explore<cr>", { desc = "Explore" })

map("n", "-", "<cmd>Explore<cr>", { desc = "Explore" })

local keymaps = {}

keymaps.telekasten = {
	{
		"<leader>zg",
		":lua require('telekasten').search_notes()<CR>",
		desc = "Search notes",
	},
	{
		"<leader>zg",
		":lua require('telekasten').search_notes()<CR>",
		desc = "Search notes",
	},
	{
		"<leader>zd",
		":lua require('telekasten').find_daily_notes()<CR>",
		desc = "Find daily notes",
	},
	{
		"<leader>zz",
		":lua require('telekasten').find_notes()<CR>",
		desc = "Find notes",
	},
	{
		"<leader>zT",
		":lua require('telekasten').goto_today()<CR>",
		desc = "Go to today",
	},
	{
		"<leader>zW",
		":lua require('telekasten').goto_thisweek()<CR>",
		desc = "Go to this week",
	},
	{
		"<leader>zw",
		":lua require('telekasten').find_weekly_notes()<CR>",
		desc = "Find weekly notes",
	},
	{
		"<leader>zn",
		":lua require('telekasten').new_note()<CR>",
		desc = "New note",
	},
	{
		"<leader>zN",
		":lua require('telekasten').new_templated_note()<CR>",
		desc = "New teplate note",
	},
}
keymaps.gitsigns = {

	{ "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
	{ "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
	{
		mode = { "v", "n" },
		"<leader>ghs",
		":Gitsigns stage_hunk<CR>",
		desc = "Stage Hunk",
	},
	{
		mode = { "v", "n" },
		"<leader>ghr",
		":Gitsigns reset_hunk<CR>",
		desc = "Reset Hunk",
	},
	{
		mode = { "v", "n" },
		"<leader>ghp",
		":Gitsigns preview_hunk<CR>",
		desc = "Preview Hunk",
	},
	{
		"<leader>ghb",
		function()
			local gs = require("gitsigns")
			gs.blame_line({ full = true })
		end,
		desc = "Blame Line",
	},
	{ "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff This" },
	{
		mode = { "o", "x" },
		"ih",
		":<C-U>Gitsigns select_hunk<CR>",
		desc = "GitSigns Select Hunk",
	},
}
keymaps.telescope = {

	{
		"<leader>fs",
		function()
			vim.ui.input({ prompt = "Grep > " }, function(sr)
				Util.telescope("grep_string", { search = sr })()
			end)
		end,
		desc = "Telescope  grep_string",
	},

	{
		"<leader>ff",
		function()
			Util.telescope("find_files")()
		end,
		desc = "Telescope  grep_string",
	},
	{
		"<leader>fw",
		function()
			Util.telescope("live_grep")()
		end,
		desc = "Telescope  grep_string",
	},
	{
		"<leader>gc",
		function()
			Util.telescope("git_commits")()
		end,
		desc = "Telescope commits",
	},
}
keymaps.fzf={

	{
		"<leader>fs",
		function()
			vim.ui.input({ prompt = "Grep > " }, function(sr)
				require("fzf-lua").grep({search=sr})
			end)
		end,
		desc = "Telescope grep_string",
	},

	{
		"<leader>ff",
		function()

				require("fzf-lua").files()
		end,
		desc = "Telescope find files",
	},
	{
		"<leader>fw",
		function()
			require("fzf-lua").live_grep()
		end,
		desc = "Telescope live grep",
	},
	{
		"<leader>gc",
		function()
			require("fzf-lua").git_commits()
		end,
		desc = "Telescope commits",
	},


}
keymaps.tmux = {

	{
		"<C-h>",
		"<cmd>lua require('tmux').move_left()<cr>",
		desc = "Go to left window",
	},
	{
		"<C-j>",
		"<cmd>lua require('tmux').move_bottom()<cr>",
		desc = "Go to lower window",
	},
	{
		"<C-k>",
		"<cmd>lua require('tmux').move_top()<cr>",
		desc = "Go to upper window",
	},
	{
		"<C-l>",
		"<cmd>lua require('tmux').move_right()<cr>",
		desc = "Go to right window",
	},
	{
		"<A-h>",
		"<cmd>lua require('tmux').resize_left()<cr>",
		desc = "Resize left window",
	},
	{
		"<A-j>",
		"<cmd>lua require('tmux').resize_bottom()<cr>",
		desc = "Resize lower window",
	},
	{
		"<A-k>",
		"<cmd>lua require('tmux').resize_top()<cr>",
		desc = "Resize upper window",
	},
	{
		"<A-l>",
		"<cmd>lua require('tmux').resize_right()<cr>",
		desc = "Resize right window",
	},
}
keymaps.hop = {
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

keymaps.spectre = {
	{
		"<leader>sr",
		function()
			require("spectre").open()
		end,
		desc = "Replace in files (Spectre)",
	},
}

local function oilFunc()
	if vim.bo.filetype == "oil" then
		require("oil").close()
	else
		require("oil").open()
	end
end
keymaps.oil = {
	{
		"<leader>e",
		oilFunc,
		desc = "Open durent dir",
	},

	{
		"-",
		oilFunc,
		desc = "Open durent dir",
	},
}
keymaps.dap = {
	{
		"<leader>dn",
		function()
			require("dap").step_over()
		end,
		desc = "Step over",
	},
	{
		"<leader>di",
		function()
			require("dap").step_into()
		end,

		desc = "Step into",
	},
	{
		"<leader>do",
		function()
			require("dap").step_out()
		end,

		desc = "Step out",
	},
	{
		"<leader>dd",
		function()
			require("dap").down()
		end,

		desc = "Down stack",
	},
	{
		"<leader>du",
		function()
			require("dap").up()
		end,

		desc = "Up stack",
	},
	{
		"<leader>dq",
		function()
			require("dap").terminate()
		end,

		desc = "Terminate",
	},
	{
		"<leader>dr",
		function()
			require("dap").restart()
		end,
		desc = "Restart",
	},

	{
		"<leader>dg",
		function()
			require("dap").run_to_cursor()
		end,
		desc = "Run to cursor",
	},
	{
		"<leader>dc",
		function()
			require("dap").continue()
		end,
		desc = "Continue",
	},
	{
		"<leader>dbb",
		function()
			require("dap").toggle_breakpoint()
			-- require("persistent-breakpoints.api").toggle_breakpoint()
		end,
		desc = "Toggle breakpoint",
	},
	{
		"<leader>dbB",
		function()
			vim.ui.input({ prompt = "Breakpoint condition:" }, function(inp)
				require("dap").set_breakpoint(inp)
			end)
		end,

		desc = "Breakpoint condition",
	},

	{
		"<leader>dbl",
		function()
			vim.ui.input({ prompt = "Breakpoint log msg:" }, function(inp)
				require("dap").set_breakpoint(nil, nil, inp)
			end)
		end,

		desc = "Breakpoint log msg",
	},
	{
		"<leader>dbe",
		function()
			require("dap").set_exception_breakpoints()
		end,

		desc = "Breakpoint exception",
	},
	{
		"<leader>dl",
		function()
			require("dap").run_last()
		end,

		desc = "Rerun last debug adapter",
	},

	{
		"<leader>dh",
		function()
			require("dap.ui.widgets").hover()
		end,

		desc = "Dap hover",
	},
	{
		"<leader>dp",
		function()
			require("dap.ui.widgets").preview()
		end,
		desc = "Dap preview",
	},
	{
		"<leader>df",
		function()
			require("dapui").float_element("frames", { enter = true })
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end,

		desc = "Show frames",
	},
	{
		"<leader>ds",
		function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end,

		desc = "Show scopes",
	},
}

return keymaps
