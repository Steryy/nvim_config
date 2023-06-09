local statusline = "heirline"
return {

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		opts = { compile = true },
	},
	{
		"rebelot/heirline.nvim",
		event="BufEnter",
		enabled = statusline == "heirline",
		config = function()
			require("plugins.configs.heirline")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		opts = {},
	},
	{ "EdenEast/nightfox.nvim", lazy = false },
	{
		"maxmx03/fluoromachine.nvim",
		lazy = false,
		config = function()
			local fm = require("fluoromachine")

			fm.setup({
				glow = false,
				theme = "fluoromachine",
			})
		end,
	},
	{
		"nyngwang/nvimgelion",
		lazy = false,
		config = function()
			-- do whatever you want for further customization~
		end,
	},

	{
		"numToStr/Sakura.nvim",
		lazy = false,
	},

	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	{
		"nvim-lualine/lualine.nvim",
		-- event = {"BufRead","UIEnter"},
		-- lazy = false,
		config = function()
			if statusline == "lualine" then
				vim.api.nvim_set_hl(
					0,
					"Statusline",
					{ fg = "NONE", bg = "NONE" }
				)

				require("plugins.configs.lualine")
			end
		end,
	},
	{
		"xiyaowong/transparent.nvim",
		lazy = false,
		cmd = {
			"TransparentEnable",
			"TransparentDisable",
			"TransparentToggle",
		},
		config = function ()
			require("plugins.configs.transparent")
		end
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false,
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = { "qf" },
		config = function()
			require("plugins.configs.bqf")
		end,
	},
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	{
		"folke/zen-mode.nvim",
	},
}
