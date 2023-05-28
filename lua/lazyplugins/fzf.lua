return {
	{
		"ibhagwan/fzf-lua",
		cmd = { "FzfLua" },
		config = function()
			require("plugins.configs.fzf")
		end,
		-- optional for icon support
		dependecies = { "nvim-tree/nvim-web-devicons" },
	},
}
