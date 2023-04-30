local ls = require("luasnip")
-- some shorthands...
local snip = ls.snippet
local n = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local func = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local date = function()
	return { os.date("%Y-%m-%d") }
end
local snippets = {}
local function CS(table1, table2)
	table.insert(snippets, snip(table1, table2))
end

CS(
	{ trig = "GET", namr = "GET", dscr = "Create basic get" },
	fmt(
		[[
GET {} {}
Content-Type: {}
Accept: {}

]],
		{
			i(1, "https://example.local"),
			c(2, { t("HTTP/1.1"), t("HTTP/2") }),
			c(3, { t("text/html"), t("application/xml"), i(1) }),
			c(4, { t("text/html"), t("application/json"), i(1) }),
		}
	)
)

CS(
	{ trig = "POST", namr = "POST", dscr = "Create basic post" },
	fmt(
		[[
POST {} {}
Content-Type: {}
Accept: {}

]],
		{
			i(1, "https://example.local"),
			c(2, { t("HTTP/1.1"), t("HTTP/2") }),
			c(3, { t("application/json"), t("text/html"), i(1) }),
			c(4, { t("application/json"), t("text/html"), i(1) }),
		}
	)
)

return snippets
