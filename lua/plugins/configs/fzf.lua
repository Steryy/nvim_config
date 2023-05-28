require("fzf-lua").setup({
	previewers = {
		cat = {
			cmd = "cat",
			args = "--number",
		},
		bat = {
			cmd = "bat",
			args = "--style=numbers,changes --color always",
			theme = "Coldark-Dark", -- bat preview theme (bat --list-themes)
			config = nil, -- nil uses $BAT_CONFIG_PATH
		},
		head = {
			cmd = "head",
			args = nil,
		},
		git_diff = {
			cmd_deleted = "git diff --color HEAD --",
			cmd_modified = "git diff --color HEAD",
			cmd_untracked = "git diff --color --no-index /dev/null",
			-- uncomment if you wish to use git-delta as pager
			-- can also be set under 'git.status.preview_pager'
			-- pager        = "delta --width=$FZF_PREVIEW_COLUMNS",
		},
		man = {
			-- NOTE: remove the `-c` flag when using man-db
			-- replace with `man -P cat %s | col -bx` on OSX
			cmd = "man -c %s | col -bx",
		},
		builtin = {
			syntax = true, -- preview syntax highlight?
			syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
			syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
			limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
			-- previewer treesitter options:
			-- enable specific filetypes with: `{ enable = { "lua" } }
			-- exclude specific filetypes with: `{ disable = { "lua" } }
			-- disable fully with: `{ enable = false }`
			treesitter = { enable = true, disable = {} },
			-- By default, the main window dimensions are calculted as if the
			-- preview is visible, when hidden the main window will extend to
			-- full size. Set the below to "extend" to prevent the main window
			-- from being modified when toggling the preview.
			toggle_behavior = "default",
			-- preview extensions using a custom shell command:
			-- for example, use `viu` for image previews
			-- will do nothing if `viu` isn't executable
			extensions = {
				-- neovim terminal only supports `viu` block output
				["png"] = { "chafa" },
				["svg"] = { "chafa" },
				["jpg"] = { "chafa" },
			},
			-- if using `ueberzug` in the above extensions map
			-- set the default image scaler, possible scalers:
			--   false (none), "crop", "distort", "fit_contain",
			--   "contain", "forced_cover", "cover"
			-- https://github.com/seebye/ueberzug
			ueberzug_scaler = "cover",
		},
	},
})
