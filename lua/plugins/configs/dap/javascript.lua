
-- local man = vim.fn.stdpath('data').. "/mason/packages/js-debug-adapter"
-- require("dap-vscode-js").setup {
--     node_path = "node",
--     debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
--     -- debugger_path = man,
--     -- debugger_cmd = { 'js-debug-adapter' },
--     adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
-- }
--
-- for _, language in ipairs { "typescript", "javascript" } do
--     require("dap").configurations[language] = {
--         {
--             name = 'Launch',
--             type = 'pwa-node',
--             request = 'launch',
--             program = '${file}',
--             rootPath = '${workspaceFolder}',
--             cwd = '${workspaceFolder}',
--             sourceMaps = true,
--             skipFiles = { '<node_internals>/**' },
--             protocol = 'inspector',
--             console = 'integratedTerminal',
--         },
--         {
--             name = 'Attach to node process',
--             type = 'pwa-node',
--             request = 'attach',
--             rootPath = '${workspaceFolder}',
--             processId = require('dap.utils').pick_process,
--         },
--         {
--             type = "pwa-node",
--             request = "launch",
--             name = "Debug Jest Tests",
--             -- trace = true, -- include debugger info
--             runtimeExecutable = "node",
--             runtimeArgs = {
--                 "./node_modules/jest/bin/jest.js",
--                 "--runInBand",
--             },
--             rootPath = "${workspaceFolder}",
--             cwd = "${workspaceFolder}",
--             console = "integratedTerminal",
--             internalConsoleOptions = "neverOpen",
--         },
--     }
-- end
--
-- for _, language in ipairs { "typescriptreact", "javascriptreact" } do
--     require("dap").configurations[language] = {
--         {
--             type = "pwa-chrome",
--             name = "Attach - Remote Debugging",
--             request = "attach",
--             program = "${file}",
--             cwd = vim.fn.getcwd(),
--             sourceMaps = true,
--             protocol = "inspector",
--             port = 9222,
--             webRoot = "${workspaceFolder}",
--         },
--         {
--             type = "pwa-chrome",
--             name = "Launch Chrome",
--             request = "launch",
--             url = "http://localhost:3000",
--         },
--     }
-- end
--
local man = vim.fn.stdpath('data').. "/mason/packages/js-debug-adapter/js-debug-adapter"
require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = man,
        -- 💀 Make sure to update this path to point to your installation
        args = {  "${port}" },
    }
}

require("dap").adapters["pwa-chrome"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    id = "pwa-chrome",
    executable = {
        command = man,
        -- 💀 Make sure to update this path to point to your installation
        args = {  "${port}" },
    }
}
-- for _, language in ipairs { "typescript", "javascript" } do
--     require("dap").configurations[language] = {
--         {
--             name = 'Launch',
--             type = 'pwa-node',
--             request = 'launch',
--             program = '${file}',
--             rootPath = '${workspaceFolder}',
--             cwd = '${workspaceFolder}',
--             sourceMaps = true,
--             skipFiles = { '<node_internals>/**' },
--             protocol = 'inspector',
--             console = 'integratedTerminal',
--         },
--         {
--             name = 'Attach to node process',
--             type = 'pwa-node',
--             request = 'attach',
--             rootPath = '${workspaceFolder}',
--             processId = require('dap.utils').pick_process,
--         },
--         {
--             type = "pwa-node",
--             request = "launch",
--             name = "Debug Jest Tests",
--             -- trace = true, -- include debugger info
--             runtimeExecutable = "node",
--             runtimeArgs = {
--                 "./node_modules/jest/bin/jest.js",
--                 "--runInBand",
--             },
--             rootPath = "${workspaceFolder}",
--             cwd = "${workspaceFolder}",
--             console = "integratedTerminal",
--             internalConsoleOptions = "neverOpen",
--         },
--     }
-- end
--

-- require("dap").configurations.javascript = {
--     {
--         type = "pwa-node",
--         request = "attach",
--         name = "Attach",
--         processId = require("dap.utils").pick_process,
--         cwd = "${workspaceFolder}",
--
--     },
--
--       {
--         type = "pwa-node",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--       },
-- }
-- local DEBUGGER_PATH = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug"
--  require("dap-vscode-js").setup {
--     node_path = "node",
--     debugger_path = DEBUGGER_PATH,
--     -- debugger_cmd = { "js-debug-adapter" },
--     adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
--   }
--
--   for _, language in ipairs { "typescript", "javascript" } do
--     require("dap").configurations[language] = {
--       {
--         type = "pwa-node",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--       },
--       {
--         type = "pwa-node",
--         request = "attach",
--         name = "Attach",
--         processId = require("dap.utils").pick_process,
--         cwd = "${workspaceFolder}",
--       },
--       {
--         type = "pwa-node",
--         request = "launch",
--         name = "Debug Jest Tests",
--         -- trace = true, -- include debugger info
--         runtimeExecutable = "node",
--         runtimeArgs = {
--           "./node_modules/jest/bin/jest.js",
--           "--runInBand",
--         },
--         rootPath = "${workspaceFolder}",
--         cwd = "${workspaceFolder}",
--         console = "integratedTerminal",
--         internalConsoleOptions = "neverOpen",
--       },
--     }
--   end
--
  -- for _, language in ipairs { "typescriptreact", "javascriptreact","javascript" } do
  --   require("dap").configurations[language] = {
  --     {
  --       type = "pwa-chrome",
  --       name = "Attach - Remote Debugging",
  --       request = "attach",
  --       program = "${file}",
  --       cwd = vim.fn.getcwd(),
  --       sourceMaps = true,
  --       protocol = "inspector",
  --       port = 9222,
  --       webRoot = "${workspaceFolder}",
  --     },
  --     {
  --       type = "pwa-chrome",
  --       name = "Launch Chrome",
  --       request = "launch",
  --       url = "http://localhost:3000",
  --     },
  --   }
  -- end
-- -- local man = vim.fn.exepath('js-debug-adapter')
-- --
-- -- if man and #man > 0 then
-- --     require("dap").adapters["pwa-node"] = {
-- --         type = "server",
-- --         host = "localhost",
-- --         port = "${port}",
-- --         executable = {
-- --             command = "js-debug-adapter", -- As I'm using mason, this will be in the path
-- --             args = { "${port}" },
-- --         }
-- --     }
-- --
-- --     for _, language in ipairs { "typescript", "javascript" } do
-- --         require("dap").configurations[language] = {
-- --             {
-- --                 type = "pwa-node",
-- --                 request = "attach",
-- --                 name = "Attach to node",
-- --                 processId = require("dap.utils").pick_process,
-- --                 cwd = "${workspaceFolder}",
-- --             },
-- --
-- --             {
-- --                 type = "pwa-node",
-- --                 request = "launch",
-- --                 name = "Launch file",
-- --                 program = "${file}",
-- --                 cwd = "${workspaceFolder}",
-- --             },
-- --         }
-- --     end
-- -- end
-- -- -- for _, language in ipairs { "typescript", "javascript" } do
-- -- --     require("dap").configurations[language] = {
-- -- --         {
-- -- --             type = "pwa-node",
-- -- --             request = "launch",
-- -- --             name = "Launch file",
-- -- --             program = "${file}",
-- -- --             cwd = "${workspaceFolder}",
-- -- --
-- -- --         },
-- -- --         {
-- -- --             type = "pwa-node",
-- -- --             request = "attach",
-- -- --             name = "Attach",
-- -- --             processId = require("dap.utils").pick_process,
-- -- --             cwd = "${workspaceFolder}",
-- -- --         },
-- -- --         {
-- -- --             type = "pwa-node",
-- -- --             request = "launch",
-- -- --             name = "Debug Jest Tests",
-- -- --             -- trace = true, -- include debugger info
-- -- --             runtimeExecutable = "node",
-- -- --             runtimeArgs = {
-- -- --                 "./node_modules/jest/bin/jest.js",
-- -- --                 "--runInBand",
-- -- --             },
-- -- --             rootPath = "${workspaceFolder}",
-- -- --             cwd = "${workspaceFolder}",
-- -- --             console = "integratedTerminal",
-- -- --             internalConsoleOptions = "neverOpen",
-- -- --         },
-- -- --     }
-- -- -- end
-- --
-- -- for _, language in ipairs { "typescriptreact", "javascriptreact" } do
-- --     require("dap").configurations[language] = {
-- --         {
-- --             type = "pwa-chrome",
-- --             name = "Attach - Remote Debugging",
-- --             request = "attach",
-- --             program = "${file}",
-- --             cwd = vim.fn.getcwd(),
-- --             sourceMaps = true,
-- --             protocol = "inspector",
-- --             port = 9222,
-- --             webRoot = "${workspaceFolder}",
-- --         },
-- --         {
-- --             type = "pwa-chrome",
-- --             name = "Launch Chrome",
-- --             request = "launch",
-- --             url = "http://localhost:3000",
-- --         },
-- --     }
-- -- end
