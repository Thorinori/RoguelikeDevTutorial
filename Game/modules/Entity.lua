function CreateEntity(name,x,y,id)
    local entity = {
        name= name or "Quack",
        text = love.graphics.newText(love.graphics.getFont(), name or "Quack"),
        x_offset = x or love.math.random(), --These are both proportions of screen (Like .5 of the width) so everything scales to window size
        y_offset = y or love.math.random(),
        id = id
    }

    entity.border_offset_width = entity.text:getWidth()/globals.win_width
    entity.border_offset_height = entity.text:getHeight()/globals.win_height
    return entity
end