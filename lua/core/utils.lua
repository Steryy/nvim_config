local M = {}
local merge_tb = vim.tbl_deep_extend

M.lazy_load = function(plugin)
	vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
		group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
		callback = function()
			local file = vim.fn.expand("%")
			local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

			if condition then
				vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

				-- dont defer for treesitter as it will show slow highlighting
				-- This deferring only happens only when we do "nvim filename"
				if plugin ~= "nvim-treesitter" then
					vim.schedule(function()
						require("lazy").load({ plugins = plugin })

						if plugin == "nvim-lspconfig" then
							vim.cmd("silent! do FileType")
						end
					end, 0)
				else
					require("lazy").load({ plugins = plugin })
				end
			end
		end,
	})
end
local Util = {}

function Util.info(msg, opts)
	opts = opts or {}
	opts.level = vim.log.levels.INFO
	Util.notify(msg, opts)
end

function Util.warn(msg, opts)
	opts = opts or {}
	opts.level = vim.log.levels.WARN
	Util.notify(msg, opts)
end

function Util.notify(msg, opts)
	if vim.in_fast_event() then
		return vim.schedule(function()
			Util.notify(msg, opts)
		end)
	end

	opts = opts or {}
	if type(msg) == "table" then
		msg = table.concat(
			vim.tbl_filter(function(line)
				return line or false
			end, msg),
			"\n"
		)
	end
	local lang = opts.lang or "markdown"
	vim.notify(msg, opts.level or vim.log.levels.INFO, {
		on_open = function(win)
			pcall(require, "nvim-treesitter")
			vim.wo[win].conceallevel = 3
			vim.wo[win].concealcursor = ""
			vim.wo[win].spell = false
			local buf = vim.api.nvim_win_get_buf(win)
			if not pcall(vim.treesitter.start, buf, lang) then
				vim.bo[buf].filetype = lang
				vim.bo[buf].syntax = lang
			end
		end,
		title = opts.title or "lazy.nvim",
	})
end

local enabled = true
function M.toggle_diagnostics()
	enabled = not enabled
	if enabled then
		vim.diagnostic.enable()
		Util.info("Enabled diagnostics", { title = "Diagnostics" })
	else
		vim.diagnostic.disable()
		Util.warn("Disabled diagnostics", { title = "Diagnostics" })
	end
end

function M.toggle(option, silent, values)
	if values then
		if vim.opt_local[option]:get() == values[1] then
			vim.opt_local[option] = values[2]
		else
			vim.opt_local[option] = values[1]
		end
		return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
	end
	vim.opt_local[option] = not vim.opt_local[option]:get()
	if not silent then
		if vim.opt_local[option]:get() then
			Util.info("Enabled " .. option, { title = "Option" })
		else
			Util.warn("Disabled " .. option, { title = "Option" })
		end
	end
end

function M.get_icon(kind)
	local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"
	if not M[icon_pack] then
		M.icons = require("core.icons.nerd_font")
		M.text_icons = require("core.icons.text")
	end
	return M[icon_pack] and M[icon_pack][kind] or ""
end

function M.is_available(plugin)
	local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
	return lazy_config_avail and lazy_config.plugins[plugin] ~= nil
end

function M.telescope(builtin, opts)
	local params = { builtin = builtin, opts = opts }

	builtin = params.builtin
	opts = params.opts
	local tels = require("telescope.builtin")[builtin]
	local function a()
		local error, _ = pcall(tels, opts)

		if not error and string.find(builtin,"git")~=-1 then
			local cwd = vim.loop.cwd()

			print(cwd .. " dont have git directory")
		end
	end
    return a
end

return M
