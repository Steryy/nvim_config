local get_icon = require("core.utils").get_icon
local gitBranch = get_icon("GitBranch")

local function hilight(text, hl)
    return ("%%#%s#%s%%0*"):format(hl, text)
end


local filetypeFunc =
    function()
        local filetype = vim.bo.filetype or "nil"
        local icon_highlight_group
        local ok, devicons = pcall(require, 'nvim-web-devicons')
        if ok then
            _, icon_highlight_group = devicons.get_icon(vim.fn.expand('%:t'))
            if icon_highlight_group == nil then
                _, icon_highlight_group = devicons.get_icon_by_filetype(vim.bo.filetype)
            end
            if icon_highlight_group == nil then
                icon_highlight_group = 'DevIconDefault'
            end
        end
        if filetype and string.len(filetype) > 0 then
            return hilight("[" .. filetype .. "]", icon_highlight_group)
        end
    return ""
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
local z = {
    {
        padding = { left = 1, right = 0 },
        function()
            return os.date("%R ")
        end,
    },
}
local y = {

    {
        "location",
        padding = { left = 0, right = 0 },
    },
    {
        "progress",
        padding = { left = 1, right = 0 },
    },
}
local fugitive = {}
fugitive.sections = {
    lualine_a = {
        function()
            local icon = gitBranch -- e0a0
            return icon .. " " .. vim.fn.FugitiveHead()
        end,
    },
    lualine_y = y,
    lualine_z = z,
}

fugitive.filetypes = { "fugitive" }
local oil = {}


oil.sections = {
    lualine_a = {
        function()
            local filename = vim.api.nvim_buf_get_name(0)
            return vim.fn.fnamemodify(string.gsub(filename, [[oil://]], ""), ":~")
        end,
    },
    lualine_y = y,
    lualine_z = z,
}

oil.filetypes = { "oil" }

local dirbuf = {}


dirbuf.sections = {
    lualine_a = {
        function()
            local filename = vim.api.nvim_buf_get_name(0)
            return vim.fn.fnamemodify(string.gsub(filename, [[dirbuf://]], ""), ":~")
        end,
    },
    lualine_y = y,
    lualine_z = z,
}

dirbuf.filetypes = { "dirbuf" }

local gitBranchFunc =
    function()
        -- local buffer = vim.api.nvim_get_current_buf()
        local branch = nil

        if vim.g.loaded_fugitive == 1 then
            branch = vim.fn.FugitiveHead() or nil
        end
        -- buffer can be null and code will crash with:
        -- E5108: Error executing lua ... 'attempt to index a nil value'
        -- if not buffer or not (buffer.bufnr > 0) then
        --   return
        -- end
        -- fugitive is empty or not loaded, try gitsigns
        if not branch or #branch == 0 then
            local ok = vim.b.gitsigns_status_dict
            if ok and ok.head then
                branch = ok.head
            end
        end
        if branch and #branch > 0 then
            return gitBranch .. branch
        end
        return ""
    end
local gitDiffFunc = function()
    local str = ""
    local status_dict = vim.b.gitsigns_status_dict
    if status_dict then
        local added = status_dict.added or 0
        local removed = status_dict.removed or 0
        local changed = status_dict.changed or 0
        local addgroup = "diffAdded"
        local delgroup = "diffDeleted"
        local diffgroup = "diffChanged"
        if added > 0 then
            str = hilight(get_icon("GitAdd") .. " " .. added, addgroup) .. " "
        end

        if removed > 0 then
            str = str .. hilight(get_icon("GitDelete") .. " " .. removed, delgroup) .. " "
        end
        if changed > 0 then
            str = str .. hilight(get_icon("GitChange") .. " " .. changed, diffgroup) .. " "
        end
        return str
    end
    return ""
end


require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto_flip",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {

            {
                gitBranchFunc,

            },
            {
                gitDiffFunc
            },
        },
        lualine_c = {
            { filetypeFunc },
            {
                "filename",
                path = 1,
                symbols = {
                    modified = get_icon("FileModified"),
                    readonly = get_icon("FileReadOnly"),
                    -- unnamed = "[No Name]",
                    -- newfile = "[New]",
                },
            },
            {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = {
                    error = get_icon("DiagnosticError"),
                    warn = get_icon("DiagnosticWarn"),
                    info = get_icon("DiagnosticInfo"),
                    hint = get_icon("DiagnosticHint"),
                },
                -- diagnostics_color = {
                -- 	color_error = { fg = colors.red },
                -- 	color_warn = { fg = colors.yellow },
                -- 	color_info = { fg = colors.cyan },
                -- },
            },
        },
        lualine_x = {
            {
                function()
                    local names = {}
                    for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                        if #names == 3 then
                            break
                        end
                        if server.name == "null-ls" then
                            for _, type in ipairs({ "FORMATTING", "DIAGNOSTICS" }) do
                                for _, source in ipairs(null_ls_sources(vim.bo.filetype, type)) do
                                    if #names == 3 then
                                        break
                                    end
                                    table.insert(names, source)
                                end
                            end
                        else
                            table.insert(names, server.name)
                        end
                    end
                    if #names == 0 then
                        return ""
                    end
                    return "[" .. table.concat(names, " ") .. "]"
                end,
                -- color = { fg = colors.cyan },
            },

            { "encoding", fmt = string.upper },
        },
        lualine_y = y,
        lualine_z = z,
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = y,
        lualine_z = z,
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { "mundo", "lazy", fugitive, oil,
        -- dirbuf
    },
})
if vim.g.is_tmux then
    vim.opt.laststatus = 0
end
