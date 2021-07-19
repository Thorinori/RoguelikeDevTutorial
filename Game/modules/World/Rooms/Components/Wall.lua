function Wall(center_x, center_y, width, height, offset)
    local wall = {
        name = 'wall',
        origin_x = center_x,
        origin_y = center_y,
        width = width,
        height = height,
        offset = offset
    }

    wall.body = love.physics.newBody(
        globals.world,
        wall.origin_x,
        wall.origin_y,
        "static"
    )
    wall.shape = love.physics.newRectangleShape(
        wall.width,
        wall.height
    )

    wall.fixture = love.physics.newFixture(wall.body, wall.shape)

    wall.fixture:setCategory(globals.collision_categories.WALL)
    wall.fixture:setUserData('Wall') --Tag for collision checking

    wall.draw = function()
        love.graphics.setColor(globals.colors.blue)
        love.graphics.polygon(
            "fill",
            wall.body:getWorldPoints(
                wall.shape:getPoints()
            )
        )
        love.graphics.setColor(globals.colors.default)
    end

    return wall
end