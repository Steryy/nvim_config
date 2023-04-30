local Util = require "core.utils"

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  if not rhs then
    return
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end
map("x", "p", [["_dP]], { remap = false })
map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])
-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- Move to window using the <ctrl> hjkl keys
map("n", "<C-z>", "<esc>", { desc = "Dont kill" })

if Util.is_available "tmux" then
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

-- Resize window using <ctrl> arrow keys
map({ "n", "t", "i" }, "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map({ "n", "t", "i" }, "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map({ "n", "t", "i" }, "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map({ "n", "t", "i" }, "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua

map({ "n", "x" }, "gw", "*", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("n", "<BS>", "<c-o>")
-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
-- map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })


-- stylua: ignore start

-- toggle options
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>ut", "<cmd>TransparentToggle<cr>", { desc = "Toggle transparency" })
map("n", "<leader>uf", function() Util.toggle("foldcolumn", false, { "0", "2" }) end, { desc = "Toggle foldcolumn" })
map("n", "<leader>ug", function()
    local enable = true
    for key, value in pairs(vim.lsp.get_active_clients()) do
        if value and value.name == "ltex" then
            enable = false
            break;
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
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function()
    Util.toggle("relativenumber", true)
    Util.toggle("number")
end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
map("n", "<leader>uc", function() Util.toggle("conceallevel", false, { 0, conceallevel }) end,
    { desc = "Toggle Conceal" })

map("n", "<leader>uu", "<cmd>CccHighlighterToggle<cr>",
    { desc = "Toggle Color highlights" })

-- lazygit
-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
    map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- floating terminal
map("n", "<leader>ft", function()
    local dir = Util.get_root()
    vim.cmd([[exe v:count1 . "ToggleTerm  direction=float dir=]] .. dir .. [["]])
end, { desc = "Terminal (root dir)" })
map("n", "<leader>ft", "<cmd>exe v:count1 .  'ToggleTerm direction=float'<cr>", { desc = "Terminal (cwd)" })
map("n", "<F7>", "<cmd>exe v:count1 .  'ToggleTerm direction=float'<cr>", { desc = "Terminal (cwd)" })
map("t", "<F7>", "<cmd>exe v:count1 .  'ToggleTerm direction=float'<cr>", { desc = "Terminal (cwd)" })
map("n", "<leader>vv", "<cmd>FileManager<cr>", { desc = "File manager" })
-- map("n", "<leader>lf", vim.lsp.buf.format, { desc = "format file" })
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })


-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })


map(  'n',        'gp', '"+p', { desc = 'Paste from system clipboard' })
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
map(  'x',        'gp', '"+P', { desc = 'Paste from system clipboard' })

map("n", "<leader>e", "<cmd>lua require('oil').toggle_float()<cr>")
