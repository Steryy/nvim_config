
local textchanged = require("cmp.types").cmp.TriggerEvent.TextChanged
local M = {}
-- toggle cmp completion
vim.g.cmp_toggle_flag = false -- initialize
local normal_buftype = function()
  return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
end
M.toggle_completion = function()
  local ok, cmp = pcall(require, "cmp")
  if ok then
    vim.g.cmp_toggle_flag = not vim.g.cmp_toggle_flag
    if vim.g.cmp_toggle_flag then
      print "completion on"
    else
      print "completion off"
    end
    cmp.setup {
      enabled = vim.g.cmp_toggle_flag and normal_buftype or false,

      completion = {
        completeopt = "menu,menuone",
        autocomplete = { textchanged },
        keyword_length = 2,
      },
    }
  else
    print "completion not available"
  end
end
local cmp = require "cmp"
 return function()
  return {
    ["<C-h>"] = cmp.mapping(function(fallback)
      local luasnip = require "luasnip"
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
        -- else
        -- 	fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-l>"] = cmp.mapping(function(fallback)
      local luasnip = require "luasnip"
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        -- else
        -- 	fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-j>"] = cmp.mapping(function(fallback)
      local luasnip = require "luasnip"
      if luasnip.choice_active() then
        luasnip.change_choice(1)
        -- else
        -- 	fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<Down>"] = cmp.mapping(
      cmp.mapping.select_next_item {
        behavior = cmp.SelectBehavior.Select,
      },
      { "i" }
    ),
    ["<Up>"] = cmp.mapping(
      cmp.mapping.select_prev_item {
        behavior = cmp.SelectBehavior.Select,
      },
      { "i" }
    ),
    ["<C-p>"] = cmp.mapping.select_prev_item {
      behavior = cmp.SelectBehavior.Select,
    },
    ["<C-S-n>"] = cmp.mapping.select_next_item {
      behavior = cmp.SelectBehavior.Select,
    },
    ["<C-n>"] = cmp.mapping.select_next_item {
      behavior = cmp.SelectBehavior.Select,
    },
    -- ["<C-k>"] = cmp.mapping.select_prev_item({
    -- 	behavior = cmp.SelectBehavior.Insert,
    -- }),
    -- ["<C-j>"] = cmp.mapping.select_next_item({
    -- 	behavior = cmp.SelectBehavior.Insert,
    -- }),
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-space>"] = cmp.mapping {
      i = function()
        if cmp.visible() or vim.g.cmp_toggle_flag then
          cmp.abort()
          M.toggle_completion()
        else
          cmp.complete()
          M.toggle_completion()
        end
      end,
    },
    ["<CR>"] = cmp.mapping {
      i = function(fallback)
        if cmp.visible() then
          cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
        else
          fallback()
        end
      end,
    },
  }
end


