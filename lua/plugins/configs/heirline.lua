--[[
| |__   ___(_)_ __| (_)_ __   ___   _ ____   _(_)_ __ ___
|w | | |  __/ | |  | | | | | |  __/_| | | \ V /| | | | | | |
 _          _      _ _                         _
|_| |_|\___|_|_|  |_|_|_| |_|\___(_)_| |_|\_/ |_|_| |_| |_|
| '_ \ / _ \ | '__| | | '_ \ / _ \ | '_ \ \ / / | '_ ` _ \

--]]
local conditions = require("heirline.conditions")
local get_icon = require("core.utils").get_icon
local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

local BLACK = "NONE"
local BLUE = "#7766ff"
local CYAN = "#33dbc3"
local GRAY_DARK = "#353535"
local GRAY_LIGHT = "#c0c0c0"
local GREEN = "#22ff22"
local GREEN_DARK = "#70d533"
local GREEN_LIGHT = "#99ff99"
local ICE = "#95c5ff"
local ORANGE = "#ff8900"
local ORANGE_LIGHT = "#f0af00"
local PINK = "#ffa6ff"
local PINK_LIGHT = "#ffb7b7"
local PURPLE = "#cf55f0"
local PURPLE_LIGHT = "#af60af"
local RED = "#ee4a59"
local RED_DARK = "#a80000"
local RED_LIGHT = "#ff4090"
local TAN = "#f4c069"
local TEAL = "#60afff"
local TURQOISE = "#2bff99"
local WHITE = "#ffffff"
local YELLOW = "#f0df33"

local SIDEBAR = BLACK
local MIDBAR = GRAY_DARK
local TEXT = GRAY_LIGHT

--[[/* HELPERS */]]
local space = { provider = " " }
local get_fg = vim.api.nvim_get_hl
    --- TODO: remove when 0.9 releases
    --- @param name string
    --- @return string fg
    and function(name)
        return vim.api.nvim_get_hl(0, { link = false, name = name }).fg
    end
    --- TODO: remove when 0.9 releases
    --- @param name string
    --- @return integer fg
    or function(name)
        return vim.api.nvim_get_hl_by_name(name, true).foreground
    end

--- Set buffer variables for file icon and color.
--- @return {color: string, icon: string}
local function buf_init_devicons()
    local icon, color =
        require("nvim-web-devicons").get_icon(vim.fn.expand("%:t"), vim.fn.expand("%:e"), { default = true })
    local dev_icons = { color = get_fg(color), icon = icon }

    vim.b.dev_icons = dev_icons
    return dev_icons
end

--- @return {color: string, icon: string}
local function filetype_info()
    return vim.b.dev_icons or buf_init_devicons()
end
local is_color, color = require("lualine.themes.auto_flip")
if is_color then

end
--[[/* HEIRLINE CONFIG */]]
--- Components separated by this component will be padded with an equal number of spaces.
local ALIGN = { provider = "%=" }

--- A left separator.
local vimode = function(dir)
    return {
          -- ViMode {{{
        hl = function(self)
            return { fg = self.color }
        end,
        init = function(self)
            local current_mode = self.modes[vim.api.nvim_get_mode().mode]
            self.name = current_mode[1]
            self.color = current_mode[2]
        end,
        provider = function(self)
            return " " .. self.name
        end,
        update = {
            "ModeChanged",
            callback = vim.schedule_wrap(function()
                vim.api.nvim_command("redrawstatus")
            end),
            pattern = "*:*",
        },
    } -- }}}
end

local function null_ls_providers(filetype)
    local registered = {}
    -- try to load null-ls
    local sources_avail, sources = pcall(require, "null-ls.sources")
    if sources_avail then
        -- get the available sources of a given filetype
        for _, source in ipairs(sources.get_available(filetype)) do
            -- get each source name
            for method in pairs(source.methods) do
                registered[method] = registered[method] or {}
                table.insert(registered[method], source.name)
            end
        end
    end
    -- return the found null-ls sources
    return registered
end
local function null_ls_sources(filetype, method)
    local methods_avail, methods = pcall(require, "null-ls.methods")
    return methods_avail and null_ls_providers(filetype)[methods.internal[method]] or {}
end
local gitcomponent =
{
    -- Git {{{
    init = function(self)
        local branch = vim.g.loaded_fugitive == 1 and
            vim.fn.FugitiveHead() or nil
        -- buffer can be null and code will crash with:
        -- E5108: Error executing lua ... 'attempt to index a nil value'
        -- fugitive is empty or not loaded, try gitsigns
        if not branch or #branch == 0 then
            branch = vim.b.gitsigns_status_dict
        end
        self.status = branch

        if not self.once then
            local command = "doautocmd User BufEnterOrGitSignsUpdate"
            vim.api.nvim_create_autocmd("BufEnter", { command = command, group = augroup("config") })
            vim.api.nvim_create_autocmd("User",
                { command = command, group = augroup("config"), pattern = "GitSignsUpdate" })
        end
    end,
    update = { "User", pattern = "BufEnterOrGitSignsUpdate" },

    {
     -- Branch {{{
        hl = { fg = GREEN_DARK },

        {
            condition = function(self)
                return self.status
            end,
            provider = function(self)
                return get_icon("GitBranch").." " .. self.status.head
            end,
            -- hl = { fg = SIDEBAR, bold = true },
        },
    }, -- }}}
    {
      -- Diff {{{
        hl = { fg = MIDBAR },

        {
            condition = function(self)
                return self.status
            end,
            static = {
                --- @param sign string
                --- @param change string
                --- @return nil|string
                provide = function(self, sign, change)
                    local count = self.status[change] or 0
                    if count > 0 then
                        return " " .. sign .. count
                    end
                end,
            },

            {
                hl = { fg = GREEN },
                provider = function(self)
                    return self:provide(get_icon("GitAdd"), "added")
                end,
            },

            {
                hl = { fg = ORANGE_LIGHT },
                provider = function(self)
                    return self:provide(get_icon("GitChange"), "changed")
                end,
            },

            {
                hl = { fg = RED_LIGHT },
                provider = function(self)
                    return self:provide(get_icon("GitDelete"), "removed")
                end,
            },
        },
    }, -- }}}

    space,
}





require("heirline").setup({
    statusline = {
        -- LEFT {{{
        static = {
             -- {{{
            group = "HeirlineViMode",
            modes = {
                ["c"] = { "COMMAND-LINE", RED },
                ["ce"] = { "NORMAL EX", RED_DARK },
                ["cv"] = { "EX", RED_LIGHT },

                ["i"] = { "INSERT", GREEN },

                ["ic"] = { "INS-COMPLETE", GREEN_LIGHT },
                ["ix"] = { "INS-COMPLETE", GREEN_LIGHT },
                ["Rc"] = { "REP-COMPLETE", GREEN_LIGHT },
                ["Rvc"] = { "VIRT-REP-COMPLETE", GREEN_LIGHT },
                ["Rvx"] = { "VIRT-REP-COMPLETE", GREEN_LIGHT },
                ["Rx"] = { "REP-COMPLETE", GREEN_LIGHT },

                ["n"] = { "NORMAL", PURPLE_LIGHT },
                ["niI"] = { "INS-NORMAL", PURPLE_LIGHT },
                ["niR"] = { "REP-NORMAL", PURPLE_LIGHT },
                ["niV"] = { "VIRT-REP-NORMAL", PURPLE_LIGHT },
                ["nt"] = { "TERM-NORMAL", PURPLE_LIGHT },
                ["ntT"] = { "TERM-NORMAL", PURPLE_LIGHT },

                ["no"] = { "OPERATOR-PENDING", PURPLE },
                ["nov"] = { "CHAR OPERATOR-PENDING", PURPLE },
                ["noV"] = { "LINE OPERATOR-PENDING", PURPLE },
                ["no"] = { "BLOCK OPERATOR-PENDING", PURPLE },

                ["R"] = { "REPLACE", PINK },
                ["Rv"] = { "VIRT-REPLACE", PINK_LIGHT },

                ["r"] = { "HIT-ENTER", CYAN },
                ["rm"] = { "--MORE", ICE },
                ["r?"] = { ":CONFIRM", CYAN },

                ["s"] = { "SELECT", TURQOISE },
                ["S"] = { "SELECT LINE", TURQOISE },
                [""] = { "SELECT", TURQOISE },

                ["v"] = { "VISUAL", BLUE },
                ["vs"] = { "SEL-VISUAL", BLUE },
                ["V"] = { "VISUAL LINE", BLUE },
                ["Vs"] = { "SEL-VISUAL LINE", BLUE },
                [""] = { "VISUAL BLOCK", BLUE },
                ["s"] = { "VISUAL BLOCK", BLUE },

                ["t"] = { "TERMINAL", ORANGE },
                ["!"] = { "SHELL", YELLOW },

                -- libmodal
                ["BUFFERS"] = TEAL,
                ["TABLES"] = ORANGE_LIGHT,
                ["TABS"] = TAN,
            },
        }, -- }}}
        hl = { bg = SIDEBAR, bold = true, fg = PURPLE_LIGHT },
        vimode(0),
        gitcomponent,
        {
            hl = { fg = WHITE, bold = true },
            update = { "BufEnter", "BufWritePost" },
            provider = function()
                -- stackoverflow, compute human readable file size
                local suffix = { "b", "k", "M", "G", "T", "P", "E" }
                local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
                fsize = (fsize < 0 and 0) or fsize
                if fsize == 0 then
                    return ""
                end
                if fsize < 1024 then
                    return fsize .. suffix[1]
                end
                local i = math.floor((math.log(fsize) / math.log(1024)))
                return string.format("%.2g%s ", fsize / math.pow(1024, i), suffix[i + 1])
            end,

        },

        {
        -- File Icon {{{
            hl = function(self)
                return { bg = SIDEBAR, fg = self.file and self.file.color or TEXT }
            end,
            init = function(self)
                self.file = filetype_info()
            end,
            update = "BufEnter",

            {
                provider = function(self)
                    if vim.g.icons_enabled then
                        return self.file.icon
                    end
                    return "[%Y]"
                end,
            },
        }, -- }}}
        space,

        {
            -- hl = function(self)
            -- 	local colors = self.modes[vim.api.nvim_get_mode().mode] or {}
            -- 	return { fg = colors and colors[2] and colors[2] or "#ff0000" }
            -- end,
            provider = function(self)
                -- first, trim the pattern relative to the current directory. For other
                -- options, see :h filename-modifers
                self.filename = vim.api.nvim_buf_get_name(0)
                local filename = vim.fn.fnamemodify(self.filename, ":t")
                local is_oil = string.find(self.filename, "oil")
                if filename == "" and is_oil == -1 then
                    return "[No Name]"
                end
                if is_oil then
                    return vim.fn.fnamemodify(string.gsub(self.filename, [[oil://]], ""), ":~")
                end
                return filename
            end,

            {
            -- File Info {{{

                condition = function()
                    return not conditions.buffer_matches({
                        buftype = { "nofile", "prompt", "help", "quickfix" },
                        filetype = { "^git.*", "fugitive", "oil" },
                    })
                end,

                -- File name
                {
                -- Readonly {{{
                    condition = function()
                        return vim.api.nvim_buf_get_option(0, "readonly")
                    end,
                    provider = get_icon("FileReadOnly"),
                    update = { "OptionSet", pattern = "readonly" },
                }, -- }}}

                {
                -- Modified {{{
                    condition = function()
                        return vim.api.nvim_buf_get_option(0, "modified")
                    end,
                    provider = get_icon("FileModified"),
                    update = "BufModifiedSet",
                }, -- }}}
            }, -- }}}
        },
        space,
        -- }}}

        -- MIDDLE {{{
        ALIGN,
        -- }}}

        -- RIGHT {{{
        {
            condition = conditions.lsp_attached,
            update = { "LspAttach", "LspDetach" },

            -- You can keep it simple,
            -- provider = " [LSP]",

            -- Or complicate things a bit and get the servers names
            provider = function()
                local names = {}
                for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                    if server.name == "null-ls" then
                        for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
                            for _, source in ipairs(null_ls_sources(vim.bo.filetype, type)) do
                                table.insert(names, source)
                            end
                        end
                    else
                        table.insert(names, server.name)
                    end
                end
                return "[" .. table.concat(names, " ") .. "]"
            end,
            hl = { fg = CYAN, bold = true },
            space,
        },
        {
            provider = function()
                local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
                return enc ~= "utf-8" and enc:upper()
            end,
        },

        -- Column Number
        {
            hl = { fg = WHITE, bold = true },
            provider = " %p%% %v:%l ",
        },

        {
            hl = { fg = WHITE, bold = true },
            provider = function()
                return os.date("H %R")
            end,
        },
        -- }}}
    },
})
