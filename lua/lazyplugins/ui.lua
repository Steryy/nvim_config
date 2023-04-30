return {

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  -- {
  --   "themercorp/themer.lua",
  --   -- lazy = false,
  --   config = function()
  --     require("themer").setup {
  --       colorscheme = "kanagawa", -- default colorscheme
  --       transparent = false,
  --       term_colors = true,
  --       dim_inactive = true,
  --       styles = {
  --         ["function"] = { style = "italic" },
  --         functionbuiltin = { style = "italic" },
  --         variable = { style = "italic" },
  --         variableBuiltIn = { style = "italic" },
  --         parameter = { style = "italic" },
  --       },
  --     }
  --   end,
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {},
    -- lazy = false
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    opts = { compile = true },
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    cmd = {
      "TransparentEnable",
      "TransparentDisable",
      "TransparentToggle",
    },
    config = function()
      require("transparent").setup {
        groups = { -- table: default groups
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          "CursorLineNr",
          "EndOfBuffer",
        },
        extra_groups = {}, -- table: additional groups that should be cleared
        exclude_groups = {}, -- table: groups you don't want to clear
      }
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   name = "catppuccin",
  --   -- opts = function(plugin)
  --   --     -- vim.g.colors_name = "catppuccin"
  --   --
  --   --     return require "plugins.configs.catppuccin"
  --   -- end,
  -- },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    config = function()
      local opts = {
        auto_enable = true,
        magic_window = true,
        auto_resize_height = false,
        preview = {
          auto_preview = true,
          show_title = true,
          delay_syntax = 50,
          wrap = false,
        },
        func_map = {
          tab = "t",
          openc = "o",
          drop = "O",
          split = "s",
          vsplit = "v",
          stoggleup = "M",
          stoggledown = "m",
          stogglevm = "m",
          filterr = "f",
          filter = "F",
          prevhist = "<",
          nexthist = ">",
          sclear = "c",
          ptoggleauto = "p",
          ptogglemode = "P",
        },
      }
      require("bqf").setup(opts)
    end,
  },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   -- lazy = false,
  --   opts = function()
  --     return require "plugins.configs.lualine"
  --   end,
  --   requires = { "nvim-tree/nvim-web-devicons", opt = true },
  -- },
  -- {
  --   "rebelot/heirline.nvim",
  --   lazy = false,
  --   config = function()
  --     require "plugins.configs.heirline"
  --   end,
  -- },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
}
