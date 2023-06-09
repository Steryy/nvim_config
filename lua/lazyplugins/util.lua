local keymaps = require( "core.keymaps")
return {

	{ "nvim-lua/plenary.nvim", lazy = true },

	{
		"tpope/vim-repeat",
		event = { "CmdlineEnter" },
		keys = {
			"<Plug>(RepeatDot)",
			"<Plug>(RepeatUndo)",
			"<Plug>(RepeatRedo)",
		},

		init = function()
			vim.fn["repeat#set"] = function(...)
				vim.fn["repeat#set"] = nil
				require("lazy").load({ plugins = { "vim-repeat" } })
				return vim.fn["repeat#set"](...)
			end
		end,
		lazy = true,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		cmd = {
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUI",
			"DBUIFindBuffer",
			"DBUIRenameBuffer",
			"DB",
		},
		config = function()
			require("plugins.configs.dadbod_ui")
		end,
		dependencies = {
			"tpope/vim-dadbod",
			ft = { "sql" },
			"kristijanhusak/vim-dadbod-completion",
			"tpope/vim-dispatch",
		},
		lazy = true,
	},
	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "TermExec" },
		keys = { "<F7>" },
		opts = {
			size = 10,
			open_mapping = [[<F7>]],
			shading_factor = 2,
			direction = "float",
			float_opts = {
				border = "curved",
				highlights = { border = "Normal", background = "Normal" },
			},
		},
	},
	{
		"tpope/vim-fugitive",
		-- enabled = false,
		cmd = {
			"Git",
			"Gvsplit",
			"G",
			"Gread",
			"Git",
			"Gedit",
			"Gstatus",
			"Gdiffsplit",
			"Gvdiffsplit",
		},
		keys = {
			{ "<leader>gg", "<cmd>Git<cr>", mode = { "n" }, desc = "fugitive" },
		},
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		opts = function()
			return require("plugins.configs.nvimtree")
		end,
		config = function(_, opts)
			require("nvim-tree").setup(opts)
			vim.g.nvimtree_side = opts.view.side
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		init = function()
			require("core.utils").lazy_load("nvim-colorizer.lua")
		end,
		opts = {
			user_default_options = {
				always_update = true,
			},
		},
		config = function(_, opts)
			require("colorizer").setup(opts)

			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},

	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose" },
		keys = {
			{
				"<leader>gd",
				"<cmd>DiffviewOpen<cr>",
				mode = { "n" },
				desc = "Diff this",
			},
		},
	},
	{
		"CKolkey/neogit",
		cmd = { "Neogit" },
		config = function()
			require("plugins.configs.neogit")
		end,
	},
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle" },

		keys = {
			{
				"<leader>U",
				"<cmd>UndotreeToggle<cr>",
				mode = { "n" },
				desc = "Undo tree",
			},
		},
	},

	{
		"vimpostor/vim-tpipeline",
		lazy = false,
		enabled = vim.g.is_tmux,
		config = function()
			vim.opt.cmdheight = 0
		end,
	},
	{
		"aserowy/tmux.nvim",
		keys = keymaps.tmux,
		enabled = vim.g.is_tmux,
		config = function()
			return require("tmux").setup()
		end,
	},
	-- To make a plugin not be loaded
	{
		"numToStr/Comment.nvim",
		keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
		opts = function()
			local commentstring_avail, commentstring = pcall(
				require,
				"ts_context_commentstring.integrations.comment_nvim"
			)
			return commentstring_avail
					and commentstring
					and { pre_hook = commentstring.create_pre_hook() }
				or {}
		end,
	},

		{
			"lewis6991/gitsigns.nvim",
			ft = "gitcommit",
			keys = keymaps.gitsigns,
			init = function()
				-- load gitsigns only when a git file is opened
				vim.api.nvim_create_autocmd({ "BufRead" }, {
					group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
					callback = function()
						vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
						if vim.v.shell_error == 0 then
							vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
							vim.schedule(function()
								require("lazy").load({ plugins = { "gitsigns.nvim" } })
							end)
						end
					end,
				})
			end,
			opts = {
				sign_priority = 9999,
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
			},
		},
}
