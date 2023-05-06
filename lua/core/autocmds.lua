
local function augroup(name)
	return vim.api.nvim_create_augroup( name, { clear = true })
end
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = augroup("Highlight yanked text"),
})
local tab = {

	tkTag = { link = "@keyword" },
	tkHilight = { link = "@character" },
	tkTagSep = { link = "@comment" },
	tkLink = { link = "@text.reference" },
	TSRainbowRed = { link = "DiagnosticError" },
	TSRainbowYellow = { link = "DiagnosticWarn" },
	              TSRainbowBlue={link = "DiagnosticInfo"},
	--               'TSRainbowOrange',
	--               'TSRainbowGreen',
	--               'TSRainbowViolet',
	--               'TSRainbowCyan'
}
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		for index, value in pairs(tab) do
			vim.api.nvim_set_hl(0, index, value)
		end
	end,
	group = augroup("telekasten"),
})

vim.g.colors_name = "kanagawa"

vim.cmd("silent! colorscheme " .. vim.g.colors_name)
