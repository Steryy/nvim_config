local statusline = "lualine"
return {

    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        opts = { compile = true },
    },
    {
        "rebelot/heirline.nvim",
        lazy = false,
        enabled = statusline =="heirline",
        config = function()
            require("plugins.configs.heirline")
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        opts = {},
    },
    {
        "numToStr/Sakura.nvim",
        lazy = false,
    },

    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    {
        "nvim-lualine/lualine.nvim",
        -- event = {"BufRead","UIEnter"},
        lazy = false,
        config = function()
            if statusline == "lualine" then
                vim.api.nvim_set_hl(0, "Statusline", { fg = "NONE", bg = "NONE" })

                require("plugins.configs.lualine")
            end
        end,
    },
    { "MunifTanjim/nui.nvim", lazy = true },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        enabled = vim.g.noice and true or false,
        opts = {
            cmdline = {
                view = "cmdline",
                format = {
                    -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
                    -- view: (default is cmdline view)
                    -- opts: any options passed to the view
                    -- icon_hl_group: optional hl_group for the icon
                    -- title: set to anything or empty string to hide
                    cmdline = { pattern = "^:", icon = ":", lang = "vim" },
                    search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
                    search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
                    filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                    lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = ":lua", lang = "lua" },
                    help = { pattern = "^:%s*he?l?p?%s+", icon = ":help" },
                    input = {}, -- Used by input()
                    -- lua = false, -- to disable a format, set to `false`
                },
            },
        },
        keys = {
            {
                "<S-Enter>",
                function()
                    require("noice").redirect(vim.fn.getcmdline())
                end,
                mode = "c",
                desc = "Redirect Cmdline",
            },
            {
                "<leader>snl",
                function()
                    require("noice").cmd("last")
                end,
                desc = "Noice Last Message",
            },
            {
                "<leader>snh",
                function()
                    require("noice").cmd("history")
                end,
                desc = "Noice History",
            },
            {
                "<leader>sna",
                function()
                    require("noice").cmd("all")
                end,
                desc = "Noice All",
            },
            {
                "<leader>snd",
                function()
                    require("noice").cmd("dismiss")
                end,
                desc = "Dismiss All",
            },
            {
                "<c-f>",
                function()
                    if not require("noice.lsp").scroll(4) then
                        return "<c-f>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll forward",
                mode = { "i", "n", "s" },
            },
            {
                "<c-b>",
                function()
                    if not require("noice.lsp").scroll(-4) then
                        return "<c-b>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll backward",
                mode = { "i", "n", "s" },
            },
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        opts = {},
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
            require("transparent").setup({
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
                    "GitSignsAdd",
                    "GitSignsChange",
                    "GitSignsDelete",
                    "GitSignsChangedelete",
                    "GitSignsTopdelete",
                    "GitSignsUntracked",
                    "GitSignsAddNr",
                    "GitSignsChangeNr",
                    "GitSignsDeleteNr",
                    "GitSignsChangedeleteNr",
                    "GitSignsTopdeleteNr",
                    "GitSignsUntrackedNr",
                    "GitSignsAddLn",
                    "GitSignsChangeLn",
                    "GitSignsChangedeleteLn",
                    "GitSignsUntrackedLn",
                    "GitSignsAddPreview",
                    "GitSignsDeletePreview",
                    "GitSignsCurrentLineBlame",
                    "GitSignsAddInline",
                    "GitSignsDeleteInline",
                    "GitSignsChangeInline",
                    "GitSignsAddLnInline",
                    "GitSignsChangeLnInline",
                    "GitSignsDeleteLnInline",
                    "GitSignsDeleteVirtLn",
                    "GitSignsDeleteVirtLnInLine",
                    "GitSignsVirtLnum",
                    "DiagnosticSignError",
                    "DiagnosticSignWarn",
                    "DiagnosticSignHint",
                    "DiagnosticSignInfo",
                },
                extra_groups = {},   -- table: additional groups that should be cleared
                exclude_groups = {}, -- table: groups you don't want to clear
            })
            vim.cmd("TransparentEnable")
        end,
    },
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

    {
        "folke/zen-mode.nvim",
    }

}
