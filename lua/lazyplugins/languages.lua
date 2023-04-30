local keymaps = require "keymaps.languages"


return {

  { "jbyuki/nabla.nvim", enabled = false },
  {
    "michaelb/sniprun",
    lazy = true,
    cmd = { "Sniprun" },
    build = "bash install.sh",
  },
  { "rest-nvim/rest.nvim", ft = { "http" }, config = true },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = { "md", "markdown" },
    cmd = { "PeekOpen", "PeekClose" },
    config = function()
      require("peek").setup {
        auto_load = true, -- whether to automatically load preview when
        -- entering another markdown buffer
        close_on_bdelete = true, -- close preview window on buffer delete
        syntax = true, -- enable syntax highlighting, affects performance
        theme = "dark", -- 'dark' or 'light'
        update_on_change = true,
        app = "webview", -- 'webview', 'browser', string or a table of strings
        -- explained below

        filetype = { "markdown", "telekasten" }, -- list of filetypes to recognize as markdown
        -- relevant if update_on_change is true
        throttle_at = 200000, -- start throttling when file exceeds this
        -- amount of bytes in size
        throttle_time = "auto", -- minimum amount of time in milliseconds
      }
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    build = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = {
        "markdown",
      }
    end,
    ft = {
      "markdown",
    },
  },
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    enabled = false,
    cmd = { "Neorg" },
    ft = { "norg" },
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
          config = {
            default_workspace = "notes",
            workspaces = { notes = "~/.config/nvim/norg" },
          },
        },
      },
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  {
    "renerocksai/telekasten.nvim",
    keys = keymaps.notes,
    cmd = { "Telekasten" },
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telekasten").setup {
        home = vim.fn.expand "~/.config/nvim/notes", -- Put the name of your notes directory here
        auto_set_filetype = false,
        tag_notation = ":tag:",
      }
    end,
  },
  -- {
  -- 	"cnshsliu/smp.nvim",
  -- 	build = "cd server && npm install", -- yes, we should have node & npm installed.
  -- 	dependencies = {
  -- 		"nvim-telescope/telescope.nvim",
  -- 		"MunifTanjim/nui.nvim",
  -- 	},
  -- 	config = function()
  -- 		require("smp").setup({
  -- 			--where are your MDs
  -- 			home = vim.fn.expand("~/zettelkasten"),
  -- 			-- for Telekasten user, don't use Telekasten? keep this line, no harm
  -- 			templates = vim.fn.expand("~/zettelkasten") .. "/" .. "templates",
  -- 			-- your custom markdown css, if not defined or not exist,
  -- 			-- will use the default css
  -- 			smp_markdown_css = "~/.config/smp/my_markdown.css",
  -- 			-- your markdown snippets, if not defined or not exist,
  -- 			-- snippets like {snippet_1} will keep it's as-is form.
  -- 			smp_snippets_folder = "~/.config/smp/snippets",
  -- 			-- copy single line filepath into 'home/assets' folder
  -- 			-- default is true
  -- 			copy_file_into_assets = true,
  -- 		})
  -- 	end,
  -- },
}
