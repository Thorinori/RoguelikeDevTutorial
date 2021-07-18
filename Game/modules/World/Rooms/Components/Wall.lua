function Wall(x1, y1, x2, y2, thickness)
    local wall = {
        name = 'wall',
        x1 = NormalizeToWindowWidth(x1),
        y1 = NormalizeToWindowHeight(y1),
        x2 = NormalizeToWindowWidth(x2),
        y2 = NormalizeToWindowHeight(y2),
        thickness = thickness,
    }

    wall.collide = function(trigger)
        local x1 = trigger.x
        local y1 = trigger.y
        local w1 = trigger.border_offset_width
        local h1 = trigger.border_offset_height

        local x2 = wall.x1
        local y2 = wall.y1
        local w2 = wall.x2 - wall.x1
        local h2 = wall.y2 - wall.y1

        return x1 < x2+w2 and
            x2 < x1+w1 and
            y1 < y2+h2 and
            y2 < y1+h1
    end

    wall.draw = function()
        love.graphics.setColor(globals.colors.blue)
        love.graphics.rectangle(
            'fill', 
            wall.x1 * globals.win_width,
            wall.y1 * globals.win_height,
            wall.x2 * globals.win_width,
            wall.y2 * globals.win_height
        )
        love.graphics.setColor(globals.colors.default)
    end

    return wall
end