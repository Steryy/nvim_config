return{
{
		"hrsh7th/nvim-cmp",
		event = {
			"InsertEnter",
			-- "CmdLineEnter",
		},
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
				config = function(_, opts)
					require("plugins.configs.luasnip")(opts)
				end,
			},

			-- autopairing of (){}[] etc
			-- cmp sources plugins
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			"f3fora/cmp-spell",
			"FelipeLema/cmp-async-path",
		},

		config = function(_, opts)
			require("plugins.configs.cmp")
		end,
	}

}
