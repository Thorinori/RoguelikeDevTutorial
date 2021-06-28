function CreatePlayer(name, x, y,id)
    local player = {}
    player.name= name or "Quack"
    player.x_offset = x or love.math.random()
    player.y_offset = y or love.math.random()
    player.id = id
    
    player.update  = function (self, dt)
        if(self.x_offset > globals.max_offset) then
            self.x_offset = globals.min_offset
        end
        if(self.y_offset > globals.max_offset) then
            self.y_offset = globals.min_offset
        end
        if(self.x_offset < globals.min_offset) then
            self.x_offset = globals.max_offset
        end
        if(self.y_offset < globals.min_offset) then
            self.y_offset = globals.max_offset
        end

        checkInput(self,dt)
    end

    player.draw = function (self)
        love.graphics.print(self.name, 
            globals.win_width * self.x_offset, 
            globals.win_height * self.y_offset) --Moves relative to screen size in both dimensions
    end

    return player
end