function CreateProj(name, x, y,id, speed, dest_x, dest_y)
    local proj = {}
    proj.name= name or "x"
    proj.x_offset = x
    proj.y_offset = y
    proj.id = id
    proj.speed = speed or .3
    proj.dest_x = dest_x/globals.win_width
    proj.dest_y = dest_y/globals.win_height
    proj.angle = math.atan2((proj.dest_y - proj.y_offset), (proj.dest_x - proj.x_offset)) --Firing Angle for where projectiles go

    proj.update  = function (this, dt)
        this.x_offset = this.x_offset + (this.speed * math.cos(this.angle) * dt)
        this.y_offset = this.y_offset + (this.speed * math.sin(this.angle) * dt)

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