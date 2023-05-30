local keymaps = require("core.keymaps")
return {
	{
		"ibhagwan/fzf-lua",
		cmd = { "FzfLua" },
		keys= keymaps.fzf,
		config = function()
			require("plugins.configs.fzf")
		end,
		-- optional for icon support
		dependecies = { "nvim-tree/nvim-web-devicons" },
	},
}
