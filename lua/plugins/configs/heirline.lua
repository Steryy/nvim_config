
local get_icon = require("core.utils").get_icon
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local is_c, colors_func = pcall(require, "utils.lualine_autoflip")
local icons = {
	error = get_icon("DiagnosticError"),
	warn = get_icon("DiagnosticWarn"),
	info = get_icon("DiagnosticInfo"),
	hint = get_icon("DiagnosticHint"),
	gitBranch = get_icon("GitBranch"),
	gitadd = get_icon("GitAdd"),
	gitdelete = get_icon("GitDelete"),
	gitchannge = get_icon("GitChange"),
	modified = get_icon("FileModified"),
	readonly = get_icon("FileReadOnly"),
}
local BGCOLOR = "#ff0000"
local HILIGHTS = {
	filename = "Status__filename",
	gitAdd = "Status__gitAdded",
	gitChange = "Status__gitChanged",
	gitRemove = "Status__gitRemoved",
	iconColor = "Status__IconColor",
	diagnosticsError = "DiagnosticSignError",
	diagnosticsWarn = "DiagnosticSignWarn",
	diagnosticsHint = "DiagnosticSignHint",
	diagnosticsInfo = "DiagnosticSignInfo",
	ainsert = "Status__InsertA",
	binsert = "Status__InsertB",
	avisual = "Status__VisualA",
	bvisual = "Status__VisualB",
	acommand = "Status__CommandA",
	bcommand = "Status__CommandB",
	areplace = "Status__ReplaceA",
	breplace = "Status__ReplaceB",
	serverNames = "Status__ServerName",

	aterminal = "Status__TerminalA",
	bterminal = "Status__TerminalB",

	anormal = "Status__NormalA",
	bnormal = "Status__NormalB",
}
local function hilight(text, hl)
	local col = vim.fn.hlexists(hl)
	if col == 0 then
		hl = "NORMAL"
	end
	return ("%%#%s#%s%%0*"):format(hl, text)
end

local function null_ls_providers(filetype)
	local registered = {}
	-- try to load null-ls
	local sources_avail, sources = pcall(require, "null-ls.sources")

	local methods_avail, methods = pcall(require, "null-ls.methods")
	if not methods_avail then
		return {}
	end
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
	return registered, methods.internal
end
local function extract_highlight_colors(color_group, scope, default)
	color_group = type(color_group) == "string" and { color_group }
		or color_group

	for key, group in pairs(color_group) do
		local color = vim.fn.hlexists(group)

		if color ~= 0 then
			color = vim.api.nvim_get_hl_by_name(group, true)
			if color then
				if color.background ~= nil then
					color.bg = string.format("#%06x", color.background)
					color.background = nil
				end
				if color.foreground ~= nil then
					color.fg = string.format("#%06x", color.foreground)
					color.foreground = nil
				end
				if color.special ~= nil then
					color.sp = string.format("#%06x", color.special)
					color.special = nil
				end
				if color and scope and color[scope] then
					return color[scope]
				end
			end
		end
	end
	return default
end
local function createHilight(fg, name, special)
	local tab = { fg = fg, bg = BGCOLOR }
	if special then
		tab = vim.tbl_extend("force", tab, special)
	end

	vim.api.nvim_set_hl(0, name, tab)
	return name
end

local colors = {}
local function setup_colors()
	colors = {
		bright_bg = utils.get_highlight("Folded").bg,
		bright_fg = utils.get_highlight("Folded").fg,
		red = utils.get_highlight("DiffDelete").fg,
		dark_red = utils.get_highlight("DiffDelete").bg,
		green = utils.get_highlight("String").fg,
		blue = utils.get_highlight("Function").fg,
		gray = utils.get_highlight("NonText").fg,
		orange = utils.get_highlight("Constant").fg,
		purple = utils.get_highlight("Statement").fg,
		cyan = utils.get_highlight("Special").fg,
		diag_warn = utils.get_highlight("DiagnosticWarn").fg,
		diag_error = utils.get_highlight("DiagnosticError").fg,
		diag_hint = utils.get_highlight("DiagnosticHint").fg,
		diag_info = utils.get_highlight("DiagnosticInfo").fg,
		git_del = extract_highlight_colors(
			"fg",
			{ "GitSignsDelete", "GitGutterDelete", "DiffRemoved", "DiffDelete" },
			"#ff0038"
		),
		git_add = extract_highlight_colors(
			{ "GitSignsAdd", "GitGutterAdd", "DiffAdded", "DiffAdd" },
			"fg",
			"#90ee90"
		),
		git_change = extract_highlight_colors(
			"fg",
			{ "GitSignsChange", "GitGutterChange", "DiffChanged", "DiffChange" },
			"#f0e130"
		),
		filename = utils.get_highlight("GitSignsAdd").fg,
	}

	local def_colors = {
		normal = {
			a = { bg = "#000011", fg = "#ff0000", gui = "bold" },
			b = { bg = "#000011", fg = "#ff0000" },
			c = { bg = "#000011", fg = "#ffffff" },
		},
		insert = {
			a = { bg = "#000011", fg = "#00ff00", gui = "bold" },
			b = { bg = "#000011", fg = "#00ff00" },
			c = { bg = "#000011", fg = "#ffffff" },
		},
		replace = {
			a = { bg = "#000011", fg = "#00ffff", gui = "bold" },
			b = { bg = "#000011", fg = "#00ffff" },
			c = { bg = "#000011", fg = "#ffffff" },
		},
		visual = {
			a = { bg = "#000011", fg = "#0000ff", gui = "bold" },
			b = { bg = "#000011", fg = "#0000ff" },
			c = { bg = "#000011", fg = "#ffffff" },
		},
		command = {
			a = { bg = "#000011", fg = "#ffff00", gui = "bold" },
			b = { bg = "#000011", fg = "#ffff00" },
			c = { bg = "#000011", fg = "#ffffff" },
		},
		terminal = {
			a = { bg = "#000011", fg = "#ff0000", gui = "bold" },
			b = { bg = "#000011", fg = "#ff0000" },
			c = { bg = "#000011", fg = "#ffffff" },
		},
	}
	local lua_colors = {}
	if is_c then
		lua_colors = colors_func()
	end
	for key, value in pairs(def_colors) do
		for sec, tab in pairs(value) do
			if lua_colors[key] and lua_colors[key][sec] then
				colors[sec .. key] = lua_colors[key][sec].fg
			elseif lua_colors.normal and lua_colors.normal[sec] then
				colors[sec .. key] = lua_colors.normal[sec].fg
			end
			if not colors[sec .. key] then
				colors[sec .. key] = def_colors[key][sec].fg
			end
		end
	end

	return colors
end
local function updateHilights()
	BGCOLOR = extract_highlight_colors({ "Normal" }, "bg", "NONE")
	-- if true then
	--     BGCOLOR = "#000000"
	-- end

	local fg = extract_highlight_colors(
		{ "GitSignsAdd", "GitGutterAdd", "DiffAdded", "DiffAdd" },
		"fg",
		"#90eeee"
	)
	createHilight(fg, HILIGHTS.filename)

	fg = extract_highlight_colors(
		{ "GitSignsAdd", "GitGutterAdd", "DiffAdded", "DiffAdd" },
		"fg",
		"#90ee90"
	)
	createHilight(fg, HILIGHTS.serverNames)

	fg = extract_highlight_colors(
		{ "GitSignsAdd", "GitGutterAdd", "DiffAdded", "DiffAdd" },
		"fg",
		"#90ee90"
	)
	createHilight(fg, HILIGHTS.gitAdd)
	fg = extract_highlight_colors(
		"fg",
		{ "GitSignsChange", "GitGutterChange", "DiffChanged", "DiffChange" },
		"#f0e130"
	)

	createHilight(fg, HILIGHTS.gitChange)
	fg = extract_highlight_colors(
		"fg",
		{ "GitSignsDelete", "GitGutterDelete", "DiffRemoved", "DiffDelete" },
		"#ff0038"
	)

	createHilight(fg, HILIGHTS.gitRemove)

	if is_c then
		colors = colors_func()
	end
	-- is_c = false
	if not is_c then
		colors = {
			normal = {
				a = { bg = "#000011", fg = "#ff0000", gui = "bold" },
				b = { bg = "#000011", fg = "#ff0000" },
				c = { bg = "#000011", fg = "#ffffff" },
			},
			insert = {
				a = { bg = "#000011", fg = "#00ff00", gui = "bold" },
				b = { bg = "#000011", fg = "#00ff00" },
				c = { bg = "#000011", fg = "#ffffff" },
			},
			replace = {
				a = { bg = "#000011", fg = "#00ffff", gui = "bold" },
				b = { bg = "#000011", fg = "#00ffff" },
				c = { bg = "#000011", fg = "#ffffff" },
			},
			visual = {
				a = { bg = "#000011", fg = "#0000ff", gui = "bold" },
				b = { bg = "#000011", fg = "#0000ff" },
				c = { bg = "#000011", fg = "#ffffff" },
			},
			command = {
				a = { bg = "#000011", fg = "#ffff00", gui = "bold" },
				b = { bg = "#000011", fg = "#ffff00" },
				c = { bg = "#000011", fg = "#ffffff" },
			},
		}
	end

	for key, value in pairs(colors) do
		local name = string.lower(key)
		if HILIGHTS["a" .. name] then
			createHilight(value.a.fg, HILIGHTS["a" .. name])
		end

		if HILIGHTS["b" .. name] then
			createHilight(value.b.fg, HILIGHTS["b" .. name])
		end
	end
end

local function filetypeFunc()
	local filetype = vim.bo.filetype or "nil"
	local icon_highlight_group
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if ok then
		_, icon_highlight_group = devicons.get_icon(vim.fn.expand("%:t"))
		if icon_highlight_group == nil then
			_, icon_highlight_group =
				devicons.get_icon_by_filetype(vim.bo.filetype)
		end
		if icon_highlight_group == nil then
			icon_highlight_group = "devicondefault"
		end
	end
	local col = extract_highlight_colors(icon_highlight_group, "fg")

	if filetype and string.len(filetype) > 0 then
		return "[" .. filetype .. "] "
	end
	return ""
end

local function serverNames()
	local names =
		{ lsp = false, format = false, diagnostics = false, spell = false }
	local name = 0
	for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
		if server.name == "null-ls" then
			local servers, types = null_ls_providers(vim.bo.filetype)
			if type(types) == "table" and type(servers) == "table" then
				local diag = servers[types.DIAGNOSTICS]
				local form = servers[types.FORMATTING]
				if type(form) == "table" and #form > 0 then
					names.format = "F"
				end
				if type(diag) == "table" and #diag > 0 then
					names.diagnostics = "D"
				end
			end
		elseif not names.lsp then
			names.lsp = "L"
		end
	end
	local str = ""
	for key, value in pairs(names) do
		if value ~= false then
			str = value .. " " .. str
		end
	end
	if string.len(str) > 0 then
		str = "[ " .. str .. "] "
	end
	return str

	-- if name ==0 then
	--     return ""
	-- end
	-- return hilight(
	--     "[" .. name .. "] ",
	--     HILIGHTS.serverNames
	-- )
end
local function gitDiffFunc()
	local str = ""
	local status_dict = vim.b.gitsigns_status_dict
	if status_dict then
		local added = status_dict.added or 0
		local removed = status_dict.removed or 0
		local changed = status_dict.changed or 0
		local addgroup = HILIGHTS.gitAdd
		local delgroup = HILIGHTS.gitRemove
		local diffgroup = HILIGHTS.gitChange
		if added > 0 then
			str = hilight(get_icon("GitAdd") .. added, addgroup) .. " "
		end

		if removed > 0 then
			str = str
				.. hilight(get_icon("GitDelete") .. removed, delgroup)
				.. " "
		end
		if changed > 0 then
			str = str
				.. hilight(get_icon("GitChange") .. changed, diffgroup)
				.. " "
		end
		return str
	end
	return ""
end

local function diagnosticFunc()
	local error_count, warning_count, info_count, hint_count = 0, 0, 0, 0
	local str = " "
	if vim.fn.has("nvim-0.6") == 1 then
		-- On nvim 0.6+ use vim.diagnostic to get lsp generated diagnostic count.
		local diagnostics = vim.diagnostic.get(0)
		local count = { 0, 0, 0, 0 }
		for _, diagnostic in ipairs(diagnostics) do
			if
				vim.startswith(
					vim.diagnostic.get_namespace(diagnostic.namespace).name,
					"vim.lsp"
				)
			then
				count[diagnostic.severity] = count[diagnostic.severity] + 1
			end
		end
		error_count = count[vim.diagnostic.severity.ERROR]
		warning_count = count[vim.diagnostic.severity.WARN]
		info_count = count[vim.diagnostic.severity.INFO]
		hint_count = count[vim.diagnostic.severity.HINT]
	else
		-- On 0.5 use older vim.lsp.diagnostic module.
		-- Maybe we should phase out support for 0.5 though I haven't yet found a solid reason to.
		-- Eventually this will be removed when 0.5 is no longer supported.
		error_count = vim.lsp.diagnostic.get_count(0, "Error")
		warning_count = vim.lsp.diagnostic.get_count(0, "Warning")
		info_count = vim.lsp.diagnostic.get_count(0, "Information")
		hint_count = vim.lsp.diagnostic.get_count(0, "Hint")
	end

	if error_count > 0 then
		str = str
			.. hilight(icons.error .. error_count, HILIGHTS.diagnosticsError)
			.. " "
	end
	if warning_count > 0 then
		str = str
			.. hilight(icons.warn .. warning_count, HILIGHTS.diagnosticsWarn)
			.. " "
	end
	if info_count > 0 then
		str = str
			.. hilight(icons.info .. info_count, HILIGHTS.diagnosticsInfo)
			.. " "
	end
	return str
end
-- MIT license, see LICENSE for more details.
local Mode = {}

-- stylua: ignore
Mode.map = {
	['n']     = 'NORMAL',
	['no']    = 'O-PENDING',
	['nov']   = 'O-PENDING',
	['noV']   = 'O-PENDING',
	['no\22'] = 'O-PENDING',
	['niI']   = 'NORMAL',
	['niR']   = 'NORMAL',
	['niV']   = 'NORMAL',
	['nt']    = 'NORMAL',
	['ntT']   = 'NORMAL',
	['v']     = 'VISUAL',
	['vs']    = 'VISUAL',
	['V']     = 'V-LINE',
	['Vs']    = 'V-LINE',
	['\22']   = 'V-BLOCK',
	['\22s']  = 'V-BLOCK',
	['s']     = 'SELECT',
	['S']     = 'S-LINE',
	['\19']   = 'S-BLOCK',
	['i']     = 'INSERT',
	['ic']    = 'INSERT',
	['ix']    = 'INSERT',
	['R']     = 'REPLACE',
	['Rc']    = 'REPLACE',
	['Rx']    = 'REPLACE',
	['Rv']    = 'V-REPLACE',
	['Rvc']   = 'V-REPLACE',
	['Rvx']   = 'V-REPLACE',
	['c']     = 'COMMAND',
	['cv']    = 'EX',
	['ce']    = 'EX',
	['r']     = 'REPLACE',
	['rm']    = 'MORE',
	['r?']    = 'CONFIRM',
	['!']     = 'SHELL',
	['t']     = 'TERMINAL',
}
---@return string current mode name
local currentMode = HILIGHTS.anormal
function Mode.get_mode()
	local mode_code = vim.fn.mode(1)
	if Mode.map[mode_code] == nil then
		return mode_code
	end
	local mode = Mode.map[mode_code]
	if mode_code=="t" and vim.bo.filetype=="fzf" then
		return " ".."FZF".." "
	end
	return " " .. mode .. " "
end

local function gitBranchFunc()
	-- local buffer = vim.api.nvim_get_current_buf()
	local branch = nil

	if vim.g.loaded_fugitive == 1 then
		branch = vim.fn.FugitiveHead() or nil
	end
	if not branch or #branch == 0 then
		local ok = vim.b.gitsigns_status_dict
		if ok and ok.head then
			branch = ok.head
		end
	end
	if branch and #branch > 0 then
		return icons.gitBranch .. " " .. branch .. " "
	end
	return ""
end
local function progressFunc()
	local cur = vim.fn.line(".")
	local total = vim.fn.line("$")
	local str = "Top"
	if cur == total then
		str = "Bot"
	else
		str = string.format("%2d%%%%", math.floor(cur / total * 100))
	end
	return str
end
local function clockFunc()
	return os.date("%R")
end

local function filenameFunc()
	local data
	-- relative path
	data = vim.fn.expand("%:~:.")
	-- local windwidth = self.options.globalstatus and vim.go.columns or vim.fn.winwidth(0)
	-- local estimated_space_available = windwidth - self.options.shorting_target
	--
	-- -- data = shorten_path(data, path_separator, estimated_space_available)

	local symbols = {}
	if vim.bo.modified then
		table.insert(symbols, icons.modified)
	end
	if vim.bo.modifiable == false or vim.bo.readonly == true then
		table.insert(symbols, icons.readonly)
	end

	-- return hilight(data .. " " .. (#symbols > 0 and " " .. table.concat(symbols, "") or ""), HILIGHTS.filename)
	return data .. (#symbols > 0 and " " .. table.concat(symbols, "") or "")
end

local function encodingFunc()
	local str = vim.opt.fileencoding:get()
	return type(str) == "string" and string.upper(str) .. " "
end

updateHilights()

local left_def = {

	{
		provider = clockFunc,

		hl = function(self)
			self.mode = vim.fn.mode(1)
			local mode = self.mode:sub(1, 1) -- get only the first mode character
			local mo = "b" .. self.mode_colors[mode]
			if colors and colors[mo] then
				return { fg = mo, bold = true }
			end
			return { fg = "#ffffff" }
		end,
	},
	{
		provider = Mode.get_mode,
		hl = function(self)
			self.mode = vim.fn.mode(1)
			local mode = self.mode:sub(1, 1) -- get only the first mode character
			local mo = "a" .. self.mode_colors[mode]
			if colors and colors[mo] then
				return { fg = mo, bold = true }
			end
			return { fg = "#ffffff" }
		end,
		update = {
			"ModeChanged",
			pattern = "*:*",
			callback = vim.schedule_wrap(function()
				vim.cmd("redrawstatus")
			end),
		},
	},

	{
		init = function(self)
			local filename = vim.api.nvim_buf_get_name(0)
			local extension = vim.fn.fnamemodify(filename, ":e")
			self.icon, self.icon_color =
				require("nvim-web-devicons").get_icon_color(
					filename,
					extension,
					{ default = true }
				)
			self.filetype = vim.bo.filetype or "nil"
		end,

		provider = function(self)
			if self.filetype then
				return "[" .. self.filetype .. "] "
			end
			return ""
		end,
		hl = function(self)
			return { fg = self.icon_color }
		end,
	},
}
local right_def = {

	{
		provider = encodingFunc,

		hl = function(self)
			self.mode = vim.fn.mode(1)
			local mode = self.mode:sub(1, 1) -- get only the first mode character
			local mo = "b" .. self.mode_colors[mode]
			if colors and colors[mo] then
				return { fg = mo, bold = true }
			end
			return { fg = "#ffffff" }
		end,
	},

	-- {
	--     provider = locationFunc,
	--
	--     hl = function(self)
	--         self.mode = vim.fn.mode(1)
	--         local mode = self.mode:sub(1, 1) -- get only the first mode character
	--         local mo = "b" .. self.mode_colors[mode]
	--         if colors and colors[mo] then
	--             return { fg = mo, bold = true }
	--         end
	--         return { fg = "#ffffff" }
	--     end,
	-- },

	-- Column Number

	{
		provider = progressFunc,

		hl = function(self)
			self.mode = vim.fn.mode(1)
			local mode = self.mode:sub(1, 1) -- get only the first mode character
			local mo = "a" .. self.mode_colors[mode]
			if colors and colors[mo] then
				return { fg = mo, bold = true }
			end
			return { fg = "#ffffff" }
		end,
	},
}

vim.opt.showcmdloc = "statusline"
local ShowCmd = {
	condition = function()
		return vim.o.cmdheight == 0
	end,
	provider = "%3.5(%S%) ",
}
local defaultstatusline = {
	left_def,

	{
		provider = filenameFunc,

		hl = function(self)
			return { fg = colors.filename }
		end,
	},

	-- }}}

	-- MIDDLE {{{
	{ provider = "%=" },
	-- }}}
	ShowCmd,
	-- RIGHT {{{

	{
		condition = conditions.has_diagnostics,
		provider = diagnosticFunc,
		update = { "DiagnosticChanged", "BufEnter" },
	},
	{
		condition = conditions.lsp_attached,
		update = { "LspAttach", "LspDetach" },
		hl = function()
			return { fg = colors.purple }
		end,
		-- You can keep it simple,
		-- provider = " [LSP]",

		-- Or complicate things a bit and get the servers names
		provider = serverNames,
	},
	{
		condition = conditions.is_git_repo,
		provider = gitBranchFunc,
	},
	{
		condition = conditions.is_git_repo,
		init = function(self)
			self.status_dict = vim.b.gitsigns_status_dict
			self.has_changes = false
			if type(self.status_dict) == "table" then
				self.has_changes = self.status_dict.added ~= 0
					or self.status_dict.removed ~= 0
					or self.status_dict.changed ~= 0
			else
				self.status_dict = {}
			end
		end,
		{
			provider = function(self)
				local count = self.status_dict.added or 0
				return count > 0 and (icons.gitadd .. count .. " ")
			end,
			hl = { fg = "git_add" },
		},
		{
			provider = function(self)
				local count = self.status_dict.removed or 0
				return count > 0 and (icons.gitdelete .. count .. " ")
			end,
			hl = { fg = "git_del" },
		},
		{
			provider = function(self)
				local count = self.status_dict.changed or 0
				return count > 0 and (icons.gitchannge .. count .. " ")
			end,
			hl = { fg = "git_change" },
		},

		-- provider = gitDiffFunc,
	},
	right_def,
}

local prompt = {
	condition = function()
		return conditions.buffer_matches({
			buftype = { "nofile", "prompt", "help", "quickfix" },
			filetype={"fzf"},
		})
	end,

	left_def,
	{
		provider = function()
			local cwd = vim.fn.getcwd(0)
			cwd = vim.fn.fnamemodify(cwd, ":~")
			return " " .. cwd
		end,
		hl = function(self)
			return { fg = colors.filename, bg = colors.bg }
		end,
	},

	{ provider = "%=" },
	right_def,
}

local oil = {
	condition = function()
		return conditions.buffer_matches({
			filetype = { "oil", "dirbuf" },
		})
	end,
	left_def,

	{
		provider = function()
			local filename = vim.api.nvim_buf_get_name(0)
			local data = vim.fn.fnamemodify(
				string.gsub(filename, [[oil://]], ""),
				":~:."
			)
			if data == "" then
				data = "."
			end

			return data
		end,
		hl = function(self)
			return { fg = colors.filename }
		end,
	},

	{ provider = "%=" },

	right_def,
}
local fugitive = {
	condition = function()
		return conditions.buffer_matches({
			filetype = { "^git.*", "fugitive" },
		})
	end,
	left_def,

	{
		provider = function()
			local cwd = vim.fn.getcwd(0)
			cwd = vim.fn.fnamemodify(cwd, ":~")
			return " " .. cwd
		end,
		hl = function(self)
			return { fg = colors.filename }
		end,
	},

	{ provider = "%=" },

	{
		provider = gitBranchFunc,
	},
	{
		provider = gitDiffFunc,
	},
	right_def,
}

require("heirline").load_colors(setup_colors)
-- or pass it to config.opts.colors

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		updateHilights()
		utils.on_colorscheme(setup_colors)
	end,
	group = "Heirline",
})
require("heirline").setup({
	statusline = {
		static = {
			mode_colors = {
				n = "normal",
				i = "insert",
				v = "visual",
				V = "visual",
				["\22"] = "visual",
				c = "orange",
				s = "purple",
				S = "purple",
				["\19"] = "purple",
				R = "orange",
				r = "orange",
				["!"] = "red",
				t = "red",
			},
		},
		fallthrough = false,
		fugitive,
		oil,
		prompt,
		defaultstatusline,
	},
})
