local is_cat, catppuccin = pcall(require, "catppuccin")
-- local monokai = require('monokai')
-- monokai.setup {
--     custom_hlgroups = { Normal = {fg = "none"}}
-- }

local U = require("catppuccin.utils.colors")
if is_cat then
	return {
		flavour = "mocha", -- Can be one of: latte, frappe, macchiato, mocha
		background = { light = "latte", dark = "mocha" },
		dim_inactive = {
			enabled = true,
			-- Dim inactive splits/windows/buffers.
			-- NOT recommended if you use old palette (a.k.a., mocha).
			shade = "dark",
			percentage = 0.15,
		},
		transparent_background = false,
		show_end_of_buffer = false, -- show the '~' characters after the end of buffers
		term_colors = true,
		compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
		styles = {
			comments = { "italic" },
			properties = { "italic" },
			functions = { "italic", "bold" },
			keywords = { "italic" },
			operators = { "bold" },
			conditionals = { "bold" },
			loops = { "bold" },
			booleans = { "bold", "italic" },
			numbers = {},
			types = {},
			strings = {},
			variables = {},
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
			},
			aerial = false,
			barbar = false,
			beacon = false,
			cmp = false,
			coc_nvim = false,
			dap = { enabled = true, enable_ui = true },
			dashboard = false,
			fern = false,
			fidget = true,
			gitgutter = false,
			gitsigns = true,
			harpoon = false,
			hop = true,
			illuminate = true,
			indent_blankline = { enabled = true, colored_indent_levels = false },
			leap = true,
			lightspeed = false,
			lsp_saga = true,
			lsp_trouble = true,
			markdown = true,
			mason = true,
			mini = false,
			navic = { enabled = false },
			neogit = false,
			neotest = false,
			neotree = { enabled = false, show_root = true, transparent_panel = false },
			noice = false,
			notify = true,
			nvimtree = true,
			overseer = false,
			pounce = false,
			semantic_tokens = false,
			symbols_outline = false,
			telekasten = true,
			telescope = true,
			treesitter_context = true,
			ts_rainbow = true,
			vim_sneak = false,
			vimwiki = false,
			which_key = true,
		},
		color_overrides = {
			mocha = {
				rosewater = "#F5E0DC",
				flamingo = "#F2CDCD",
				mauve = "#DDB6F2",
				pink = "#F5C2E7",
				red = "#F28FAD",
				maroon = "#E8A2AF",
				peach = "#F8BD96",
				yellow = "#FAE3B0",
				green = "#ABE9B3",
				blue = "#96CDFB",
				sky = "#89DCEB",
				teal = "#B5E8E0",
				lavender = "#C9CBFF",
				text = "#D9E0EE",
				subtext1 = "#BAC2DE",
				subtext0 = "#A6ADC8",
				overlay2 = "#C3BAC6",
				overlay1 = "#988BA2",
				overlay0 = "#6E6C7E",
				surface2 = "#6E6C7E",
				surface1 = "#575268",
				surface0 = "#302D41",
				base = "#1E1E2E",
				mantle = "#1A1826",
				crust = "#161320",
			},
		},
		highlight_overrides = {
			mocha = function(cp)
				return {
					-- For base configs.
					NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.base },
					--telekasten
					--
					tkLink = { link = "@text.reference" },
					tkBrakets = { fg = cp.crust },
					tkTag = { fg = cp.red },
					tkHilight = { fg = cp.yellow },
					tkTagSep = { fg = cp.crust },
					--#region
					--#region
					--#region
					--
					--
					--
					--
					OilDir = { fg = cp.blue },
					CursorLineNr = { fg = cp.green },
					Search = { bg = cp.surface1, fg = cp.pink, style = { "bold" } },
					IncSearch = { bg = cp.pink, fg = cp.surface1 },
					Keyword = { fg = cp.pink },
					Type = { fg = cp.blue },
					Typedef = { fg = cp.yellow },
					StorageClass = { fg = cp.red, style = { "italic" } },
					-- For native lsp configs.
					DiagnosticVirtualTextError = { bg = cp.none },
					DiagnosticVirtualTextWarn = { bg = cp.none },
					DiagnosticVirtualTextInfo = { bg = cp.none },
					DiagnosticVirtualTextHint = { fg = cp.rosewater, bg = cp.none },
					DiagnosticHint = { fg = cp.rosewater },
					LspDiagnosticsDefaultHint = { fg = cp.rosewater },
					LspDiagnosticsHint = { fg = cp.rosewater },
					LspDiagnosticsVirtualTextHint = { fg = cp.rosewater },
					LspDiagnosticsUnderlineHint = { sp = cp.rosewater },
					-- For fidget.
					FidgetTask = { bg = cp.none, fg = cp.surface2 },
					FidgetTitle = { fg = cp.blue, style = { "bold" } },
					TelescopeSelection = { link = "ColorColumn" },
					TelescopeMultiSelection = { fg = cp.red, bg = cp.crust },
					-- For trouble.nvim
					TroubleNormal = { bg = cp.base },
					-- For treesitter.
					["@field"] = { fg = cp.rosewater },
					["@property"] = { fg = cp.yellow },
					["@include"] = { fg = cp.teal },
					-- ["@operator"] = { fg = cp.sky },
					["@keyword.operator"] = { fg = cp.sky },
					["@punctuation.special"] = { fg = cp.maroon },
					-- ["@float"] = { fg = cp.peach },
					-- ["@number"] = { fg = cp.peach },
					-- ["@boolean"] = { fg = cp.peach },

					["@constructor"] = { fg = cp.lavender },
					-- ["@constant"] = { fg = cp.peach },
					-- ["@conditional"] = { fg = cp.mauve },
					-- ["@repeat"] = { fg = cp.mauve },
					["@exception"] = { fg = cp.peach },
					["@constant.builtin"] = { fg = cp.lavender },
					-- ["@function.builtin"] = { fg = cp.peach, style = { "italic" } },
					-- ["@type.builtin"] = { fg = cp.yellow, style = { "italic" } },
					["@type.qualifier"] = { link = "@keyword" },
					["@variable.builtin"] = { fg = cp.red, style = { "italic" } },
					-- ["@function"] = { fg = cp.blue },
					["@function.macro"] = { fg = cp.red, style = {} },
					["@parameter"] = { fg = cp.rosewater },
					["@keyword"] = { fg = cp.red, style = { "italic" } },
					["@keyword.function"] = { fg = cp.maroon },
					["@keyword.return"] = { fg = cp.pink, style = {} },
					-- ["@text.note"] = { fg = cp.base, bg = cp.blue },
					-- ["@text.warning"] = { fg = cp.base, bg = cp.yellow },
					-- ["@text.danger"] = { fg = cp.base, bg = cp.red },
					-- ["@constant.macro"] = { fg = cp.mauve },

					["IndentBlanklineIndent1"] = { fg = cp.maroon },
					["IndentBlanklineIndent2"] = { fg = cp.peach },
					["IndentBlanklineIndent3"] = { fg = cp.green },
					["IndentBlanklineIndent4"] = { fg = cp.teal },
					["IndentBlanklineIndent5"] = { fg = cp.blue },
					["IndentBlanklineIndent6"] = { fg = cp.mauve },
					-- ["@label"] = { fg = cp.blue },
					["@method"] = { fg = cp.blue, style = { "italic" } },
					["@namespace"] = { fg = cp.rosewater, style = {} },
					["@punctuation.delimiter"] = { fg = cp.teal },
					["@punctuation.bracket"] = { fg = cp.overlay2 },
					-- ["@string"] = { fg = cp.green },
					-- ["@string.regex"] = { fg = cp.peach },
					["@type"] = { fg = cp.yellow },
					["@variable"] = { fg = cp.text },
					["@tag.attribute"] = { fg = cp.mauve, style = { "italic" } },
					["@tag"] = { fg = cp.peach },
					["@tag.delimiter"] = { fg = cp.maroon },
					["@text"] = { fg = cp.text },
					-- ["@text.uri"] = { fg = cp.rosewater, style = { "italic", "underline" } },
					-- ["@text.literal"] = { fg = cp.teal, style = { "italic" } },
					["@text.reference"] = { fg = cp.lavender, style = { "bold" } },
					-- ["@text.title"] = { fg = cp.blue, style = { "bold" } },
					-- ["@text.emphasis"] = { fg = cp.maroon, style = { "italic" } },
					-- ["@text.strong"] = { fg = cp.maroon, style = { "bold" } },
					-- ["@string.escape"] = { fg = cp.pink },

					-- ["@property.toml"] = { fg = cp.blue },
					-- ["@field.yaml"] = { fg = cp.blue },

					-- ["@label.json"] = { fg = cp.blue },

					["@function.builtin.bash"] = { fg = cp.red, style = { "italic" } },
					["@parameter.bash"] = { fg = cp.yellow, style = { "italic" } },
					["@field.lua"] = { fg = cp.lavender },
					["@constructor.lua"] = { fg = cp.flamingo },
					["@constant.java"] = { fg = cp.teal },
					["@property.typescript"] = { fg = cp.lavender, style = { "italic" } },
					-- ["@constructor.typescript"] = { fg = cp.lavender },

					-- ["@constructor.tsx"] = { fg = cp.lavender },
					-- ["@tag.attribute.tsx"] = { fg = cp.mauve },

					["@type.css"] = { fg = cp.lavender },
					["@property.css"] = { fg = cp.yellow, style = { "italic" } },
					["@type.builtin.c"] = { fg = cp.yellow, style = {} },
					["@property.cpp"] = { fg = cp.text },
					["@type.builtin.cpp"] = { fg = cp.yellow, style = {} },
					-- ["@symbol"] = { fg = cp.flamingo },
				}
			end,
		},
	}
	-- return {
	--   flavour = "mocha", -- latte, frappe, macchiato, mocha
	--   background = { -- :h background
	--     light = "latte",
	--     dark = "mocha",
	--   },
	--   transparent_background = true,
	--   term_colors = true,
	--   dim_inactive = {
	--     enabled = false,
	--     shade = "dark",
	--     percentage = 0.1,
	--   },
	--   no_italic = false, -- Force no italic
	--   no_bold = false, -- Force no bold
	--   styles = {
	--     comments = { "italic" },
	--     conditionals = { "italic" },
	--     loops = {},
	--     functions = {},
	--     keywords = {},
	--     strings = {},
	--     variables = {},
	--     numbers = {},
	--     booleans = {},
	--     properties = {},
	--     types = {},
	--     operators = {},
	--   },
	--   color_overrides = {},
	--   custom_highlights = function(colors)
	--     return {
	--       CursorLine = { link = "ColorColumn" },
	--       LineNr = {
	--         fg = U.darken(colors.blue, 0.6, colors.base),
	--       },
	--       CursorLineNr = {
	--         fg = U.darken(colors.lavender, 1.2, colors.base),
	--       },
	--       -- FloatBorder = { fg = colors.base },
	--       --, -- Scr
	--
	--       -- 			-- "#ff0000",
	--       -- 			-- "#00ff00",
	--       -- 			-- "#00ffff",
	--       -- 			-- ["rainbowcol1"] = { fg = "#ff0000" },
	--       -- 			-- ["rainbowcol2"] = { fg = "#00ff00" },
	--       -- 			-- ["rainbowcol3"] = { fg = "#00ffff" },
	--       -- 			-- ["rainbowcol4"] = { fg = "#ff0000" },
	--       -- 			-- ["rainbowcol5"] = { fg = "#00ff00" },
	--       -- 			-- ["rainbowcol6"] = { fg = "#00ffff" },
	--       ["IndentBlanklineIndent1"] = { fg = colors.maroon },
	--       ["IndentBlanklineIndent2"] = { fg = colors.peach },
	--       ["IndentBlanklineIndent3"] = { fg = colors.green },
	--       ["IndentBlanklineIndent4"] = { fg = colors.teal },
	--       ["IndentBlanklineIndent5"] = { fg = colors.blue },
	--       ["IndentBlanklineIndent6"] = { fg = colors.mauve },
	--     }
	--   end,
	--   integrations = {
	--     dap = {
	--       enabled = true,
	--       enable_ui = true, -- enable nvim-dap-ui
	--     },
	--     -- toggleterm= true,
	--     harpoon = true,
	--     dashboard = false,
	--     markdown = true,
	--     mason = true,
	--     hop = false,
	--     leap = true,
	--     which_key = true,
	--     fidget = true,
	--
	--     native_lsp = {
	--       enabled = true,
	--       virtual_text = {
	--         errors = { "italic" },
	--         hints = { "italic" },
	--         warnings = { "italic" },
	--         information = { "italic" },
	--       },
	--       underlines = {
	--         errors = { "underline" },
	--         hints = { "underline" },
	--         warnings = { "underline" },
	--         information = { "underline" },
	--       },
	--     },
	--     -- indent_blankline = {
	--     -- 	enabled = true,
	--     -- 	colored_indent_levels = true,
	--     -- },
	--     cmp = true,
	--     ts_rainbow = true,
	--     gitsigns = true,
	--     nvimtree = true,
	--     treesitter = true,
	--     telescope = true,
	--     notify = false,
	--     mini = false,
	--     -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
	--   },
	-- }
else
	return {}
end
