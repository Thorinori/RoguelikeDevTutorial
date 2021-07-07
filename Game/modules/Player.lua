--Includes
require('modules.Entity')
require('modules.InputManager')

function CreatePlayer(name, x, y,id)
    --Make a Player out of Entity Base Type
    local player = CreateEntity(name or globals.default_chars.player,x,y,id)

    player.update = function (this, dt)

        --Handle Inputs for the frame
        CheckInput(this,dt)

        --Location Bounds Enforcement
        if(this.x_offset >= globals.max_offset-this.border_offset_width) then
            this.x_offset = globals.max_offset - this.border_offset_width
        end
        if(this.y_offset >= globals.max_offset-this.border_offset_height) then
            this.y_offset = globals.max_offset - this.border_offset_height
        end
        if(this.x_offset < globals.min_offset) then
            this.x_offset = globals.min_offset
        end
        if(this.y_offset < globals.min_offset) then
            this.y_offset = globals.min_offset
        end
    end

    player.draw = function (this)
        love.graphics.draw(this.text, 
        globals.win_width * this.x_offset, 
        globals.win_height * this.y_offset) --Moves relative to window size in both dimensions
    end

    return player
end