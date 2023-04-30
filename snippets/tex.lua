local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

local snippets = {}

local function CS(table1, table2)
	table.insert(snippets, s(table1, table2))
end

local function column_count_from_string(descr)
	-- this won't work for all cases, but it's simple to improve
	-- (feel free to do so! :D )
	return #(descr:gsub("[^clm]", ""))
end

-- function for the dynamicNode.
local tab = function(args, snip)
	local cols = column_count_from_string(args[1][1])
	-- snip.rows will not be set by default, so handle that case.
	-- it's also the value set by the functions called from dynamic_node_external_update().
	if not snip.rows then
		snip.rows = 1
	end
	local nodes = {}
	-- keep track of which insert-index we're at.
	local ins_indx = 1
	for j = 1, snip.rows do
		-- use restoreNode to not lose content when updating.
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(
				nodes,
				r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1))
			)
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
	end
	-- fix last node.
	nodes[#nodes] = t("")
	return sn(nil, nodes)
end

CS(
	"tabbbe",
	fmt(
		[[
\begin{{tabular}}{{{}}}
{}
\end{{tabular}}
]],
		{
			i(1, "c"),
			d(2, tab, { 1 }, {
				user_args = {
					-- Pass the functions used to manually update the dynamicNode as user args.
					-- The n-th of these functions will be called by dynamic_node_external_update(n).
					-- These functions are pretty simple, there's probably some cool stuff one could do
					-- with `ui.input`
					function(snip)
						snip.rows = snip.rows + 1
					end,
					-- don't drop below one.
					function(snip)
						snip.rows = math.max(snip.rows - 1, 1)
					end,
				},
			}),
		}
	)
)

return snippets
