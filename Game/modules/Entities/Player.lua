--Includes
require('modules.Entities.InputManager')
require('modules.Entities.Entity')
require('modules.Upgrades.UpgradeList')

function CreatePlayer(name, size, x, y,id,color, font_choice)
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
    player. rotation = 0
    
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
            player.y  * globals.win_height+ player.center_x,
            mouse_x,
            player.x  * globals.win_width + player.center_y
        ) + CONSTANTS.PI/2 --Rotates so top of character is the "front"
    end

    player.update = function (dt)

        --Handle Inputs for the frame
        CheckInput(dt)

        local mouse_x, mouse_y = love.mouse.getPosition()
        player.update_rotation(mouse_x,mouse_y)

        --Location Bounds Enforcement for entire screen
        if(player.x >= globals.max_bound - player.border_offset_width) then
            player.x = globals.max_bound - player.border_offset_width
        end
        if(player.y >= globals.max_bound - player.border_offset_height) then
            player.y = globals.max_bound - player.border_offset_height
        end
        if(player.x< globals.min_bound ) then
            player.x = globals.min_bound
        end
        if(player.y < globals.min_bound) then
            player.y = globals.min_bound
        end

    end

    player.draw = function ()
        love.graphics.draw(
            player.text,
            player.x * globals.win_width + (player.center_x * globals.win_width), --Moves relative to window size in both dimensions
            player.y * globals.win_height+ (player.center_y * globals.win_width),
            player.rotation,
            2,
            2,
            player.x + player.center_x * globals.win_width,
            player.y + player.center_y * globals.win_height
        )
    end

    return player
end