local global = {}
local os_name = vim.loop.os_uname().sysname
global.is_mac = os_name == "Darwin"
global.is_linux = os_name == "Linux"
global.is_windows = os_name == "Windows_NT"
global.is_wsl = vim.fn.has("wsl") == 1
local path_sep = global.is_windows and "\\" or "/"
local home = global.is_windows and os.getenv("USERPROFILE") or os.getenv("HOME")

vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
global.cache_dir = home .. path_sep .. ".cache" .. path_sep .. "nvim" .. path_sep
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = global.cache_dir .. "undo/"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 0

vim.opt.colorcolumn = "80"


vim.opt.spelllang={"en","pl"}

vim.opt.signcolumn = "yes:2"
vim.opt.pumheight=20

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.o.laststatus = 3

if vim.fn.has("nvim-0.8") == 1 then
    vim.opt.cmdheight = 1
    -- vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
end

if vim.fn.has("nvim-0.9.0") == 1 then
    vim.opt.splitkeep = "screen"
    vim.o.shortmess = "filnxtToOFWIcC"
end

vim.g.colors_name = "default"
vim.g.mapleader = " "

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.opt.cursorline = true

vim.g.transparency = true
