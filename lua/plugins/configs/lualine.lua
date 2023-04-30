local lualine = require "lualine"
-- local icons = require("icons")


-- Color table for highlights
-- stylua: ignore

local colors = {
    crust    = '#202328',
    text     = '#bbc2cf',
    yellow   = '#ECBE7B',
    teal     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    mauve    = '#a9a1e1',
    flamingo = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}
local is_colors, colors_catppuccin = pcall(require("catppuccin.palettes").get_palette, "mocha")
-- local is_colorsheme, colorsheme = pcall(require, "plugins.configs.ui.colorsheme")
if is_colors then
  -- colors = colors_catppuccin
end
local winbar_filetype_exclude = {
  "help",
  "startify",
  "dashboard",
  "packer",
  "qf",
  "neo-tree",
  "neogitstatus",
  "NvimTree",
  "Trouble",
  "alpha",
  "lir",
  "Outline",
  "spectre_panel",
  "toggleterm",
  "DressingSelect",
  "Jaq",
  "harpoon",
  "dap-repl",
  "dap-terminal",
  "dapui_console",
  "dapui_hover",
  "lab",
  "notify",
  "noice",
  "",
}
local icons_filet = {
  symbols = {
    modified = "●",
    readonly = "[-]",
    unnamed = "[No Name",
    newfile = "[New]",
  },
}
local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand "%:p:h"
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local excludes = function()
  return vim.tbl_contains(winbar_filetype_exclude or {}, vim.bo.filetype)
end
local function is_new_file()
  local filename = vim.fn.expand "%"
  return filename ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(filename) == 0
end
local function getOil()
  local filename = vim.fn.expand "%"
  local _, j = string.find(filename, "oil:///")
  if j then
    local home = vim.fn.expand("$HOME"):gsub("\\/", "\\/")
    filename = string.sub(filename, j):gsub(home, "~")
    return filename
  end
  return nil
end
local filename_func = function(self)
  local filename = getOil()
  local data = filename
  if data == nil then
    if 1 == self.options.path then
      -- relative path
      data = vim.fn.expand "%:~:."
    elseif self.options.path == 2 then
      -- absolute path
      data = vim.fn.expand "%:p"
    elseif self.options.path == 3 then
      -- absolute path, with tilde
      data = vim.fn.expand "%:p:~"
    else
      data = vim.fn.expand "%:t"
    end
  end
  if data == nil then
    return
  end
  local symbols = {}
  if vim.bo.modified then
    table.insert(symbols, self.options.symbols.modified)
  end
  if vim.bo.modifiable == false or vim.bo.readonly == true then
    table.insert(symbols, self.options.symbols.readonly)
  end

  if is_new_file() then
    table.insert(symbols, self.options.symbols.newfile)
  end

  return data .. (#symbols > 0 and " " .. table.concat(symbols, "") or "")
end

local function get_icon(self)
  if getOil() then
    local file_icon, hl_group = " ", "OilDir"

    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*"
  end
  local filename = vim.fn.expand "%:t"
  if filename ~= nil then
    local file_icon, hl_group
    local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
    if devicons_ok then
      file_icon, hl_group = devicons.get_icon(filename, extension, { default = true })

      if file_icon == nil then
        file_icon = "d"
      end
    else
      file_icon = ""
      hl_group = "Normal"
    end
    return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*"
  end
end

local filename_component = {
  filename_func,
  symbols = icons_filet.symbols,
  -- cond = conditions.buffer_not_empty,
  color = "Keyword",
}
local filename_winbar_component = {
  filename_func,
  path = 3,
  symbols = icons_filet.symbols,
  -- cond = function()
  -- 	return conditions.buffer_not_empty() and not excludes()
  -- end,
  color = "Keyword",
}
local tabs = {
  "tabs",
  mode = 0,
  tabs_color = {
    -- Same values as the general color option can be used here.
    active = "ColorColumn", -- Color for active tab.
    inactive = "Normal", -- Color for inactive tab.
  },
}
-- Config
local config = {
  extensions = { "nvim-tree", "toggleterm" },
  options = {
    refresh = {
      -- sets how often lualine should refreash it's contents (in ms)
      statusline = 1000, -- The refresh option sets minimum time that lualine tries
      tabline = 1000, -- to maintain between refresh. It's not guarantied if situation
      winbar = 1000, -- arises that lualine needs to refresh itself before this time
      -- it'll do it.

      -- Also you can force lualine's refresh by calling refresh function
      -- like require('lualine').refresh()
    },
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = "Normal" },
      inactive = { c = "Normal" },
    },
    component_separators = "",
    section_separators = "",
    --
    disabled_filetypes = {
      statusline = {
        "help",
        "startify",
        "dashboard",
        "packer",
        "neogitstatus",
        -- "NvimTree",
        "Trouble",
        "alpha",
        "lir",
        "Outline",
        "spectre_panel",
        -- "toggleterm",
      },
      winbar = winbar_filetype_exclude,
    },
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      -- { get_icon, icon_only = true },
      filename_winbar_component,
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      -- { get_icon, icon_only = true },
      filename_winbar_component,
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_a, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_z, component)
end

local mode_color = function()
  -- auto change color according to neovims mode
  local table = {
    n = "Error",
    i = "diffAdded",
    v = "diffChanged",
    [""] = "diffChanged",
    V = "diffChanged",
    c = "Operator",
    no = "Error",
    s = "Number",
    S = "Number",
    [""] = "Number",
    ic = "WarningMsg",
    R = "Tag",
    Rv = "Tag",
    cv = "Error",
    ce = "Error",
    r = "DiagnosticHint",
    rm = "DiagnosticHint",
    ["r?"] = "DiagnosticHint",
    ["!"] = "Error",
    t = "Error",
  }
  return table[vim.fn.mode()]
end

ins_left {
  function()
    return "▊"
  end,
  color = mode_color,
  padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
  -- mode component
  --
  "mode",
  color = mode_color,
  padding = { right = 1 },
}

ins_left {
  -- filesize component
  "filesize",
  color = "Bold",
  cond = conditions.buffer_not_empty,
}

ins_left(filename_component)

ins_left { "location", color = "Bold" }

ins_left { "progress", color = "Bold" }
local icons_new = {}
-- for key, value in pairs(icons.diagnostic) do
--     icons_new[string.lower(key)] = value
-- end
--

ins_left {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  -- symbols = icons.diagnostic,
  symbols = icons_new,
  -- symbols = { error = " ", warn = " ", info = " " },
  diagnostics_color = {
    color_error = "DiagnosticsError",
    color_warn = "DiagnosticsWarn",
    color_hint = "DiagnosticsHint",
    color_info = "DiagnosticInfo",
  },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_right {
  -- Lsp server name .
  function()
    if not rawget(vim, "lsp") then
      return ""
    end

    local Lsp = vim.lsp.util.get_progress_messages()[1]

    if vim.o.columns < 120 or not Lsp then
      return ""
    end

    local msg = Lsp.message or ""
    local percentage = Lsp.percentage or 0
    local title = Lsp.title or ""
    local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
    local ms = vim.loop.hrtime() / 1000000
    local frame = math.floor(ms / 120) % #spinners
    local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

    -- if config.lsprogress_len then
    --   content = string.sub(content, 1, config.lsprogress_len)
    -- end

    return content
  end,
  color = "Bold",
}

ins_right {
  -- Lsp server name .
  function()
    local names = {}
    for i, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      table.insert(names, server.name)
    end
    return " [" .. table.concat(names, " ") .. "] "
  end,
  color = "Bold",
}

-- Add components to right sections
ins_right {
  "o:encoding", -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = "String",
}

ins_right {
  "fileformat",
  fmt = string.upper,
  icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
  color = "String",
}

ins_right {
  "branch",
  icon = "",
  color = "Keyword",
}
local git_signs = {}

-- for key, value in pairs(icons.git or {}) do
--     git_signs[string.lower(key)] = value
-- end
ins_right {
  "diff",
  -- Is it me or the symbol for modified us really weird
  -- symbols = { added = " ", modified = "柳 ", removed = " " },
  symbols = git_signs,
  diff_color = {
    added = "GitSignsAdd",
    modified = "GitSignsChange",
    removed = "GitSignsDelete",
  },
  cond = conditions.hide_in_width,
}

ins_right(tabs)

-- Now don't forget to initialize lualine
return config
-- return {}
-- require("lualine").setup()
