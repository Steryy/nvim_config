
local options = {

	pickers = {
		colorscheme = {
			enable_preview = true,
		},
		buffers = {
			layout_strategy = "vertical",
	--		mappings = keymaps.telescope_buffer_mappings,
		},
	},
	defaults = {

	--	mappings = keymaps.telescope_mappings,
		vimgrep_arguments = {
			"rg",
			"-L",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		prompt_prefix = "   ",
		selection_caret = "  ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = { "node_modules" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = { "truncate" },
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		-- Developer configurations: Not meant for general override
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
	},

	extensions = {
		undo = {
			use_delta = false,
			diff_context_lines = 10,
			use_custom_command = { "bash", "-c", "echo '$DIFF' | delta --line-numbers" },
			side_by_side = false,
		},
		hop = {
			-- the shown `keys` are the defaults, no need to set `keys` if defaults work for you ;)
			keys = {
				"a",
				"s",
				"d",
				"f",
				"g",
				"h",
				"j",
				"k",
				"l",
				";",
				"q",
				"w",
				"e",
				"r",
				"t",
				"y",
				"u",
				"i",
				"o",
				"p",
				"A",
				"S",
				"D",
				"F",
				"G",
				"H",
				"J",
				"K",
				"L",
				":",
				"Q",
				"W",
				"E",
				"R",
				"T",
				"Y",
				"U",
				"I",
				"O",
				"P",
			},
			-- Highlight groups to link to signs and lines; the below configuration refers to demo
			-- sign_hl typically only defines foreground to possibly be combined with line_hl
			sign_hl = { "HopNextKey", "HopNextKey1" },
			-- optional, typically a table of two highlight groups that are alternated between
			line_hl = { "ColorColumn", "Normal" },
			-- options specific to `hop_loop`
			-- true temporarily disables Telescope selection highlighting
			clear_selection_hl = true,
			-- highlight hopped to entry with telescope selection highlight
			-- note: mutually exclusive with `clear_selection_hl`
			trace_entry = false,
			-- jump to entry where hoop loop was started from
			reset_selection = true,
		},
	},
	extensions_list = { "fzf", "hop" },
}

-- 		pickers = {
-- 			colorscheme = {
-- 				enable_preview = true,
-- 			},
-- 			buffers = {
-- 				layout_strategy = "vertical",
-- 				mappings = keymaps.telescope_buffer_mappings,
-- 			},
-- 		},
-- 		-- defaults = {
-- 		--     initial_mode = "normal",
-- 		--     scroll_strategy = "limit",
-- 		--     results_title = false,
-- 		--     layout_strategy = "horizontal",
-- 		--     path_display = { "absolute" },
-- 		--     file_ignore_patterns = {
-- 		--         ".git/",
-- 		--         ".cache",
-- 		--         "%.class",
-- 		--         "%.pdf",
-- 		--         "%.mkv",
-- 		--         "%.mp4",
-- 		--         "%.zip",
-- 		--     },
-- 		--     layout_config = {
-- 		--         horizontal = {
-- 		--             preview_width = 0.5,
-- 		--         },
-- 		--     },
-- 		--     file_previewer = require("telescope.previewers").vim_buffer_cat.new,
-- 		--     grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
-- 		--     qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
-- 		--     file_sorter = require("telescope.sorters").get_fuzzy_file,
-- 		--     generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
-- 		--     prompt_prefix = "   ",
-- 		--     selection_caret = " ",
-- 		--    mappings = keymaps.telescope_mappings,
-- 		-- },
-- 		extensions = {
-- 			undo = {
-- 				use_delta = false,
-- 				diff_context_lines = 10,
-- 				use_custom_command = { "bash", "-c", "echo '$DIFF' | delta --line-numbers" },
-- 				side_by_side = false,
-- 			},
-- 			hop = {
-- 				-- the shown `keys` are the defaults, no need to set `keys` if defaults work for you ;)
-- 				keys = {
-- 					"a",
-- 					"s",
-- 					"d",
-- 					"f",
-- 					"g",
-- 					"h",
-- 					"j",
-- 					"k",
-- 					"l",
-- 					";",
-- 					"q",
-- 					"w",
-- 					"e",
-- 					"r",
-- 					"t",
-- 					"y",
-- 					"u",
-- 					"i",
-- 					"o",
-- 					"p",
-- 					"A",
-- 					"S",
-- 					"D",
-- 					"F",
-- 					"G",
-- 					"H",
-- 					"J",
-- 					"K",
-- 					"L",
-- 					":",
-- 					"Q",
-- 					"W",
-- 					"E",
-- 					"R",
-- 					"T",
-- 					"Y",
-- 					"U",
-- 					"I",
-- 					"O",
-- 					"P",
-- 				},
-- 				-- Highlight groups to link to signs and lines; the below configuration refers to demo
-- 				-- sign_hl typically only defines foreground to possibly be combined with line_hl
-- 				sign_hl = { "HopNextKey", "HopNextKey1" },
-- 				-- optional, typically a table of two highlight groups that are alternated between
-- 				line_hl = { "ColorColumn", "Normal" },
-- 				-- options specific to `hop_loop`
-- 				-- true temporarily disables Telescope selection highlighting
-- 				clear_selection_hl = true,
-- 				-- highlight hopped to entry with telescope selection highlight
-- 				-- note: mutually exclusive with `clear_selection_hl`
-- 				trace_entry = false,
-- 				-- jump to entry where hoop loop was started from
-- 				reset_selection = true,
-- 			},
-- 		},
-- 	},
return options
