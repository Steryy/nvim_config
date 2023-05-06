local gl = require("galaxyline")
local get_icon = require("core.utils").get_icon
-- Galaxyline example
local colors = require("galaxyline.theme").default
local fileinfo = require("galaxyline.provider_fileinfo")
colors.bg = "NONE"

colors.cyan = "#33dbc3"
local condition = require("galaxyline.condition")
local gls = gl.section

local function null_ls_providers(filetype)
	local registered = {}
	-- try to load null-ls
	local sources_avail, sources = pcall(require, "null-ls.sources")
	if sources_avail then
		-- get the available sources of a given filetype
		for _, source in ipairs(sources.get_available(filetype)) do
			-- get each source name
			for method in pairs(source.methods) do
				registered[method] = registered[method] or {}
				table.insert(registered[method], source.name)
			end
		end
	end
	-- return the found null-ls sources
	return registered
end
local function null_ls_sources(filetype, method)
	local methods_avail, methods = pcall(require, "null-ls.methods")
	return methods_avail and null_ls_providers(filetype)[methods.internal[method]] or {}
end
gl.short_line_list = { "NvimTree", "vista", "dbui", "packer" }

gls.left[1] = {
	ViMode = {
		provider = function()
			-- auto change color according the vim mode
			local mode_color = {
				n = colors.red,
				i = colors.green,
				v = colors.blue,
				[""] = colors.blue,
				V = colors.blue,
				c = colors.magenta,
				no = colors.red,
				s = colors.orange,
				S = colors.orange,
				[""] = colors.orange,
				ic = colors.yellow,
				R = colors.violet,
				Rv = colors.violet,
				cv = colors.red,
				ce = colors.red,
				r = colors.cyan,
				rm = colors.cyan,
				["r?"] = colors.cyan,
				["!"] = colors.red,
				t = colors.red,
			}

			local modes = {
				["c"] = "COMMAND-LINE",
				["ce"] = "NORMAL EX",
				["cv"] = "EX",

				["i"] = "INSERT",

				["ic"] = "INS-COMPLETE",
				["ix"] = "INS-COMPLETE",
				["Rc"] = "REP-COMPLETE",
				["Rvc"] = "VIRT-REP-COMPLETE",
				["Rvx"] = "VIRT-REP-COMPLETE",
				["Rx"] = "REP-COMPLETE",

				["n"] = "NORMAL",
				["niI"] = "INS-NORMAL",
				["niR"] = "REP-NORMAL",
				["niV"] = "VIRT-REP-NORMAL",
				["nt"] = "TERM-NORMAL",
				["ntT"] = "TERM-NORMAL",

				["no"] = "OPERATOR-PENDING",
				["nov"] = "CHAR OPERATOR-PENDING",
				["noV"] = "LINE OPERATOR-PENDING",
				["no"] = "BLOCK OPERATOR-PENDING",

				["R"] = "REPLACE",
				["Rv"] = "VIRT-REPLACE",

				["r"] = "HIT-ENTER",
				["rm"] = "--MORE",
				["r?"] = ":CONFIRM",

				["s"] = "SELECT",
				["S"] = "SELECT LINE",
				[""] = "SELECT",

				["v"] = "VISUAL",
				["vs"] = "SEL-VISUAL",
				["V"] = "VISUAL LINE",
				["Vs"] = "SEL-VISUAL LINE",
				[""] = "VISUAL BLOCK",
				["s"] = "VISUAL BLOCK",

				["t"] = "TERMINAL",
				["!"] = "SHELL",

				-- libmodal
			}
			local mode = vim.fn.mode()
			vim.api.nvim_command("hi GalaxyViMode guifg=" .. mode_color[mode])
			return "▊ " .. modes[mode] .. " "
		end,
		highlight = { colors.red, colors.bg, "bold" },
	},
}
gls.left[3] = {
	FileSize = {
		provider = "FileSize",
		condition = condition.buffer_not_empty,
		highlight = { colors.fg, colors.bg, "bold" },
	},
}
gls.left[4] = {
	FileIcon = {
		provider = "FileIcon",
		condition = condition.buffer_not_empty,
		highlight = { require("galaxyline.provider_fileinfo").get_file_icon_color, colors.bg },
	},
}

gls.left[5] = {
	FileName = {
		provider = function()
			return fileinfo.get_current_file_name(get_icon("FileModified"), get_icon("FileReadOnly"))
		end,
		condition = condition.buffer_not_empty,
		highlight = { colors.magenta, colors.bg, "bold" },
	},
}

gls.left[7] = {
	LineInfo = {
		provider = "LineColumn",
		separator = " ",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.fg, colors.bg },
	},
}

gls.left[6] = {
	PerCent = {
		provider = "LinePercent",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.fg, colors.bg, "bold" },
	},
}

gls.left[8] = {
	DiagnosticError = {
		provider = "DiagnosticError",
		icon = get_icon("DiagnosticError"),
		highlight = { colors.red, colors.bg },
	},
}
gls.left[9] = {
	DiagnosticWarn = {
		provider = "DiagnosticWarn",
		icon = get_icon("DiagnosticWarn"),
		highlight = { colors.yellow, colors.bg },
	},
}

gls.left[10] = {
	DiagnosticHint = {
		provider = "DiagnosticHint",
		icon = get_icon("DiagnosticHint"),
		highlight = { colors.cyan, colors.bg },
	},
}

gls.left[11] = {
	DiagnosticInfo = {
		provider = "DiagnosticInfo",
		icon = get_icon("DiagnosticInfo"),
		highlight = { colors.blue, colors.bg },
	},
}

gls.right[1] = {
	ShowLspClient = {
		provider = function()
			local names = {}
			for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
				if server.name == "null-ls" then
					for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
						for _, source in ipairs(null_ls_sources(vim.bo.filetype, type)) do
							table.insert(names, source)
						end
					end
				else
					table.insert(names, server.name)
				end
			end
			return "[" .. table.concat(names, " ") .. "]"
		end,
		condition = function()
			local tbl = { ["dashboard"] = true, [""] = true }
			if tbl[vim.bo.filetype] then
				return false
			end
			return true
		end,
		highlight = { colors.cyan, colors.bg, "bold" },
	},
}

gls.right[2] = {
	FileEncode = {
		provider = "FileEncode",
		condition = condition.hide_in_width,
		separator = " ",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.green, colors.bg, "bold" },
	},
}

--gls.right[2] = {
--	FileFormat = {
--		provider = "FileFormat",
--		condition = condition.hide_in_width,
--		separator = " ",
--		separator_highlight = { "NONE", colors.bg },
--		highlight = { colors.green, colors.bg, "bold" },
--	},
--}
--
gls.right[3] = {
	GitIcon = {
		provider = function()
			return get_icon("GitBranch")
		end,
		condition = condition.check_git_workspace,
		separator = " ",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.violet, colors.bg, "bold" },
	},
}

gls.right[4] = {
	GitBranch = {
		provider = "GitBranch",
		separator_highlight = { "NONE", colors.bg },
		condition = condition.check_git_workspace,
		highlight = { colors.violet, colors.bg, "bold" },
	},
}

gls.right[5] = {
	DiffAdd = {
		provider = "DiffAdd",

		separator = " ",
		separator_highlight = { "NONE", colors.bg },
		condition = condition.hide_in_width,
		icon = get_icon("GitAdd"),
		highlight = { colors.green, colors.bg },
	},
}
gls.right[6] = {
	DiffModified = {
		provider = "DiffModified",
		condition = condition.hide_in_width,
		icon = get_icon("GitChange"),
		highlight = { colors.orange, colors.bg },
	},
}
gls.right[7] = {
	DiffRemove = {
		provider = "DiffRemove",
		condition = condition.hide_in_width,
		icon = get_icon("GitDelete"),
		highlight = { colors.red, colors.bg },
	},
}
gls.right[8] = {
	clock = {
		highlight = { colors.fg, colors.bg, "bold" },
		provider = function()
			return os.date(" H %R")
		end,
	},
}
gls.right[9] = {
	ViModeD = {
		separator = " ",
		separator_highlight = { "NONE", colors.bg },
		provider = function()
			-- auto change color according the vim mode
			local mode_color = {
				n = colors.red,
				i = colors.green,
				v = colors.blue,
				[""] = colors.blue,
				V = colors.blue,
				c = colors.magenta,
				no = colors.red,
				s = colors.orange,
				S = colors.orange,
				[""] = colors.orange,
				ic = colors.yellow,
				R = colors.violet,
				Rv = colors.violet,
				cv = colors.red,
				ce = colors.red,
				r = colors.cyan,
				rm = colors.cyan,
				["r?"] = colors.cyan,
				["!"] = colors.red,
				t = colors.red,
			}

			local mode = vim.fn.mode()
			vim.api.nvim_command("hi GalaxyViModeD guifg=" .. mode_color[mode])
			return "▊"
		end,
		highlight = { colors.red, colors.bg, "bold" },
	},
}

gls.short_line_left[1] = {
	BufferType = {
		provider = "FileTypeName",
		separator = " ",
		separator_highlight = { "NONE", colors.bg },
		highlight = { colors.blue, colors.bg, "bold" },
	},
}

gls.short_line_left[2] = {
	SFileName = {
		provider = "SFileName",
		condition = condition.buffer_not_empty,
		highlight = { colors.fg, colors.bg, "bold" },
	},
}

gls.short_line_right[1] = {
	BufferIcon = {
		provider = "BufferIcon",
		highlight = { colors.fg, colors.bg },
	},
}
