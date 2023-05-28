local is_color , color = pcall(require,"utils.lualine_autoflip")

if is_color then
    local colors = color()
    return colors
end
return nil
