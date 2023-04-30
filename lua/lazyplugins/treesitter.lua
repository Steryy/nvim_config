return {
    {
        "nvim-treesitter/nvim-treesitter",
        init = function()
            require("core.utils").lazy_load "nvim-treesitter"
        end,
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
        cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
        build = ":TSUpdate",
        dependencies = {

            { "mrjones2014/nvim-ts-rainbow" },
            --			{ "andymass/vim-matchup" },
            {
                "nvim-treesitter/nvim-treesitter-context",
                config = function()
                    require("treesitter-context").setup {
                        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
                        max_lines = 3,            -- How many lines the window should span. Values <= 0 mean no limit.
                        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                        line_numbers = true,
                        multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
                        trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                        mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
                        -- Separator between context and content. Should be a single character string, like '-'.
                        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                        separator = nil,
                        zindex = 20, -- The Z-index of the context window
                    }
                end,
            },
            { "windwp/nvim-ts-autotag" },

            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                init = function()
                    -- PERF: no need to load the plugin, if we only need its queries for mini.ai
                    local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
                    local opts = require("lazy.core.plugin").values(plugin, "opts", false)
                    local enabled = false
                    if opts.textobjects then
                        for _, mod in ipairs { "move", "select", "swap", "lsp_interop" } do
                            if opts.textobjects[mod] and opts.textobjects[mod].enable then
                                enabled = true
                                break
                            end
                        end
                    end
                    if not enabled then
                        require("lazy.core.loader").disable_rtp_plugin "nvim-treesitter-textobjects"
                    end
                end,
            },
        },
        opts = {
            ensure_installed = {
                "vim",
                "lua",
                "html",
                "css",
                "javascript",
                "typescript",
                "tsx",
                "c",
                "markdown",
                "markdown_inline",
            },
            highlight = {
                enable = true,
                -- use_languagetree = true,
            },
            indent = {
                enable = true,
                -- disable = {
                --   "python"
                -- },
            },
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
            autotag = { enable = true },
            --		matchup = { enable = true },
            rainbow = {
                enable = true,
                extended_mode = true,  -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
                max_file_lines = 2000, -- Do not enable for files with more than 2000 lines, int
            },
        },
    },
}
