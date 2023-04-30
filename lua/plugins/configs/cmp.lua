-- dofile(vim.g.base46_cache .. "cmp")
local keymaps = require("keymaps.cmp")
local conf = {
  duplicates = {
    buffer = 1,
    path = 1,
    nvim_lsp = 1,
    luasnip = 1,
  },
  duplicates_default = 0,

  source_names = {
    nvim_lsp = "(LSP)",
    nvim_lua = "(neovim)",
    emoji = "(Emoji)",
    path = "(Path)",
    async_path = "(As_path)",
    spell = "(spell)",
    calc = "(Cal)",
    dap = "(Dap)",
    cmp_tabnine = "(Tabnine)",
    vsnip = "(Snippet)",
    luasnip = "(snip)",
    nvim_lsp_document_symbol = "(Doc)",
    nvim_lsp_signature_help = "(Func)",
    buffer = "(Buf)",
    tmux = "(TMUX)",
    copilot = "(Copilot)",
    treesitter = "(Tree)",
    orgmode = "(org)",
  },
}

local my_format = {
  -- fields = { "kind", "abbr", "menu" },
  format = function(entry, vim_item)
    -- vim_item.kind = vim_item.kind or ""
    if vim_item.kind == "Color" and entry.completion_item.documentation then
      local _, _, r, g, b = string.find(entry.completion_item.documentation, "^rgb%((%d+), (%d+), (%d+)")
      if r then
        local color = string.format("%02x", r) .. string.format("%02x", g) .. string.format("%02x", b)
        local group = "Tw_" .. color
        if vim.fn.hlID(group) < 1 then
          vim.api.nvim_set_hl(0, group, { fg = "#" .. color })
        end
        vim_item.kind = "■" -- or "⬤" or anything
        vim_item.kind_hl_group = group
      end
    end

    vim_item.menu = conf.source_names[entry.source.name]
    if entry.completion_item.documentation then
        vim_item.menu = vim_item.menu .. "d"
    end
    -- vim_item.dup = conf.duplicates[entry.source.name] or conf.duplicates_default
    return vim_item
  end,
}
local options = {
  completion = {
    completeopt = "menu,menuone",
    autocomplete = false,
    keyword_length = 2,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = true,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  mapping = keymaps(),
  formatting = my_format,
  sources = {
    {
      name = "spell",
      keyword_length = 2,
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return true
        end,
      },
    },

    { name = "nvim_lsp", keyword_length = 2 },
    { name = "luasnip", keyword_length = 2 },
    { name = "buffer", keyword_length = 2 },
    { name = "nvim_lua", keyword_length = 2 },
    { name = "async_path" },
  },
}

return options
