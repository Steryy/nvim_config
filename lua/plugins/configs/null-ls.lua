local present, null_ls = pcall(require, "null-ls")

if not present then
	return
end

local b = null_ls.builtins

local sources = {

	-- webdev stuff
	b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
	b.formatting.prettier.with({ filetypes = { "html", "markdown", "css" } }), -- so prettier works only on these filetypes

	b.formatting.stylua.with({ extra_args = { "--column-width", "80" } }), -- Lua

	-- cpp
	b.formatting.clang_format,
}

local is_ts, typescript = pcall(require, "typescript")
if is_ts then
	table.insert(sources, require("typescript.extensions.null-ls.code-actions"))
end
null_ls.setup({
	debug = true,
	sources = sources,
})
