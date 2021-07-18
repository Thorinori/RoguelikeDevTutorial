require('modules.Entities.Entity')
require('modules.General.Constants')
require('modules.General.ExtraMath')

function CreateProj(source,name, size, x, y, id, speed, dest_x, dest_y, angle, color, font_choice)
    --Position Variable sadjusted to spawn near middle of player
    local proj = CreateEntity(
        name or globals.default_chars.proj,
        size,
        x,
        y,
        id,
        font_choice
    )
    
    proj.source = source
    proj.x = proj.x - proj.border_offset_width/2 --Moves projectile spawn to look more centered
    proj.y = proj.y - proj.border_offset_width/2 --Moves projectile spawn to look more centered
    proj.speed = speed or .3
    proj.dest_x = dest_x
    proj.dest_y = dest_y
    proj.angle = angle

    proj.delete = function()
        globals.temp_objects.bullets[proj.id] = nil
        if(debug) then
            debug_globals.current_object_count = debug_globals.current_object_count - 1
        end
    end

    proj.getSource = function()
        return proj.source
    end

    local cos = math.cos
    local sin = math.sin

    proj.update  = function (dt)
        --Update Projectile location
        proj.x = proj.x + (proj.speed * cos(proj.angle) * dt)
        proj.y = proj.y + (proj.speed * sin(proj.angle) * dt)

        --Cull Projectiles for both dimensions if they pass the screen borders
        if(proj.x > globals.max_bound) or (proj.x + proj.border_offset_width < globals.min_bound) then
            proj.delete()
        end

        if(proj.y > globals.max_bound) or (proj.y + proj.border_offset_height < globals.min_bound) then
            proj.delete()
        end
    end

    proj.draw = function ()
        love.graphics.setColor(color or globals.colors.cyan)
        love.graphics.draw(
            proj.text,
            proj.x * globals.win_width,
            proj.y * globals.win_height
        )
        love.graphics.setColor(globals.colors.default)
    end

    return proj
end