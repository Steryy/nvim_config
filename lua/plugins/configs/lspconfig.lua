local M = {}
local utils = require "core.utils"

local get_icon = require("core.utils").get_icon
local signs = {
  { name = "DiagnosticSignError", text = get_icon "DiagnosticError", texthl = "DiagnosticSignError" },
  { name = "DiagnosticSignWarn", text = get_icon "DiagnosticWarn", texthl = "DiagnosticSignWarn" },
  { name = "DiagnosticSignHint", text = get_icon "DiagnosticHint", texthl = "DiagnosticSignHint" },
  { name = "DiagnosticSignInfo", text = get_icon "DiagnosticInfo", texthl = "DiagnosticSignInfo" },
  { name = "DapStopped", text = get_icon "DapStopped", texthl = "DiagnosticWarn" },
  { name = "DapBreakpoint", text = get_icon "DapBreakpoint", texthl = "DiagnosticInfo" },
  { name = "DapBreakpointRejected", text = get_icon "DapBreakpointRejected", texthl = "DiagnosticError" },
  { name = "DapBreakpointCondition", text = get_icon "DapBreakpointCondition", texthl = "DiagnosticInfo" },
  { name = "DapLogPoint", text = get_icon "DapLogPoint", texthl = "DiagnosticInfo" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, sign)
end
vim.diagnostic.config {
  virtual_text = {
    prefix = "",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
}
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
  focusable = false,
  relative = "cursor",
})

-- Borders for LspInfo winodw
local win = require "lspconfig.ui.windows"
local _default_opts = win.default_opts

win.default_opts = function(options)
  local opts = _default_opts(options)
  opts.border = "single"
  return opts
end
-- export on_attach & capabilities for custom lspconfigs

local is_available = utils.is_available
M.on_attach = function(client, bufnr)
  client.server_capabilities.semanticTokensProvider = false

  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  local capabilities = client.server_capabilities
  local lsp_mappings = {
    n = {
      ["<leader>ld"] = {
        function()
          vim.diagnostic.open_float()
        end,
        desc = "Hover diagnostics",
      },
      ["[d"] = {
        function()
          vim.diagnostic.goto_prev()
        end,
        desc = "Previous diagnostic",
      },
      ["]d"] = {
        function()
          vim.diagnostic.goto_next()
        end,
        desc = "Next diagnostic",
      },
      ["gl"] = {
        function()
          vim.diagnostic.open_float()
        end,
        desc = "Hover diagnostics",
      },
    },
    v = {},
  }

  lsp_mappings.n["<leader>fm"] = {
    function()
      vim.lsp.buf.format { async = true }
    end,
    "lsp formatting",
  }

  if capabilities.declarationProvider then
    lsp_mappings.n["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      desc = "Declaration of current symbol",
    }
  end

  lsp_mappings.n["gd"] = {
    function()
      vim.lsp.buf.definition()
    end,
    desc = "Show the definition of current symbol",
  }
  if is_available "mason-lspconfig.nvim" then
    lsp_mappings.n["<leader>li"] = { "<cmd>LspInfo<cr>", desc = "LSP information" }
  end

  if is_available "null-ls.nvim" then
    lsp_mappings.n["<leader>lI"] = { "<cmd>NullLsInfo<cr>", desc = "Null-ls information" }
  end

  lsp_mappings.n["K"] = {
    function()
      vim.lsp.buf.hover()
    end,
    desc = "Hover symbol details",
  }

  lsp_mappings.n["gI"] = {
    function()
      vim.lsp.buf.implementation()
    end,
    desc = "Implementation of current symbol",
  }

  lsp_mappings.n["gr"] = {
    function()
      vim.lsp.buf.references()
    end,
    desc = "References of current symbol",
  }
  lsp_mappings.n["<leader>lR"] = {
    function()
      vim.lsp.buf.references()
    end,
    desc = "Search references",
  }

  lsp_mappings.n["<leader>lr"] = {
    function()
      vim.lsp.buf.rename()
    end,
    desc = "Rename current symbol",
  }

  lsp_mappings.n["<leader>lh"] = {
    function()
      vim.lsp.buf.signature_help()
    end,
    desc = "Signature help",
  }

  lsp_mappings.n["gT"] = {
    function()
      vim.lsp.buf.type_definition()
    end,
    desc = "Definition of current type",
  }

  lsp_mappings.n["<leader>lG"] = {
    function()
      vim.lsp.buf.workspace_symbol()
    end,
    desc = "Search workspace symbols",
  }

  --  if capabilities.semanticTokensProvider and vim.lsp.semantic_tokens then
  --    lsp_mappings.n["<leader>uY"] = {
  --      function() require("astronvim.utils.ui").toggle_buffer_semantic_tokens(bufnr) end,
  --      desc = "Toggle LSP semantic highlight (buffer)",
  --    }
  --  end

  if is_available "telescope.nvim" then -- setup telescope mappings
    if lsp_mappings.n.gd then
      lsp_mappings.n.gd[1] = function()
        require("telescope.builtin").lsp_definitions()
      end
    end
    if lsp_mappings.n.gI then
      lsp_mappings.n.gI[1] = function()
        require("telescope.builtin").lsp_implementations()
      end
    end
    if lsp_mappings.n.gr then
      lsp_mappings.n.gr[1] = function()
        require("telescope.builtin").lsp_references()
      end
    end
    if lsp_mappings.n["<leader>lR"] then
      lsp_mappings.n["<leader>lR"][1] = function()
        require("telescope.builtin").lsp_references()
      end
    end
    if lsp_mappings.n.gT then
      lsp_mappings.n.gT[1] = function()
        require("telescope.builtin").lsp_type_definitions()
      end
    end
    if lsp_mappings.n["<leader>lG"] then
      lsp_mappings.n["<leader>lG"][1] = function()
        vim.ui.input({ prompt = "Symbol Query: " }, function(query)
          if query then
            require("telescope.builtin").lsp_workspace_symbols { query = query }
          end
        end)
      end
    end
  end

  for mode, tab in pairs(lsp_mappings) do
    for key, values in pairs(tab) do
      local opts = { buffer = bufnr, remap = false }

      if values.desc then
        opts.desc = values.desc
      end
      vim.keymap.set(mode, key, values[1], opts)
    end
  end
end

local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
local base = {}
if ok_lspconfig then
  base = lspconfig.util.default_config.capabilities
else
  base = vim.lsp.protocol.make_client_capabilities()
end
local cmp_default_capabilities = {}
local ok_lsp_source, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_lsp_source then
  cmp_default_capabilities = cmp_lsp.default_capabilities()
end

M.capabilities = vim.tbl_deep_extend("force", base, cmp_default_capabilities)
M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local lspconfig = require "lspconfig"
local servers = {
  "html",
  "cssls",
  "tsserver",
  "clangd",
  "tailwindcss",
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {

          library = {
            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
            [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  },
  ltex = {
    autostart = false,
    settings = {
      ltex = {
        markdown = {
          nodes = {
            CodeBlock = "ignore",
            FencedCodeBlock = "ignore",
            AutoLink = "ignore",
            Code = "ignore",
            LatexBlock = "ignore",
          },
        },
        -- enabled = false,
      },
    },
  },
}
local default_settings = {
  on_attach = M.on_attach,
  capabilities = M.capabilities,
}
local is_ts, typescript = pcall(require, "typescript")

for ind, lsp in pairs(servers) do
  local name = ""
  local settings = default_settings
  if type(lsp) == "string" then
    name = lsp
  elseif type(lsp) == "table" then
    name = tostring(ind)
    settings = vim.tbl_deep_extend("force", settings, lsp)
  end
  if is_ts and name == "tsserver" then
    settings.on_attach = function(client, bufer)
      M.on_attach(client, bufer)
      vim.keymap.set("n", "<leader>ci", "<cmd>TypescriptAddMissingImports<cr>", { buffer = bufer })
      vim.keymap.set("n", "<leader>cr", "<cmd>TypescriptRenameFile<cr>", { buffer = bufer })
    end
    typescript.setup(settings)
    goto continue
  end

  lspconfig[name].setup(settings)
  ::continue::
end
return M
