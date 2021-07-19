--Includes
require('modules.Entities.InputManager')
require('modules.Entities.Entity')
require('modules.Upgrades.UpgradeList')

function CreatePlayer(name, size, x, y, id, color, font_choice)
    --Make a Player out of Entity Base Type
    local player = CreateEntity(
        name or globals.default_chars.player,
        size,
        x,
        y,
        id,
        font_choice
    )

    player.obtained_upgrades = GetUpgradeList()
    player.color = color
    player.rotation = 0

    --Create Physics components
    player.body = love.physics.newBody(
        globals.world,
        player.x,
        player.y,
        "dynamic"
    )

    player.shape = love.physics.newRectangleShape(
        player.width,
        player.height
    )

    player.fixture = love.physics.newFixture(player.body, player.shape, 1)

    --Configure Physics components
    player.fixture:setCategory(globals.collision_categories.PLAYER)
    player.fixture:setFriction(1)
    player.fixture:setUserData('Player') --Tag for collision checking
    
    player.FireProj = function(mouse_x, mouse_y, speed)
        local proj_size = 20
        local start_x = player.x + player.center_x
        local start_y = player.y + player.center_y
        local font_choice = globals.default_fonts.love_default

        DefaultShot(mouse_x, mouse_y, start_x, start_y, speed, proj_size, font_choice)
        --Check Upgrades
        if(player.obtained_upgrades.multishot) then
            Multishot(mouse_x, mouse_y, start_x, start_y, speed, proj_size, font_choice)
        end
    end

    player.update_rotation = function(mouse_x, mouse_y)
        player.rotation = GetFiringAngle(
            mouse_y,
            player.y + player.center_x,
            mouse_x,
            player.x + player.center_y
        ) + math.pi/2 --Rotates so top of character is the "front"

       --player.body:setAngle(-player.rotation)
    end

    player.update = function (dt)

        --Handle Inputs for the frame
        CheckInput(dt)

        player.x = player.body:getX() - player.center_x
        player.y = player.body:getY() - player.center_y

        local mouse_x, mouse_y = love.mouse.getPosition()
        player.update_rotation(mouse_x,mouse_y)


        --Location Bounds Enforcement for entire screen
        if(player.x > globals.win_width - player.width) then
            player.x = globals.win_width - player.width
            player.body:setX(globals.win_width - player.width)
        end
        if(player.y > globals.win_height - player.height) then
            player.y = globals.win_height - player.height
            player.body:setY(globals.win_height - player.height)
        end
        if(player.x < 0) then
            player.x = 0
            player.body:setX(0)
        end
        if(player.y < 0) then
            player.y = 0
            player.body:setY(0)
        end

    end

    player.draw = function ()
        -- love.graphics.draw(
        --     player.text,
        --     player.x * globals.win_width + (player.center_x * globals.win_width), --Moves relative to window size in both dimensions
        --     player.y * globals.win_height+ (player.center_y * globals.win_width),
        --     player.rotation,
        --     2,
        --     2,
        --     player.x + player.center_x * globals.win_width,
        --     player.y + player.center_y * globals.win_height
        -- )

        love.graphics.setColor(globals.colors.white)
        love.graphics.draw(
            player.text,
            player.x,
            player.y--,
            -- player.rotation,
            -- 1,
            -- 1,
            -- 0,
            -- 0
        )
        love.graphics.setColor(globals.colors.default)
    end

    return player
end