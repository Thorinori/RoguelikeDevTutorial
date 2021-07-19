function Floor(width, height)
    local floor = {
        name = 'floor',
        width = width,
        height = height,
        friction = 1.0
    }

    floor.body = love.physics.newBody(
        globals.world,
        floor.width/2,
        floor.height/2,
        "static"
    )
    floor.shape = love.physics.newRectangleShape(
        floor.width,
        floor.height
    )

    floor.fixture = love.physics.newFixture(floor.body, floor.shape)

    floor.fixture:setCategory(globals.collision_categories.WALL)
    floor.fixture:setUserData('Floor') --Tag for collision checking

    return floor
end