return  {
	keys = { { "gc", mode = { "n", "v", "x" } } },
	mappings = {
		-- Toggle comment (like `gcip` - comment inner paragraph) for both
		-- Normal and Visual modes
		comment = "gc",
		-- Toggle comment on current line
		comment_line = "gcc",
		-- Define 'comment' textobject (like `dgc` - delete whole comment block)
		textobject = "gc",
	},
}

