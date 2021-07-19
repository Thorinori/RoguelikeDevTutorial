function CreateEntity(name, size, x, y, id, font_choice)
    local font_choice = font_choice or globals.default_fonts.love_default
    local font = love.graphics.newFont(font_choice,size, "normal", love.graphics.getDPIScale())
    local entity = {
        name= name or "Quack",
        size = size,
        text = love.graphics.newText(font, name or "Quack"),
        x = x,
        y = y,
        id = id,
    }

    entity.center_x = entity.text:getWidth()/2
    entity.center_y = entity.text:getHeight()/2
    
    entity.width = entity.text:getWidth()
    entity.height =  entity.text:getHeight()

    entity.update_offsets = function()
        entity.width = entity.text:getWidth()
        entity.height =  entity.text:getHeight()
        entity.center_x = entity.text:getWidth()/2
        entity.center_y = entity.text:getHeight()/2
    end

    entity.change_size = function(new_size)
        font = love.graphics.newFont(globals.default_fonts.player,new_size, "normal", love.graphics.getDPIScale())
        entity.text = love.graphics.newText(font, entity.name)
        entity.size = new_size

        entity.update_offsets()
    end

    return entity
end