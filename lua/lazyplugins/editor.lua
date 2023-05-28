local keymaps = require("core.keymaps")
return {

	{
		"folke/which-key.nvim",
		event = "UIEnter",
		opts = {
			plugins = { spelling = true },
			defaults = {
				mode = { "n", "v" },
				["g"] = { name = "+goto" },
				["gz"] = { name = "+surround" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.defaults)
		end,
	},
	{
		-- enabled = false,
		"stevearc/oil.nvim",
		lazy = false,
		keys = keymaps.oil,
		config = function()
			require("oil").setup({
				buf_options = {
					buflisted = false,
					-- bufhidden = "wipe",
				},
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-v>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["g."] = "actions.toggle_hidden",
					["<bs>"] = "actions.parent",
					["q"] = "actions.close",
					["esc"] = "actions.close",
				},
				columns = {
					-- "icon",
					-- "permissions",
					-- "size",
					-- "mtime",
				},
			})
		end,
	},
	{
		"windwp/nvim-spectre",
		-- stylua: ignore
		keys = keymaps.spectre,
	},
	{
		"phaazon/hop.nvim",
		branch = "v2", -- optional but strongly recommended
		keys = keymaps.hop,
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	},
}
