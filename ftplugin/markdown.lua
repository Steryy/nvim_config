local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- markdown
--
map("n", "<leader>cc", function()
	if require("peek").is_open() then
		vim.cmd("silent!  %s/```math/```latex/g")
		require("peek").close()
	else
		vim.cmd("silent!  %s/```latex/```math/g")
		require("peek").open()
	end
end, { desc = "Preview document" })

--- telekasten
-- On hesitation, bring up the command panel
-- Function mappings
map(
	"n",
	"<leader>zz",
	":lua require('telekasten').find_notes()<CR>",
	{ desc = "Find notes" }
)
map(
	"n",
	"<leader>zd",
	":lua require('telekasten').find_daily_notes()<CR>",
	{ desc = "Find daily notes" }
)
map(
	"n",
	"<leader>zg",
	":lua require('telekasten').search_notes()<CR>",
	{ desc = "Find daily notes" }
)
map(
	"n",
	"<leader>zf",
	":lua require('telekasten').follow_link()<CR>",
	{ desc = "Folow link" }
)
map(
	"n",
	"gf",
	":lua require('telekasten').follow_link()<CR>",
	{ desc = "Folow link" }
)

map(
	"n",
	"<leader>zT",
	":lua require('telekasten').goto_today()<CR>",
	{ desc = "Go to today" }
)
map(
	"n",
	"<leader>zW",
	":lua require('telekasten').goto_thisweek()<CR>",
	{ desc = "Go to this week" }
)
map(
	"n",
	"<leader>zw",
	":lua require('telekasten').find_weekly_notes()<CR>",
	{ desc = "Find weekly notes" }
)
map(
	"n",
	"<leader>zn",
	":lua require('telekasten').new_note()<CR>",
	{ desc = "New note" }
)
map(
	"n",
	"<leader>zN",
	":lua require('telekasten').new_templated_note()<CR>",
	{ desc = "New teplate note" }
)
map(
	"n",
	"<leader>zy",
	":lua require('telekasten').yank_notelink()<CR>",
	{ desc = "Yank link" }
)
map(
	"n",
	"<leader>zc",
	":lua require('telekasten').show_calendar()<CR>",
	{ desc = "Show calendar" }
)
map("n", "<leader>zC", ":CalendarT<CR>", { desc = "Calendar" })
map(
	"n",
	"<leader>zi",
	":lua require('telekasten').paste_img_and_link()<CR>",
	{ desc = "Paste img and link" }
)
map(
	"n",
	"<leader>zt",
	":lua require('telekasten').toggle_todo()<CR>",
	{ desc = "Toggle todo" }
)
map(
	"n",
	"<C-space>",
	":lua require('telekasten').toggle_todo()<CR>",
	{ desc = "Toggle todo" }
)
map(
	"n",
	"<leader>zb",
	":lua require('telekasten').show_backlinks()<CR>",
	{ desc = "Show backlinks" }
)
map(
	"n",
	"<leader>zF",
	":lua require('telekasten').find_friends()<CR>",
	{ desc = "Find backilings to link under cursor" }
)
map(
	"n",
	"<leader>zI",
	":lua require('telekasten').insert_img_link({ i=true })<CR>",
	{ desc = "Image link" }
)
map(
	"n",
	"<leader>zp",
	":lua require('telekasten').preview_img()<CR>",
	{ desc = "Preview image" }
)
map(
	"n",
	"<leader>zm",
	":lua require('telekasten').browse_media()<CR>",
	{ desc = "Browse media files" }
)
map(
	"n",
	"<leader>za",
	":lua require('telekasten').show_tags()<CR>",
	{ desc = "Show tags" }
)
map(
	"n",
	"<leader>#",
	":lua require('telekasten').show_tags()<CR>",
	{ desc = "Show tags" }
)
map(
	"n",
	"<leader>zr",
	":lua require('telekasten').rename_note()<CR>",
	{ desc = "Change note name" }
)
map(
	"n",
	"<leader>zi",
	":lua require('telekasten').insert_link()<cr>",
	{ desc = "Change note name" }
)
