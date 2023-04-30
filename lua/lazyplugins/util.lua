return {

	{ "nvim-lua/plenary.nvim", lazy = true },
	-- {
	--   "max397574/better-escape.nvim",
	--   event = "InsertEnter",
	--   config = function()
	--     require("better_escape").setup()
	--   end,
	-- },
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
	{ "tpope/vim-fugitive", lazy = false },
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		init = function()
			require("core.utils").load_mappings("nvimtree")
		end,
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
		cmd = { "Neogit" },
		opts = {},

		keys = { { "<leader>gg", "<cmd>Neogit<cr>", mode = { "n" }, desc = "Neogit" } },
	},
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle" },

		keys = { { "<leader>U", "<cmd>UndotreeToggle<cr>", mode = { "n" }, desc = "Undo tree" } },
	},

	{ "vimpostor/vim-tpipeline", lazy = false },
	{
		"aserowy/tmux.nvim",
		config = function()
			return require("tmux").setup()
		end,
	},
	-- To make a plugin not be loaded
	{
		"numToStr/Comment.nvim",
		keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
		opts = function()
			local commentstring_avail, commentstring =
				pcall(require, "ts_context_commentstring.integrations.comment_nvim")
			return commentstring_avail and commentstring and { pre_hook = commentstring.create_pre_hook() } or {}
		end,
	},

	-- {
	--   "lewis6991/gitsigns.nvim",
	--   event = { "BufReadPre", "BufNewFile" },
	--   opts = {
	--
	--     sign_priority = 9999,
	--     signs = {
	--       add = { text = "▎" },
	--       change = { text = "▎" },
	--       delete = { text = "" },
	--       topdelete = { text = "" },
	--       changedelete = { text = "▎" },
	--       untracked = { text = "▎" },
	--     },
	--     on_attach = function(buffer)
	--       local gs = package.loaded.gitsigns
	--
	--       local function map(mode, l, r, desc)
	--         vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
	--       end
	--
	--       -- stylua: ignore start
	--       map("n", "]h", gs.next_hunk, "Next Hunk")
	--       map("n", "[h", gs.prev_hunk, "Prev Hunk")
	--       map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
	--       map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
	--       map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
	--       map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
	--       map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
	--       map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
	--       map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
	--       map("n", "<leader>ghd", gs.diffthis, "Diff This")
	--       map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
	--     end,
	--   },
	-- },
}
