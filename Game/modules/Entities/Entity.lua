function CreateEntity(name, size, x, y, id)
    local font = love.graphics.newFont(size, "normal", love.graphics.getDPIScale())
    local entity = {
        name= name or "Quack",
        size = size,
        text = love.graphics.newText(font, name or "Quack"),
        x_offset = x or love.math.random(), --These are both proportions of screen (Like .5 of the width) so everything scales to window size
        y_offset = y or love.math.random(),
        id = id
    }

    entity.border_offset_width = NormalizeToWindowWidth(entity.text:getWidth())
    entity.border_offset_height = NormalizeToWindowHeight(entity.text:getHeight())

    entity.update_offsets = function()
        entity.border_offset_width = NormalizeToWindowWidth(entity.text:getWidth())
        entity.border_offset_height = NormalizeToWindowHeight(entity.text:getHeight())
    end

    entity.change_size = function(new_size)
        font = love.graphics.newFont(new_size, "normal", love.graphics.getDPIScale())
        entity.text = love.graphics.newText(font, entity.name)
        entity.size = new_size

        entity.update_offsets()
    end

    return entity
end