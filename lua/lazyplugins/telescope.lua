return{

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		--keys = keymaps.telescope,
		dependencies = {

			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			{
				"debugloop/telescope-undo.nvim",
			},
			{
				"nvim-telescope/telescope-hop.nvim",
			},
		},
		opts = function()
			return require("plugins.configs.telescope")
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)

			-- load extensions
			for _, ext in ipairs(opts.extensions_list) do
				telescope.load_extension(ext)
			end
		end,
	},



}
