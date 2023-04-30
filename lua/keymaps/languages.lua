
local languages = {}

languages.notes = {
	{ "<leader>zz", ":lua require('telekasten').find_notes()<CR>", desc = "Search notes",mode= "n" },
}
return languages
