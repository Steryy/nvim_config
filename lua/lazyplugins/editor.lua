-- local keymaps = require("keymaps.editor")
return {

    {
        "folke/which-key.nvim",
        event = "UIEnter",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
    -- {
    --     'prichrd/netrw.nvim',
    --     lazy = false,
    --     config = function()
    --         require 'netrw'.setup {
    --             -- Put your configuration here, or leave the object empty to take the default
    --             -- configuration.
    --             icons = {
    --                 symlink = '', -- Symlink icon (directory and file)
    --                 directory = '', -- Directory icon
    --                 file = '', -- File icon
    --             },
    --             use_devicons = true, -- Uses nvim-web-devicons if true, otherwise use the file icon specified above
    --             mappings = {}, -- Custom key mappings
    --         }
    --     end
    -- },
    {
        -- enabled = false,
        "stevearc/oil.nvim",
        lazy = false,
        config = function()
            require("oil").setup({
                buf_options = {
                    buflisted = false,
                    -- bufhidden = "wipe",
                },
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-s>"] = "actions.select_vsplit",
                    ["<C-h>"] = "actions.select_split",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = "actions.close",
                    ["<C-l>"] = "actions.refresh",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["`"] = "actions.cd",
                    ["~"] = "actions.tcd",
                    ["g."] = "actions.toggle_hidden",
                    ["<bs>"] = "actions.parent",
                    ["q"] = "actions.close",
                    ["esc"] = "actions.close",
                },
                columns = {
                    -- "icon",
                    -- "permissions",
                    -- "size",
                    -- "mtime",
                },
            })
        end,
    },
    {
        "windwp/nvim-spectre",
        -- stylua: ignore
        -- keys = keymaps.spectre,
    },
    {
        -- enabled = false,
        -- lazy = false,
        "elihunter173/dirbuf.nvim",
        config = function()
            require("dirbuf").setup {
                hash_padding = 2,
                show_hidden = true,
                sort_order = "default",
                write_cmd = "DirbufSync",
            }
        end,
    },
    {
        "phaazon/hop.nvim",
        branch = "v2", -- optional but strongly recommended
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
        end,
    },

    {
        "folke/which-key.nvim",
        -- event = "UIEnter",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
}
