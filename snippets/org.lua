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
local orghome = vim.fn.expand("~/.config/nvim/org/assets/img")
local newfile = ""
local function newjpgfile()
	newfile = orghome .."/" .. os.date("%Y-%m-%d_%H_%M_%S") ..'.jpg'
	return newfile
	
end
local function oldjpg()
	return newfile
	
end
CS(
	{ trig = "MathEq", namr = "MathEq", dscr = "Math equastion" },
	fmt(
		[[ 
		#+BEGIN_SRC python
		import numpy as np
		import matplotlib.pyplot as plt

		xmin, xmax, ymin, ymax = -5, 5, -5, 5
		ticks_frequency = 1

		fig, ax = plt.subplots(figsize=(10, 10))
		 
		fig, ax = plt.subplots(figsize=(10, 10))
		# ax.spines['left'].set_position('center')
		# ax.spines['bottom'].set_position('center')
		#
		# # Eliminate upper and right axes
		# ax.spines['right'].set_color('none')
		# ax.spines['top'].set_color('none')
		#
		# # Show ticks in the left and lower axes only
		# ax.xaxis.set_ticks_position('bottom')
		# ax.yaxis.set_ticks_position('left')
		 
		plt.text(0.49, 0.49, r"$O$", ha='right', va='top',
			transform=ax.transAxes,
				 horizontalalignment='center', fontsize=14)

		ax.grid(which='both', color='grey', linewidth=1, linestyle='-', alpha=0.2)

		def func(x):
			return {}
		 
		x = np.linspace(-5, 10, 100)
		y = func(x)
		 
		plt.plot(x, y, 'b', linewidth=2)
		plt.savefig("{}") 
		#+END_SRC
		#+BEGIN_SRC markdown
		![Fig]({})

		#+END_SRC

		]],
		{
			i(1,"(x**x)"),
			t(newjpgfile()),
			t(oldjpg())

		}
	)
)

return snippets
