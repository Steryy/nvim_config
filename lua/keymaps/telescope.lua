local editor = {}

local Util = require "core.utils"
editor.telescope_mappings = {
    i = {
        ["<c-t>"] = function(...)
            return require("trouble.providers.telescope").open_with_trouble(...)
        end,
        ["<a-t>"] = function(...)
            return require("trouble.providers.telescope").open_selected_with_trouble(...)
        end,
        ["<a-i>"] = function()
            Util.telescope("find_files", { no_ignore = true })()
        end,
        ["<a-h>"] = function()
            Util.telescope("find_files", { hidden = true })()
        end,
        ["<C-Down>"] = function(...)
            return require("telescope.actions").cycle_history_next(...)
        end,
        ["<C-Up>"] = function(...)
            return require("telescope.actions").cycle_history_prev(...)
        end,
        ["<C-d>"] = function(...)
            return require("telescope.actions").preview_scrolling_down(...)
        end,
        ["<C-u>"] = function(...)
            return require("telescope.actions").preview_scrolling_up(...)
        end,
        ["<C-s>"] = function(...)
            return require("telescope").extensions.hop.hop(...)
        end,
    },
    n = {
        ["q"] = function(...)
            return require("telescope.actions").close(...)
        end,
        ["gs"] = function(prompt_bufnr)
            local actions = require "telescope.actions"

            local opts = {
                callback = actions.toggle_selection,
                loop_callback = actions.send_selected_to_qflist,
            }
            require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
        end,
        ["s"] = function(...)
            return require("telescope").extensions.hop.hop(...)
        end,
        ["<C-d>"] = function(...)
            return require("telescope.actions").preview_scrolling_down(...)
        end,
        ["<C-u>"] = function(...)
            return require("telescope.actions").preview_scrolling_up(...)
        end,
    },
}
editor.telescope_buffer_mappings = {
    n = {
        ["dd"] = function(...)
            return require("telescope.actions").delete_buffer(...)
        end,
    },
}
editor.telescope = {
    { "<leader>,",       "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
    { "<leader>/",       Util.telescope "live_grep",                         desc = "Find in Files (Grep)" },
    { "<leader>fw",      "<cmd> Telescope live_grep <CR>",                   "live grep" },
    { "<leader>:",       "<cmd>Telescope command_history<cr>",               desc = "Command History" },
    { "<leader><space>", Util.telescope "files",                             desc = "Find Files (root dir)" },
    -- find
    { "<leader>fb",      "<cmd>Telescope buffers<cr>",                       desc = "Buffers" },
    -- { "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
    { "<leader>fF",      Util.telescope("files", { cwd = false }),           desc = "Find Files (cwd)" },
    { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                      desc = "Recent" },
    -- git
    {
        "<leader>gc",
        function()
            local cwd = Util.get_root()
            print(cwd)
            local err, _
            pcall(Util.telescope "git_commits")
            if not err then
                local cwd = vim.loop.cwd()

                print(cwd .. " dont have git directory")
            end
        end,
        desc = "commits",
    },
    {
        "<leader>gs",
        function()
            local err, _
            pcall(Util.telescope "git_status")

            if not err then
                local cwd = vim.loop.cwd()

                print(cwd .. " dont have git directory")
            end
        end,
        desc = "status",
    },
    -- search
    { "<leader>sa", "<cmd>Telescope autocommands<cr>",                        desc = "Auto Commands" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",           desc = "Buffer" },
    { "<leader>sc", "<cmd>Telescope command_history<cr>",                     desc = "Command History" },
    { "<leader>sC", "<cmd>Telescope commands<cr>",                            desc = "Commands" },
    { "<leader>sd", "<cmd>Telescope diagnostics<cr>",                         desc = "Diagnostics" },
    { "<leader>sg", Util.telescope "live_grep",                               desc = "Grep (root dir)" },
    { "<leader>sG", Util.telescope("live_grep", { cwd = false }),             desc = "Grep (cwd)" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>",                           desc = "Help Pages" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>",                          desc = "Search Highlight Groups" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>",                             desc = "Key Maps" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>",                           desc = "Man Pages" },
    { "<leader>sm", "<cmd>Telescope marks<cr>",                               desc = "Jump to Mark" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>",                         desc = "Options" },
    { "<leader>sR", "<cmd>Telescope resume<cr>",                              desc = "Resume" },
    { "<leader>sw", Util.telescope "grep_string",                             desc = "Word (root dir)" },
    { "<leader>sW", Util.telescope("grep_string", { cwd = false }),           desc = "Word (cwd)" },
    { "<leader>uC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
    {
        "<leader>ss",
        Util.telescope("lsp_document_symbols", {
            symbols = {
                "Class",
                "Function",
                "Method",
                "Constructor",
                "Interface",
                "Module",
                "Struct",
                "Trait",
                "Field",
                "Property",
            },
        }),
        desc = "Goto Symbol",
    },
    {
        "<leader>sS",
        Util.telescope("lsp_workspace_symbols", {
            symbols = {
                "Class",
                "Function",
                "Method",
                "Constructor",
                "Interface",
                "Module",
                "Struct",
                "Trait",
                "Field",
                "Property",
            },
        }),
        desc = "Goto Symbol (Workspace)",
    },
}

return editor