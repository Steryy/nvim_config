local M = {}

M.luasnip = function(opts)
	require("luasnip").config.set_config(opts)
	vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/snippets/"
	-- vscode format
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_vscode").lazy_load({
		paths = vim.g.vscode_snippets_path or "",
	})

	-- snipmate format
	require("luasnip.loaders.from_snipmate").load()
	require("luasnip.loaders.from_snipmate").lazy_load({
		paths = vim.g.snipmate_snippets_path or "",
	})

	-- lua format
	require("luasnip.loaders.from_lua").load()
	require("luasnip.loaders.from_lua").lazy_load({
		paths = vim.g.lua_snippets_path or "",
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			if
				require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
				and not require("luasnip").session.jump_active
			then
				require("luasnip").unlink_current()
			end
		end,
	})
end

M.gitsigns = {
	signs = {
		add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
		change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
		delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
		topdelete = {
			hl = "DiffDelete",
			text = "‾",
			numhl = "GitSignsDeleteNr",
		},
		changedelete = {
			hl = "DiffChangeDelete",
			text = "~",
			numhl = "GitSignsChangeNr",
		},
		untracked = {
			hl = "GitSignsAdd",
			text = "│",
			numhl = "GitSignsAddNr",
			linehl = "GitSignsAddLn",
		},
	},
	sign_priority = 9999,
}

return M
