return {

	{ "nvim-lua/plenary.nvim", lazy = true },

    {
        'tpope/vim-repeat',
        event = { 'CmdlineEnter' },
        keys = { '<Plug>(RepeatDot)', '<Plug>(RepeatUndo)', '<Plug>(RepeatRedo)' },

        init = function()
            vim.fn['repeat#set'] = function(...)
                vim.fn['repeat#set'] = nil
                require('lazy').load({ plugins = { 'vim-repeat' } })
                return vim.fn['repeat#set'](...)
            end
        end,
        lazy = true,
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        -- event = { "BufReadPost", "BufNewFile" },
        config = true,
        -- stylua: ignore
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
            { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
        },
    },
{
    'kristijanhusak/vim-dadbod-ui',
    cmd = {
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUI',
      'DBUIFindBuffer',
      'DBUIRenameBuffer',
      'DB',
    },
    config = function ()
        require("plugins.configs.dadbod_ui")
    end,
    dependencies = { 'tpope/vim-dadbod', ft = { 'sql' } },
    lazy = true,
  },
	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "TermExec" },
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
		cmd = { "Git",
        'Gvsplit',
        'G',
        'Gread',
        'Git',
        'Gedit',
        'Gstatus',
        'Gdiffsplit',
        'Gvdiffsplit',
        },
		config = function()
            require("plugins.configs.fugitive")
		end,

		keys = { { "<leader>gg", "<cmd>Git<cr>", mode = { "n" }, desc = "fugitive" } },
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
		keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", mode = { "n" }, desc = "Diff this" } },
	},
	{
		"TimUntersberger/neogit",
		enabled = false,
		cmd = { "Neogit" },
		opts = {
			disable_signs = false,
			disable_hint = false,
			disable_context_highlighting = false,
			disable_commit_confirmation = false,
			-- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
			-- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
			auto_refresh = true,
			-- Value used for `--sort` option for `git branch` command
			-- By default, branches will be sorted by commit date descending
			-- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
			-- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
			sort_branches = "-committerdate",
			disable_builtin_notifications = false,
			use_magit_keybindings = false,
			-- Change the default way of opening neogit
			kind = "split",
			-- The time after which an output console is shown for slow running commands
			console_timeout = 20000,
			-- Automatically show console if a command takes more than console_timeout milliseconds
			auto_show_console = true,
			-- Persist the values of switches/options within and across sessions
			remember_settings = true,
			-- Scope persisted settings on a per-project basis
			use_per_project_settings = true,
			-- Array-like table of settings to never persist. Uses format "Filetype--cli-value"
			--   ie: `{ "NeogitCommitPopup--author", "NeogitCommitPopup--no-verify" }`
			ignored_settings = {},
			-- Change the default way of opening the commit popup
			commit_popup = {
				kind = "split",
			},
			-- Change the default way of opening the preview buffer
			preview_buffer = {
				kind = "split",
			},
			-- Change the default way of opening popups
			popup = {
				kind = "split",
			},
			-- customize displayed signs
			signs = {
				-- { CLOSED, OPENED }
				section = { ">", "v" },
				item = { ">", "v" },
				hunk = { "", "" },
			},
			integrations = {
				-- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `sindrets/diffview.nvim`.
				-- The diffview integration enables the diff popup, which is a wrapper around `sindrets/diffview.nvim`.
				--
				-- Requires you to have `sindrets/diffview.nvim` installed.
				-- use {
				--   'TimUntersberger/neogit',
				--   requires = {
				--     'nvim-lua/plenary.nvim',
				--     'sindrets/diffview.nvim'
				--   }
				-- }
				--
				diffview = true,
			},
			-- Setting any section to `false` will make the section not render at all
			sections = {
				untracked = {
					folded = true,
				},
				unstaged = {
					folded = true,
				},
				staged = {
					folded = true,
				},
				stashes = {
					folded = true,
				},
				unpulled = {
					folded = true,
				},
				unmerged = {
					folded = true,
				},
				recent = {
					folded = true,
				},
			},
			-- override/add mappings
			mappings = {
				-- modify status buffer mappings
				status = {
					["q"] = "Close",
					["1"] = "Depth1",
					["2"] = "Depth2",
					["3"] = "Depth3",
					["4"] = "Depth4",
					["<tab>"] = "Toggle",
					["x"] = "Discard",
					["s"] = "Stage",
					["a"] = "StageUnstaged",
					["<c-s>"] = "StageAll",
					["u"] = "Unstage",
					["U"] = "UnstageStaged",
					["d"] = "DiffAtFile",
					["$"] = "CommandHistory",
					["<c-r>"] = "RefreshBuffer",
					["o"] = "GoToFile",
					["<enter>"] = "Toggle",
					["<c-v>"] = "VSplitOpen",
					["<c-x>"] = "SplitOpen",
					["<c-t>"] = "TabOpen",
					["?"] = "HelpPopup",
					["D"] = "DiffPopup",
					["p"] = "PullPopup",
					["r"] = "RebasePopup",
					["P"] = "PushPopup",
					["c"] = "CommitPopup",
					["L"] = "LogPopup",
					["Z"] = "StashPopup",
					["b"] = "BranchPopup",
					["C"] = "Console",
					["<cr>"] = "SplitOpen",
				},
			},
		},

		-- keys = { { "<leader>gg", "<cmd>Neogit<cr>", mode = { "n" }, desc = "Neogit" } },
	},
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle" },

		keys = { { "<leader>U", "<cmd>UndotreeToggle<cr>", mode = { "n" }, desc = "Undo tree" } },
	},

    {
        "vimpostor/vim-tpipeline",
        lazy = false,
        enabled = vim.g.is_tmux,
        config = function()
            vim.opt.cmdheight = 0
        end
    },
	{
		"aserowy/tmux.nvim",
		lazy = true,
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
			local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
			return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		ft = "gitcommit",
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
			on_attach = function(buffer)
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
	      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},
}
