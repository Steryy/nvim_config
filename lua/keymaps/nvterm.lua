return {
  {
    "<a-i>",
    function()
      require("nvterm.terminal").toggle "float"
    end,
    mode = { "n", "t" },
    desc = "Terminal",
  },

  {
    "<a-h>",
    function()
      require("nvterm.terminal").toggle "horizontal"
    end,
    mode = { "n", "t" },
    desc = "Terminal",
  },

  {
    "<a-v>",
    function()
      require("nvterm.terminal").toggle "vertical"
    end,
    mode = { "n", "t" },
    desc = "Terminal",
  },
}
