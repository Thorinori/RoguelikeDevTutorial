function CreatePlayer(name, x, y,id)
    local text = love.graphics.newText(love.graphics.getFont(), name or "Quack")
    local player = {}
    player.name= name or "Quack"
    player.x_offset = x or love.math.random()
    player.y_offset = y or love.math.random()
    player.id = id
    player.border_offset_width = text:getWidth()/globals.win_width
    player.border_offset_height = text:getHeight()/globals.win_height
    player.update = function (this, dt)
        checkInput(this,dt)
        if(this.x_offset >= globals.max_offset-this.border_offset_width) then
            this.x_offset = globals.max_offset - this.border_offset_width
        end
        if(this.y_offset >= globals.max_offset-this.border_offset_height) then
            this.y_offset = globals.max_offset - this.border_offset_height
        end
        if(this.x_offset < globals.min_offset+this.border_offset_width/2) then
            this.x_offset = globals.min_offset + this.border_offset_width/2
        end
        if(this.y_offset < globals.min_offset+this.border_offset_height/2) then
            this.y_offset = globals.min_offset + this.border_offset_height/2
        end
    end

    player.draw = function (this)
        --[[love.graphics.newText(this.name, 
            globals.win_width * this.x_offset, 
            globals.win_height * this.y_offset) --Moves relative to screen size in both dimensions--]]
        love.graphics.draw(text, 
        globals.win_width * this.x_offset, 
        globals.win_height * this.y_offset)
    end

    return player
end