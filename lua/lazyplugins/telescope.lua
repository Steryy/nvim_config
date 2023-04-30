local keymaps = require "keymaps.telescope"
return {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    keys = keymaps.telescope,
    dependencies = {

        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function()
                require("telescope").load_extension "fzf"
            end,
        },
        {
            "debugloop/telescope-undo.nvim",
            config = function()
            end,
        },
        {
            "nvim-telescope/telescope-hop.nvim",
            config = function()
            end,
        },
        {
            "nvim-telescope/telescope-ui-select.nvim",
        },
    },
    config = function(_, opts)
        local telescope = require "telescope"
        telescope.setup(opts)

        -- load extensions

        require("telescope").load_extension "undo"
        require("telescope").load_extension "hop"
    end,
    opts = {
        pickers = {
            colorscheme = {
                enable_preview = true,
            },
            buffers = {
                layout_strategy = "vertical",
                mappings = keymaps.telescope_buffer_mappings,
            },
        },
        defaults = {
            initial_mode = "normal",
            scroll_strategy = "limit",
            results_title = false,
            layout_strategy = "horizontal",
            path_display = { "absolute" },
            file_ignore_patterns = {
                ".git/",
                ".cache",
                "%.class",
                "%.pdf",
                "%.mkv",
                "%.mp4",
                "%.zip",
            },
            layout_config = {
                horizontal = {
                    preview_width = 0.5,
                },
            },
            -- file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            -- qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            -- file_sorter = require("telescope.sorters").get_fuzzy_file,
            -- generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            prompt_prefix = "   ",
            selection_caret = " ",
            mappings = keymaps.telescope_mappings,
        },
        extensions = {
            undo = {
                use_delta = false,
                diff_context_lines = 10,
                use_custom_command = { "bash", "-c", "echo '$DIFF' | delta --line-numbers" },
                side_by_side = false,
            },
            hop = {
                -- the shown `keys` are the defaults, no need to set `keys` if defaults work for you ;)
                keys = {
                    "a",
                    "s",
                    "d",
                    "f",
                    "g",
                    "h",
                    "j",
                    "k",
                    "l",
                    ";",
                    "q",
                    "w",
                    "e",
                    "r",
                    "t",
                    "y",
                    "u",
                    "i",
                    "o",
                    "p",
                    "A",
                    "S",
                    "D",
                    "F",
                    "G",
                    "H",
                    "J",
                    "K",
                    "L",
                    ":",
                    "Q",
                    "W",
                    "E",
                    "R",
                    "T",
                    "Y",
                    "U",
                    "I",
                    "O",
                    "P",
                },
                -- Highlight groups to link to signs and lines; the below configuration refers to demo
                -- sign_hl typically only defines foreground to possibly be combined with line_hl
                sign_hl = { "HopNextKey", "HopNextKey1" },
                -- optional, typically a table of two highlight groups that are alternated between
                line_hl = { "ColorColumn", "Normal" },
                -- options specific to `hop_loop`
                -- true temporarily disables Telescope selection highlighting
                clear_selection_hl = true,
                -- highlight hopped to entry with telescope selection highlight
                -- note: mutually exclusive with `clear_selection_hl`
                trace_entry = false,
                -- jump to entry where hoop loop was started from
                reset_selection = true,
            },
        },
    },
}
