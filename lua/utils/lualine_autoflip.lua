
return function()
local sep= package.config:sub(1, 1)
local function extract_highlight_colors(color_group, scope, default)
    color_group = type(color_group) == "string" and { color_group }
        or color_group

    for key, group in pairs(color_group) do
        local color = vim.fn.hlexists(group)

        if color ~= 0 then
            color = vim.api.nvim_get_hl_by_name(group, true)
            if color then
                if color.background ~= nil then
                    color.bg = string.format("#%06x", color.background)
                    color.background = nil
                end
                if color.foreground ~= nil then
                    color.fg = string.format("#%06x", color.foreground)
                    color.foreground = nil
                end
                if color.special ~= nil then
                    color.sp = string.format("#%06x", color.special)
                    color.special = nil
                end
                if color and scope and color[scope] then
                    return color[scope]
                end
            end
        end
    end
    return default
end
local function load_theme(theme_name)
  local retval
  local path = table.concat { 'lua/lualine/themes/', theme_name, '.lua' }
  local files = vim.api.nvim_get_runtime_file(path, true)
  if #files <= 0 then
    path = table.concat { 'lua/lualine/themes/', theme_name, '/init.lua' }
    files = vim.api.nvim_get_runtime_file(path, true)
  end
  local n_files = #files
  if n_files == 0 then
    -- No match found
    error(path .. ' Not found')
  elseif n_files == 1 then
    -- when only one is found run that and return it's return value
    retval = dofile(files[1])
  else
    -- put entries from user config path in front
    local user_config_path = vim.fn.stdpath('config')
    table.sort(files, function(a, b)
      return vim.startswith(a, user_config_path) or not vim.startswith(b, user_config_path)
    end)
    -- More then 1 found . Use the first one that isn't in lualines repo
    local lualine_repo_pattern = table.concat({ 'lualine.nvim', 'lua', 'lualine' }, sep)
    local file_found = false
    for _, file in ipairs(files) do
      if not file:find(lualine_repo_pattern) then
        retval = dofile(file)
        file_found = true
        break
      end
    end
    if not file_found then
      -- This shouldn't happen but somehow we have multiple files but they
      -- appear to be in lualines repo . Just run the first one
      retval = dofile(files[1])
    end
  end
  return retval
end


    local colors = {
        normal  = extract_highlight_colors('bg', { 'PmenuSel', 'PmenuThumb', 'TabLineSel' }, '#000000'),
        insert  = extract_highlight_colors('fg', { 'String', 'MoreMsg' }, '#000000'),
        replace = extract_highlight_colors('fg', { 'Number', 'Type' }, '#000000'),
        visual  = extract_highlight_colors('fg', { 'Special', 'Boolean', 'Constant' }, '#000000'),
        command = extract_highlight_colors('fg', { 'Identifier' }, '#000000'),
        back1   = extract_highlight_colors('bg', { 'StatusLine' }, '#000000'),
        fore    = extract_highlight_colors('fg', { 'Normal', 'StatusLine' }, '#000000'),
        back2   = extract_highlight_colors('bg', { 'StatusLine' }, '#000000'),
    }

    local function rgb_str2num(rgb_color_str)
        if rgb_color_str:find("#") == 1 then
            rgb_color_str = rgb_color_str:sub(2, #rgb_color_str)
        end
        local red = tonumber(rgb_color_str:sub(1, 2), 16)
        local green = tonumber(rgb_color_str:sub(3, 4), 16)
        local blue = tonumber(rgb_color_str:sub(5, 6), 16)
        return { red = red, green = green, blue = blue }
    end
    --Function returns true if color should be black for maximum contrast
    local function checkColor(color)
        return (color.red * 0.299 + color.green * 0.587 + color.blue * 0.114) > 100
    end
    local color_name = vim.g.colors_name

    if color_name then
        -- All base16 colorschemes share the same theme
        if "base16" == color_name:sub(1, 6) then
            color_name = "base16"
        end

        -- Check if there's a theme for current colorscheme
        -- If there is load that instead of generating a new one
        local ok, theme = pcall(load_theme, color_name)
        if ok and theme then
            for mode, tabll in pairs(theme) do
                for sec, value in pairs(tabll) do
                    local bg = value.bg
                    if bg and bg ~= "NONE" then
                        if checkColor(rgb_str2num(bg)) then
                            value.fg = bg
                        end
                        value.bg = colors.back1
                    end
                end
            end
            return theme
        end
    end
    ---------------
    -- Constants --
    ---------------
    -- fg and bg must have this much contrast range 0 < contrast_threshold < 0.5
    local contrast_threshold = 0.3
    -- how much brightness is changed in percentage for light and dark themes
    local brightness_modifier_parameter = 10

    -- Turns #rrggbb -> { red, green, blue }

    -- Turns { red, green, blue } -> #rrggbb
    local function rgb_num2str(rgb_color_num)
        local rgb_color_str = string.format("#%02x%02x%02x", rgb_color_num.red, rgb_color_num.green, rgb_color_num.blue)
        return rgb_color_str
    end

    -- Returns brightness level of color in range 0 to 1
    -- arbitrary value it's basically an weighted average
    local function get_color_brightness(rgb_color)
        local color = rgb_str2num(rgb_color)
        local brightness = (color.red * 2 + color.green * 3 + color.blue) / 6
        return brightness / 256
    end

    -- returns average of colors in range 0 to 1
    -- used to determine contrast level
    local function get_color_avg(rgb_color)
        local color = rgb_str2num(rgb_color)
        return (color.red + color.green + color.blue) / 3 / 256
    end

    -- Clamps the val between left and right
    local function clamp(val, left, right)
        if val > right then
            return right
        end
        if val < left then
            return left
        end
        return val
    end

    -- Changes brightness of rgb_color by percentage
    local function brightness_modifier(rgb_color, percentage)
        local color = rgb_str2num(rgb_color)
        color.red = clamp(color.red + (color.red * percentage / 100), 0, 255)
        color.green = clamp(color.green + (color.green * percentage / 100), 0, 255)
        color.blue = clamp(color.blue + (color.blue * percentage / 100), 0, 255)
        return rgb_num2str(color)
    end

    -- Changes contrast of rgb_color by amount
    local function contrast_modifier(rgb_color, amount)
        local color = rgb_str2num(rgb_color)
        color.red = clamp(color.red + amount, 0, 255)
        color.green = clamp(color.green + amount, 0, 255)
        color.blue = clamp(color.blue + amount, 0, 255)
        return rgb_num2str(color)
    end

    -- Changes brightness of foreground color to achieve contrast
    -- without changing the color
    local function apply_contrast(highlight)
        local highlight_bg_avg = get_color_avg(highlight.bg)
        local contrast_threshold_config = clamp(contrast_threshold, 0, 0.5)
        local contrast_change_step = 5
        if highlight_bg_avg > 0.5 then
            contrast_change_step = -contrast_change_step
        end

        -- Don't waste too much time here max 25 iteration should be more than enough
        local iteration_count = 1
        while
            math.abs(get_color_avg(highlight.fg) - highlight_bg_avg) < contrast_threshold_config
            and iteration_count < 25
        do
            highlight.fg = contrast_modifier(highlight.fg, contrast_change_step)
            iteration_count = iteration_count + 1
        end
    end

    -- Get the colors to create theme
    -- stylua: ignore

    -- Change brightness of colors
    -- Darken if light theme (or) Lighten if dark theme
    local normal_color = extract_highlight_colors("Normal", "bg")
    if normal_color ~= nil then
        if get_color_brightness(normal_color) > 0.5 then
            brightness_modifier_parameter = -brightness_modifier_parameter
        end
        for name, color in pairs(colors) do
            colors[name] = brightness_modifier(color, brightness_modifier_parameter)
        end
    end

    -- Basic theme definition
    local M = {
        normal = {
            a = { bg = colors.back1, fg = colors.normal, gui = "bold" },
            b = { bg = colors.back1, fg = colors.normal },
            c = { bg = colors.back1, fg = colors.fore },
        },
        insert = {
            a = { bg = colors.back1, fg = colors.insert, gui = "bold" },
            b = { bg = colors.back1, fg = colors.insert },
            c = { bg = colors.back1, fg = colors.fore },
        },
        replace = {
            a = { bg = colors.back1, fg = colors.replace, gui = "bold" },
            b = { bg = colors.back1, fg = colors.replace },
            c = { bg = colors.back1, fg = colors.fore },
        },
        visual = {
            a = { bg = colors.back1, fg = colors.visual, gui = "bold" },
            b = { bg = colors.back1, fg = colors.visual },
            c = { bg = colors.back1, fg = colors.fore },
        },
        command = {
            a = { bg = colors.back1, fg = colors.command, gui = "bold" },
            b = { bg = colors.back1, fg = colors.command },
            c = { bg = colors.back1, fg = colors.fore },
        },
    }

    M.terminal = M.command
    M.inactive = M.normal

    -- Apply proper contrast so text is readable
    for _, section in pairs(M) do
        for _, highlight in pairs(section) do
            apply_contrast(highlight)
        end
    end

    return M
end
