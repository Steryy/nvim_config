local keymaps = require("core.keymaps")
return {

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = keymaps.telescope,
		dependencies = {
			{ 'nvim-telescope/telescope-fzf-native.nvim',
				build =
				'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
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
			if opts.extensions_list then
				for _, ext in ipairs(opts.extensions_list) do
					print(ext)
					telescope.load_extension(ext)
				end
			end
		end,
	},
}
