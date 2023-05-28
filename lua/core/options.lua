local global = {}
local os_name = vim.loop.os_uname().sysname
global.is_mac = os_name == "Darwin"
global.is_linux = os_name == "Linux"
global.is_windows = os_name == "Windows_NT"
global.is_wsl = vim.fn.has("wsl") == 1
local path_sep = global.is_windows and "\\" or "/"
local home = global.is_windows and os.getenv("USERPROFILE") or os.getenv("HOME")

vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
global.cache_dir = home
	.. path_sep
	.. ".cache"
	.. path_sep
	.. "nvim"
	.. path_sep
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 0

vim.opt.colorcolumn = "0"

vim.opt.spelllang = { "en", "pl" }

vim.opt.signcolumn = "yes:2"
vim.opt.pumheight = 20

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.pumheight = 10
vim.opt.spelllang = { "en", "pl" }
vim.g.mapleader = " "
vim.opt.concealcursor = "nvc"
vim.opt.laststatus = 3
vim.g.icons_enabled = false
vim.g.netrw_banner = false
vim.o.ruler = false -- Don't show cursor position
vim.o.showmode = false -- Don't show mode in command line
-- vim.o.showcmd = false
-- vim.opt.guicursor = ""

vim.opt.shortmess:append("I")

vim.opt.updatetime = 50
vim.opt.list = true
if vim.fn.has("nvim-0.9.0") == 1 then
	-- vim.opt.splitkeep = "screen"
	vim.opt.cmdheight = 0
	-- opt.shortmess:append({ C = true })
end
