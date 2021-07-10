function CreateEntity(name, size, x, y, id, font_choice)
    local font_choice = font_choice or globals.default_fonts.love_default
    local font = love.graphics.newFont(font_choice,size, "normal", love.graphics.getDPIScale())
    local entity = {
        name= name or "Quack",
        size = size,
        text = love.graphics.newText(font, name or "Quack"),
        x_offset = x, --These are both proportions of screen (Like .5 of the width) so everything scales to window size
        y_offset = y,
        id = id,
        rotation = 0
    }

    entity.center_x = entity.text:getWidth()/2
    entity.center_y = entity.text:getHeight()/2
    
    entity.border_offset_width = NormalizeToWindowWidth(entity.text:getWidth())
    entity.border_offset_height = NormalizeToWindowHeight(entity.text:getHeight())

    entity.update_positions = function ()

    end

    entity.update_rotation = function(mouse_x, mouse_y)
        entity.rotation = GetFiringAngle(
            mouse_y,
            entity.y_offset * globals.win_height + entity.center_x,
            mouse_x,
            entity.x_offset * globals.win_width + entity.center_y
        ) + CONSTANTS.PI/2 --Rotates so top of character is the "front"

        entity.update_positions()
    end



    entity.update_offsets = function()
        entity.border_offset_width = NormalizeToWindowWidth(entity.text:getWidth())
        entity.border_offset_height = NormalizeToWindowHeight(entity.text:getHeight())
    end

    entity.change_size = function(new_size)
        font = love.graphics.newFont(globals.default_fonts.player,new_size, "normal", love.graphics.getDPIScale())
        entity.text = love.graphics.newText(font, entity.name)
        entity.size = new_size

        entity.update_offsets()
    end

    return entity
end