local cmp = require("cmp")
-- local cmp_action = require("lsp-zero").cmp_action()
local conf = {
	duplicates = {
		buffer = 1,
		path = 1,
		nvim_lsp = 1,
		luasnip = 1,
	},
	duplicates_default = 0,

	source_names = {
		nvim_lsp = "(LSP)",
		nvim_lua = "(neovim)",
		emoji = "(Emoji)",
		path = "(Path)",
		async_path = "(As_path)",
		spell = "(spell)",
		calc = "(Cal)",
		dap = "(Dap)",
		cmp_tabnine = "(Tabnine)",
		vsnip = "(Snippet)",
		luasnip = "(snip)",
		nvim_lsp_document_symbol = "(Doc)",
		nvim_lsp_signature_help = "(Func)",
		buffer = "(Buf)",
		tmux = "(TMUX)",
		copilot = "(Copilot)",
		treesitter = "(Tree)",
		orgmode = "(org)",
	},
}

local textchanged = require("cmp.types").cmp.TriggerEvent.TextChanged
local M = {}
-- toggle cmp completion
vim.g.cmp_toggle_flag = false -- initialize
local normal_buftype = function()
	return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
end
M.toggle_completion = function()
	local ok, cmp = pcall(require, "cmp")
	if ok then
		vim.g.cmp_toggle_flag = not vim.g.cmp_toggle_flag
		if vim.g.cmp_toggle_flag then
			print("completion on")
		else
			print("completion off")
		end
		cmp.setup({
			enabled = vim.g.cmp_toggle_flag and normal_buftype or false,

			completion = {
				completeopt = "menu,menuone",
				autocomplete = { textchanged },
			},
		})
	else
		print("completion not available")
	end
end
local select_opts = { behavior = "select" }
local config = {
	completion = {
		completeopt = "menu,menuone",
		autocomplete = false,
	},
	formatting = {
		format = function(entry, vim_item)
			-- vim_item.kind = vim_item.kind or ""
			if vim_item.kind == "Color" and entry.completion_item.documentation then
				local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
				if r then
					local color = string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
					local group = "Tw_" .. color
					if vim.fn.hlID(group) < 1 then
						vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
					end
					vim_item.kind = "■" -- or "⬤" or anything
					vim_item.kind_hl_group = group
				end
			end

			vim_item.menu = conf.source_names[entry.source.name] or entry.source.name
			if entry.completion_item.documentation then
				vim_item.menu = vim_item.menu .. "d"
			end
			-- vim_item.dup = conf.duplicates[entry.source.name] or conf.duplicates_default
			return vim_item
		end,
	},
	sources = {
		{
			name = "spell",
			keyword_length = 2,
			option = {
				keep_all_entries = false,
				enable_in_context = function()
					return true
				end,
			},
		},

		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "nvim_lua" },
		{ name = "async_path" },
	},
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-y>"] = cmp.mapping.confirm({ select = true }),
		["<C-e>"] = cmp.mapping.abort(),
		["<Up>"] = cmp.mapping.select_prev_item(select_opts),
		["<Down>"] = cmp.mapping.select_next_item(select_opts),
		["<C-p>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item(select_opts)
			else
				cmp.complete()
			end
		end),
		["<C-n>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item(select_opts)
			else
				cmp.complete()
			end
		end),
		-- ["<C-f>"] = cmp_action.luasnip_jump_forward(),
		-- ["<C-b>"] = cmp_action.luasnip_jump_backward(),

		["<CR>"] = cmp.mapping({
			i = function(fallback)
				if cmp.visible() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
				else
					fallback()
				end
			end,
		}),
		["<C-space>"] = cmp.mapping({
			i = function()
				if cmp.visible() or vim.g.cmp_toggle_flag then
					cmp.abort()
					M.toggle_completion()
				else
					cmp.complete()
					M.toggle_completion()
				end
			end,
		}),
	},
}

local ok_luasnip, luasnip = pcall(require, "luasnip")

if ok_luasnip then
	config.snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	}
end
cmp.setup.filetype({ "mysql", "sql", "plsql" }, {
	sources = cmp.config.sources({
		{ name = "vim-dadbod-completion" },
	}),
})
return config
