local M = {}
local utils = require("core.utils")

local get_icon = require("core.utils").get_icon
local signs = {
	{ name = "DiagnosticSignError", text = get_icon("DiagnosticError"), texthl = "DiagnosticSignError" },
	{ name = "DiagnosticSignWarn", text = get_icon("DiagnosticWarn"), texthl = "DiagnosticSignWarn" },
	{ name = "DiagnosticSignHint", text = get_icon("DiagnosticHint"), texthl = "DiagnosticSignHint" },
	{ name = "DiagnosticSignInfo", text = get_icon("DiagnosticInfo"), texthl = "DiagnosticSignInfo" },
}
for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, sign)
end
vim.diagnostic.config({
	-- virtual_text = {
	--       enabled = false,
	-- prefix = "",
	--
	-- format = function(diagnoscic)
	-- 	local sig = ""
	-- 	if diagnoscic.severity == vim.diagnostic.severity.ERROR then
	-- 		sig = signs[1].text
	-- 	elseif diagnoscic.severity == vim.diagnostic.severity.WARN then
	-- 		sig = signs[2].text
	-- 	elseif diagnoscic.severity == vim.diagnostic.severity.HINT then
	-- 		sig = signs[3].text
	-- 	elseif diagnoscic.severity == vim.diagnostic.severity.INFO then
	-- 		sig = signs[4].text
	-- 	end
	-- 	return diagnoscic.severity and sig or " "
	-- end,
	-- },
	virtual_text = false,
	signs = false,
	underline = true,
	update_in_insert = false,
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "single",
	focusable = false,
	relative = "cursor",
})

-- Borders for LspInfo winodw
local win = require("lspconfig.ui.windows")
local _default_opts = win.default_opts

win.default_opts = function(options)
	local opts = _default_opts(options)
	opts.border = "single"
	return opts
end
-- export on_attach & capabilities for custom lspconfigs

local is_available = utils.is_available
M.on_attach = function(client, bufnr)
	local fmt = function(cmd)
		return function(str)
			return cmd:format(str)
		end
	end
	local lsp = fmt("<cmd>lua vim.lsp.%s<cr>")
	local diagnostic = fmt("<cmd>lua vim.diagnostic.%s<cr>")
	local map = function(m, lhs, rhs)
		local key_opts = { buffer = bufnr }
		vim.keymap.set(m, lhs, rhs, key_opts)
	end

	map("n", "K", lsp("buf.hover()"))
	map("n", "gd", lsp("buf.definition()"))
	map("n", "gD", lsp("buf.declaration()"))
	map("n", "gi", lsp("buf.implementation()"))
	map("n", "go", lsp("buf.type_definition()"))
	map("n", "gr", lsp("buf.references()"))
	map("n", "gs", lsp("buf.signature_help()"))
	map("n", "<F2>", lsp("buf.rename()"))
	map("n", "<F3>", lsp("buf.format({async = true})"))
	map("x", "<F3>", lsp("buf.format({async = true})"))
	map("n", "<F4>", lsp("buf.code_action()"))

	if vim.lsp.buf.range_code_action then
		map("x", "<F4>", lsp("buf.range_code_action()"))
	else
		map("x", "<F4>", lsp("buf.code_action()"))
	end

	map("n", "gl", diagnostic("open_float()"))
	map("n", "[d", diagnostic("goto_prev()"))
	map("n", "]d", diagnostic("goto_next()"))
	if client.name == "tsserver" then
		vim.keymap.set("n", "<leader>ci", "<cmd>TypescriptAddMissingImports<cr>", { buffer = bufnr })
		vim.keymap.set("n", "<leader>cr", "<cmd>TypescriptRenameFile<cr>", { buffer = bufnr })
	end
end

local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
local base = {}
if ok_lspconfig then
	base = lspconfig.util.default_config.capabilities
else
	base = vim.lsp.protocol.make_client_capabilities()
end
local cmp_default_capabilities = {}
local ok_lsp_source, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_lsp_source then
	cmp_default_capabilities = cmp_lsp.default_capabilities()
end

M.capabilities = vim.tbl_deep_extend("force", base, cmp_default_capabilities)
M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

local lspconfig = require("lspconfig")
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
local servers = {
	"html",
	"cssls",
	"tsserver",
	"clangd",
	"tailwindcss",
	lua_ls = {
		settings = {
			Lua = {
				-- Disable telemetry
				telemetry = { enable = false },
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					path = runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					checkThirdParty = false,
					library = {
						-- Make the server aware of Neovim runtime files
						vim.fn.expand("$VIMRUNTIME/lua"),
						vim.fn.stdpath("config") .. "/lua",
					},
				},
			},
		},
	},
	ltex = {
		autostart = false,
		settings = {
			ltex = {
				markdown = {
					nodes = {
						CodeBlock = "ignore",
						FencedCodeBlock = "ignore",
						AutoLink = "ignore",
						Code = "ignore",
						LatexBlock = "ignore",
					},
				},
				-- enabled = false,
			},
		},
	},
}
local default_settings = {
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	on_init = function(client)
		client.server_capabilities.semanticTokensProvider = false
	end,
}
local is_ts, typescript = pcall(require, "typescript")

for ind, lsp in pairs(servers) do
	local name = ""
	local settings = default_settings
	if type(lsp) == "string" then
		name = lsp
	elseif type(lsp) == "table" then
		name = tostring(ind)
		settings = vim.tbl_deep_extend("force", settings, lsp)
	end
	if is_ts and name == "tsserver" then
		typescript.setup({ server = settings })
		goto continue
	end

	lspconfig[name].setup(settings)
	::continue::
end
return M
