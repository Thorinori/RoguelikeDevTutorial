function CreateWindow(name, mode, x, y, width, height, id)
    local Window = {
        name = name or 'Generic Window',
        mode = mode or 'fill',
        x_offset = NormalizeToWindowWidth(x),
        y_offset = NormalizeToWindowHeight(y),
        width = width,
        height = height,
        id = id
    }

    Window.update_offsets = function()

    end

    return Window
end