local dap = require('dap')

local get_icon = require("core.utils").get_icon
local signs = {
  { name = "DapStopped", text = get_icon "DapStopped", texthl = "DiagnosticWarn" },
  { name = "DapBreakpoint", text = get_icon "DapBreakpoint", texthl = "DiagnosticInfo" },
  { name = "DapBreakpointRejected", text = get_icon "DapBreakpointRejected", texthl = "DiagnosticError" },
  { name = "DapBreakpointCondition", text = get_icon "DapBreakpointCondition", texthl = "DiagnosticInfo" },
  { name = "DapLogPoint", text = get_icon "DapLogPoint", texthl = "DiagnosticInfo" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, sign)
end
local function telescopeBinnary()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    return coroutine.create(function(coro)
        local opts = {}
        pickers
            .new(opts, {
                prompt_title = "Path to executable",
                finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type", "x" },
                    {}),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(buffer_number)
                    actions.select_default:replace(function()
                        actions.close(buffer_number)
                        coroutine.resume(coro, action_state.get_selected_entry()[1])
                    end)
                    return true
                end,
            })
            :find()
    end)
end
dap.configurations.cpp = {}

local codell = vim.fn.exepath('codelldb')

if codell ~= nil and #codell > 0 then
    local codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
            command = codell,
            args = { '--port', '${port}' },
        },
    }

    dap.adapters.codelldb = codelldb
    if vim.fn.has('win32') == 1 then
        codelldb.codelldb.executable.detached = false
    end
    table.insert(dap.configurations.cpp, {
        name = "Launch file(codelldb)",
        type = "codelldb",
        request = "launch",
        program = telescopeBinnary,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,



    })
end

local opendb = vim.fn.exepath("OpenDebugAD7")
if opendb ~= nil and #opendb > 0 then
    local cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = opendb,
    }
    if vim.fn.has('win32') == 1 then
        cppdbg.cppdbg.options = {
            detached = false,
        }
    end

    dap.adapters.cppdbg = cppdbg
    table.insert(dap.configurations.cpp, {
        name = "Launch file(cppdbg)",
        type = "cppdbg",
        request = "launch",
        program = telescopeBinnary,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,

    })

    table.insert(dap.configurations.cpp, {
        name = 'Attach to gdbserver :1234',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:1234',
        miDebuggerPath = vim.fn.exepath("gdb"),
        cwd = '${workspaceFolder}',
        program = telescopeBinnary

    })
end




dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
