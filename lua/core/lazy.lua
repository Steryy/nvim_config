local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)
if os.getenv("NVIM") ~= nil then
	require("lazy").setup({
		{ "willothy/flatten.nvim", config = true, lazy = false, },
	})
	return
end
require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
     -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "lazyplugins" },
  },
	defaults = { lazy = true, version = false },
	-- install = { colorscheme = { "tokyonight", "habamax" } },
	checker = { enabled = false },
	performance = {
		rtp = {
			disabled_plugins = {
			"gzip",
			"man",
			"spellfile",
			-- "matchit",
			-- "matchparen",
			-- "netrwPlugin",
			"shada",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin",
			},
		},
	},
})
