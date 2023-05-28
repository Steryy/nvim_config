local get_icon = require("core.utils").get_icon
local signs = {
    {
        name = "DapStopped",
        text = get_icon("DapStopped"),
        texthl = "DiagnosticWarn",
    },
    {
        name = "DapBreakpoint",
        text = get_icon("DapBreakpoint"),
        texthl = "DiagnosticInfo",
    },
    {
        name = "DapBreakpointRejected",
        text = get_icon("DapBreakpointRejected"),
        texthl = "DiagnosticError",
    },
    {
        name = "DapBreakpointCondition",
        text = get_icon("DapBreakpointCondition"),
        texthl = "DiagnosticInfo",
    },
    {
        name = "DapLogPoint",
        text = get_icon("DapLogPoint"),
        texthl = "DiagnosticInfo",
    },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, sign)
end
require("dapui").setup({
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = "",
        },
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    force_buffers = true,
    icons = {
        collapsed = "",
        current_frame = "",
        expanded = "",
    },
    layouts = {
        {
            elements = {
                {
                    id = "scopes",
                    size = 0.25,
                },
                {
                    id = "breakpoints",
                    size = 0.25,
                },
                {
                    id = "stacks",
                    size = 0.25,
                },
                {
                    id = "watches",
                    size = 0.25,
                },
            },
            position = "right",
            size = 40,
        },
        {
            elements = {
                {
                    id = "repl",
                    size = 0.5,
                },
                {
                    id = "console",
                    size = 0.5,
                },
            },
            position = "bottom",
            size = 10,
        },
    },
    mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
    },
    render = {
        indent = 1,
        max_value_lines = 100,
    },
})
require("plugins.configs.dap.crust")
require("plugins.configs.dap.javascript")
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
-- local async = require("dapui.async")
--   local console_buf = -1
--   local autoscroll = true
--   local function get_buf()
--     if async.api.nvim_buf_is_valid(console_buf) then
--       return console_buf
--     end
--     console_buf = util.create_buffer("DAP Console", { filetype = "dapui_console" })()
--     if vim.fn.has("nvim-0.7") == 1 then
--       vim.keymap.set("n", "G", function()
--         autoscroll = true
--         vim.cmd("normal! G")
--       end, { silent = true, buffer = console_buf })
--       async.api.nvim_create_autocmd({ "InsertEnter", "CursorMoved" }, {
--         group = async.api.nvim_create_augroup("dap-repl-au", { clear = true }),
--         buffer = console_buf,
--         callback = function()
--           local active_buf = async.api.nvim_win_get_buf(0)
--           if active_buf == console_buf then
--             local lnum = async.api.nvim_win_get_cursor(0)[1]
--             autoscroll = lnum == async.api.nvim_buf_line_count(console_buf)
--           end
--         end,
--       })
--       async.api.nvim_buf_attach(console_buf, false, {
--         on_lines = function(_, _, _, _, _, _)
--           if autoscroll and vim.fn.mode() == "n" then
--             vim.cmd("normal! G")
--           end
--         end,
--       })
--     end
--     return console_buf
--   end

-- dap.defaults.fallback.terminal_win_cmd = get_buf
