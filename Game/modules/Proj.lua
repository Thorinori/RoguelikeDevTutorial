function CreateProj(name, x, y,id, speed, dest_x, dest_y)
    local proj = {}
    proj.name= name or "x"
    proj.x_offset = x
    proj.y_offset = y
    proj.id = id
    proj.speed = speed or .3
    proj.dest_x = dest_x --These 2 used for figuring out where to fire towards for in update maybe
    proj.dest_y = dest_y

    proj.update  = function (this, dt)
        this.x_offset = this.x_offset + (speed * dt)
        if(this.x_offset*globals.win_width > globals.win_width + globals.max_offset) or (this.x_offset*globals.win_width < globals.min_offset) then
            globals.temp_objects.popleft(globals.temp_objects)
            globals.object_count = globals.object_count - 1

        end
        if(this.y_offset*globals.win_height > globals.win_height + globals.max_offset) or (this.y_offset*globals.win_height < globals.min_offset) then
            globals.temp_objects.popleft(globals.temp_objects)
            globals.object_count = globals.object_count - 1
        end
    end

    proj.draw = function (this)
        love.graphics.print(this.name, 
            globals.win_width * this.x_offset, 
            globals.win_height * this.y_offset) --Moves relative to screen size in both dimensions
    end

    return proj
end