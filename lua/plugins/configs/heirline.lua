local s = {}
local get_icon = require("core.utils").get_icon
local fn = vim.fn
local conditions = require "heirline.conditions"
local utils = require "heirline.utils"

local function setup_colors()
  return {
    bright_bg = utils.get_highlight("Folded").bg,
    bright_fg = utils.get_highlight("Folded").fg,
    red = utils.get_highlight("DiagnosticError").fg,
    normal_bg = utils.get_highlight("Normal").bg,
    dark_red = utils.get_highlight("DiffDelete").bg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    gray = utils.get_highlight("NonText").fg,
    orange = utils.get_highlight("Constant").fg,
    purple = utils.get_highlight("Statement").fg,
    cyan = utils.get_highlight("Special").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    git_del = utils.get_highlight("diffDeleted").fg,
    git_add = utils.get_highlight("diffAdded").fg,
    git_change = utils.get_highlight("diffChanged").fg,
  }
end
local colors = setup_colors()

local ViMode = {
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  static = {
    mode_names = {
      n = "N",
      no = "N?",
      nov = "N?",
      noV = "N?",
      ["no\22"] = "N?",
      niI = "Ni",
      niR = "Nr",
      niV = "Nv",
      nt = "Nt",
      v = "V",
      vs = "Vs",
      V = "V_",
      Vs = "Vs",
      ["\22"] = "^V",
      ["\22s"] = "^V",
      s = "S",
      S = "S_",
      ["\19"] = "^S",
      i = "I",
      ic = "Ic",
      ix = "Ix",
      R = "R",
      Rc = "Rc",
      Rx = "Rx",
      Rv = "Rv",
      Rvc = "Rv",
      Rvx = "Rv",
      c = "C",
      cv = "Ex",
      r = "...",
      rm = "M",
      ["r?"] = "?",
      ["!"] = "!",
      t = "T",
    },
  },
  provider = function(self)
    return "▊%2(" .. self.mode_names[self.mode] .. "%)"
  end,
  hl = function(self)
    local color = self:mode_color()
    return { fg = color, bold = true }
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd "redrawstatus"
    end),
  },
}
local FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (" " .. self.icon .. " ")
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ":t")
    if filename == "" then
      return "[No Name]"
    end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = { fg = "purple" },
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = get_icon "FileModified",
    hl = { fg = "purple" },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = get_icon "FileReadOnly",
    hl = { fg = "orange" },
  },
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = "purple", bold = true, force = true }
    end
  end,
}
-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(
  FileNameBlock,
  FileIcon,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  FileFlags,
  { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)
table.insert(s, ViMode)

local FileSize = {
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { "b", "k", "M", "G", "T", "P", "E" }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize == 0 then
      return ""
    end
    if fsize < 1024 then
      return " " .. fsize .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return " " .. string.format(" %.2g%s ", fsize / math.pow(1024, i), suffix[i + 1])
  end,

  hl = { bold = true },
}
table.insert(s, FileSize)
table.insert(s, FileNameBlock)
local FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'

    return string.upper(enc)
  end,
}

local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = function()
    local current_line = fn.line "."
    local total_line = fn.line "$"
    local text = math.modf((current_line / total_line) * 100) .. tostring "%%"
    text = string.format("%4s", text)

    text = (current_line == 1 and "Top") or text
    text = (current_line == total_line and "Bot") or text
    return "%l:%c " .. text
  end,
  hl = { bold = true },
}
-- I take no credits for this! :lion:
local ScrollBar = {
  static = {
    sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
    -- Another variant, because the more choice the better.
    -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = "blue" },
}

local WorkDir = {
  init = function(self)
    self.icon = " "
    local cwd = vim.fn.getcwd(0)
    self.cwd = vim.fn.fnamemodify(cwd, ":t")
  end,
  hl = { fg = "blue", bold = true },

  flexible = 1,

  {
    -- evaluates to the full-lenth path
    provider = function(self)
      local trail = self.cwd:sub(-1) == "/" and "" or "/"
      return self.icon .. self.cwd .. trail .. " "
    end,
  },
  {
    -- evaluates to the shortened path
    provider = function(self)
      local cwd = vim.fn.pathshorten(self.cwd)
      local trail = self.cwd:sub(-1) == "/" and "" or "/"
      return self.icon .. cwd .. trail .. " "
    end,
  },
  {
    -- evaluates to "", hiding the component
    provider = "",
  },
}
local LSPActive = {
  condition = conditions.lsp_attached,
  update = { "LspAttach", "LspDetach" },

  -- You can keep it simple,
  -- provider = " [LSP]",

  -- Or complicate things a bit and get the servers names
  provider = function()
    local names = {}
    for i, server in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      table.insert(names, server.name)
    end
    return " [" .. table.concat(names, " ") .. "] "
  end,
  hl = { fg = "green", bold = true },
}
local LSPStatus = {

  condition = conditions.lsp_attached,
  update = {
    "User",
    pattern = { "LspProgressUpdate", "LspRequest", "CursorMoved" },
    callback = vim.schedule_wrap(function()
      vim.cmd.redrawstatus()
    end),
  },
  provider = function()
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
    -- if percentage == 100 or percentage == 0 then
    --   return ""
    -- end
    -- if config.lsprogress_len then
    --   content = string.sub(content, 1, config.lsprogress_len)
    -- end

    return content
  end,
}

local Diagnostics = {

  condition = conditions.has_diagnostics,

  static = {
    error_icon = get_icon "DiagnosticError",
    warn_icon = get_icon "DiagnosticWarn",
    info_icon = get_icon "DiagnosticInfo",
    hint_icon = get_icon "DiagnosticHint",
  },
  --
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = "DiagnosticError",
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = { fg = "diag_warn" },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = { fg = "diag_info" },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = "diag_warn" },
  },
}
local SearchCount = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
  end,
}
local Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  { -- git branch name
    provider = function(self)
      return self.status_dict.head
    end,
    hl = { bold = true },
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and (get_icon "GitAdd" .. count)
    end,
    hl = { fg = "git_add" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and (get_icon "GitDelete" .. count)
    end,
    hl = { fg = "git_del" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and (get_icon "GitChange" .. count)
    end,
    hl = { fg = "git_change" },
  },
}
local Space = { provider = " " }

local Spell = {
  condition = function()
    return vim.wo.spell
  end,
  provider = function()
    return "󰓆 " .. vim.o.spelllang .. " "
  end,
  hl = { bold = true, fg = "green" },
}

local SearchCount = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    return string.format(" %d/%d", search.current, math.min(search.total, search.maxcount))
  end,
  hl = { fg = "purple", bold = true },
}

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  provider = " ",
  hl = { fg = "orange", bold = true },
  utils.surround({ "[", "]" }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    hl = { fg = "green", bold = true },
  }),
  update = {
    "RecordingEnter",
    "RecordingLeave",
  },
  { provider = " " },
}

-- WIP
local VisualRange = {
  condition = function()
    return vim.tbl_containsvim({ "V", "v" }, vim.fn.mode())
  end,
  provider = function()
    local start = vim.fn.getpos "'<"
    local stop = vim.fn.getpos "'>"
  end,
}

local ShowCmd = {
  condition = function()
    return vim.o.cmdheight == 0
  end,
  provider = ":%3.5(%S%)",
  -- hl = function(self)
  --   return { bold = true, fg = self:mode_color() }
  -- end,
}
local StatusLines = {
  static = {
    mode_colors = {
      n = "red",
      i = "green",
      v = "cyan",
      V = "cyan",
      ["\22"] = "cyan", -- this is an actual ^V, type <C-v><C-v> in insert mode
      c = "orange",
      s = "purple",
      S = "purple",
      ["\19"] = "purple", -- this is an actual ^S, type <C-v><C-s> in insert mode
      R = "orange",
      r = "orange",
      ["!"] = "red",
      t = "green",
    },
    mode_color = function(self)
      local mode = conditions.is_active() and vim.fn.mode() or "n"
      return self.mode_colors[mode]
    end,
  },
  hl = function(self)
    return { bg = "bright_bg" }
  end,
  { -- first root, with two levels of nesting, for a total of #3 levels
    ViMode,
    MacroRec,
    ShowCmd,
    -- WorkDir,
    FileSize,
    FileNameBlock,
    Space,
    Ruler,
    Space,
    SearchCount,
    Diagnostics,
  },
  { provider = "%=" },
  { LSPStatus, Space, Git, Space, LSPActive, Space, FileEncoding },
}
-- local colors = require("kanagawa.colors").setup()

-- require("heirline").load_colors(setup_colors)
-- or pass it to config.opts.colors

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    utils.on_colorscheme(setup_colors)
  end,
  group = "Heirline",
})
local WinBar = {

  { provider = "%=" },
  {
    hl = { fg = "purple" },
    provider = function(a)
      local filename = vim.api.nvim_buf_get_name(0)
      local file = vim.fn.fnamemodify(filename, ":t")
      if file == "" then
        return filename
      end
      return file
    end,
  },
  { provider = "%=" },
}

vim.o.laststatus = 3
require("heirline").setup {
  statusline = StatusLines,
  winbar = WinBar,
  -- tabline = TabLine,
  -- statuscolumn = Stc,
  opts = {
    disable_winbar_cb = function(args)
      if vim.bo[args.buf].filetype == "neo-tree" then
        return
      end
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
      }, args.buf)
    end,
    colors = setup_colors,
  },
}

-- vim.o.statuscolumn = require("heirline").eval_statuscolumn()

vim.api.nvim_create_augroup("Heirline", { clear = true })

vim.cmd [[au Heirline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]

-- vim.cmd("au BufWinEnter * if &bt != '' | setl stc= | endif")

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    utils.on_colorscheme(setup_colors)
  end,
  group = "Heirline",
})
vim.o.showcmdloc = "statusline"
