--
-- local ThePrimeagen_Fugitive =
-- 	vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})
--
-- local autocmd = vim.api.nvim_create_autocmd
-- autocmd("BufWinEnter", {
-- 	group = ThePrimeagen_Fugitive,
-- 	pattern = "*",
-- 	callback = function()
vim.opt_local.signcolumn = "no"
vim.opt_local.number = false
vim.opt_local.relativenumber = false
-- vim.opt_local.splitright = false
local bufnr = vim.api.nvim_get_current_buf()
local win = vim.api.nvim_get_current_win()
local opts = { buffer = bufnr, remap = false }
vim.keymap.set("n", "q", function()
	vim.cmd("bdelete")
end, opts)
vim.keymap.set("n", "<leader>p", function()
	vim.cmd.Git("push")
end, opts)

-- rebase always
vim.keymap.set("n", "<leader>P", function()
	vim.cmd.Git({ "pull", "--rebase" })
end, opts)

-- NOTE: It allows me to easily set the branch i am pushing and any tracking
-- needed if i did not set the branch up correctly
vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
vim.cmd("wincmd L")
vim.api.nvim_win_set_width(win, 50)
-- 	end,
-- })
