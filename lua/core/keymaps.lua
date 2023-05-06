local Util = require("core.utils")

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if not rhs then
        return
    end
    vim.keymap.set(mode, lhs, rhs, opts)
end
map("n", "gp", '"+p', { desc = "Paste from system clipboard" })
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
map("x", "gp", '"+P', { desc = "Paste from system clipboard" })
map("v", "<a-j>", ":m '>+1<CR>gv=gv")
map("v", "<a-k>", ":m '<-2<CR>gv=gv")
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

if Util.is_available("tmux") then
    map("n", "<C-h>", "<cmd>lua require('tmux').move_left()<cr>", { desc = "Go to left window" })
    map("n", "<C-j>", "<cmd>lua require('tmux').move_bottom()<cr>", { desc = "Go to lower window" })
    map("n", "<C-k>", "<cmd>lua require('tmux').move_top()<cr>", { desc = "Go to upper window" })
    map("n", "<C-l>", "<cmd>lua require('tmux').move_right()<cr>", { desc = "Go to right window" })
else
    map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
    map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
    map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
    map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
end
map("n", "<leader>us", function()
    Util.toggle("spell")
end, { desc = "Toggle Spelling" })
map("n", "<leader>ut", "<cmd>TransparentToggle<cr>", { desc = "Toggle transparency" })
map("n", "<leader>uf", function()
    Util.toggle("foldcolumn", false, { "0", "2" })
end, { desc = "Toggle foldcolumn" })
map("n", "<leader>ug", function()
    local enable = true
    for key, value in pairs(vim.lsp.get_active_clients()) do
        if value and value.name == "ltex" then
            enable = false
            break
        end
    end
    if enable then
        print("Enabling grammar check")
        vim.cmd([[LspStart ]] .. "ltex")
    else
        print("Disabling grammar check")
        vim.cmd([[LspStop ]] .. "ltex")
    end
end, { desc = "Toggle grammar (ltex)" })
map("n", "<leader>uw", function()
    Util.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function()
    Util.toggle("relativenumber", true)
    Util.toggle("number")
end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
map("n", "<leader>uc", function()
    Util.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })

if Util.is_available("telescope.nvim") then
    map("n", "<leader>ps", function()
        local sr = vim.fn.input("Grep > ")
        Util.telescope("grep_string", { search = sr })()
    end, { desc = "Telescope  grep_string" })

    map("n", "<leader>fw", function()
        Util.telescope("live_grep")()
    end, { desc = "Telescope  grep_string" })
    map("n", "<leader>gc", function()
        Util.telescope("git_commits")()
    end, { desc = "Telescope commits" })
end
if Util.is_available("oil.nvim") then
    map("n", "<leader>e", function()
        if vim.bo.filetype == "oil" then
            require("oil").close()
        else
            require("oil").open()
        end
    end, { desc = "Oil float" })
end
if Util.is_available("telekasten.nvim") then
    map("n", "<leader>zg", ":lua require('telekasten').search_notes()<CR>", { desc = "Search notes" })
    map("n", "<leader>zd", ":lua require('telekasten').find_daily_notes()<CR>", { desc = "Find daily notes" })
    map("n", "<leader>zz", ":lua require('telekasten').find_notes()<CR>", { desc = "Find notes" })

    map("n", "<leader>zT", ":lua require('telekasten').goto_today()<CR>", { desc = "Go to today" })
    map("n", "<leader>zW", ":lua require('telekasten').goto_thisweek()<CR>", { desc = "Go to this week" })
    map("n", "<leader>zw", ":lua require('telekasten').find_weekly_notes()<CR>", { desc = "Find weekly notes" })
    map("n", "<leader>zn", ":lua require('telekasten').new_note()<CR>", { desc = "New note" })
    map("n", "<leader>zN", ":lua require('telekasten').new_templated_note()<CR>", { desc = "New teplate note" })
end


if Util.is_available("zen-mode.nvim") then
    map("n",
        "<leader>Zz",
        function()
            require("zen-mode").setup({
                window = {
                    width = 80,
                    options = {},
                },
            })
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = false
            vim.wo.rnu = false
            vim.opt.colorcolumn = "0"
        end,
        { desc = "Zen mode small" }


    )
    map("n",
        "<leader>ZZ",
        function()
            require("zen-mode").setup({
                window = {
					width = 120,
                    options = {},
                },
            })
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number =true
            vim.wo.rnu = true
            vim.opt.colorcolumn = "120"
        end,
        { desc = "zen mode big" }


    )
end
