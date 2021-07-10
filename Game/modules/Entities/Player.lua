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

    player.FireProj = function(mouse_x, mouse_y, speed)
        local proj_size = 20
        local start_x = globals.perm_objects.Player.x_offset + globals.perm_objects.Player.border_offset_width/2
        local start_y = globals.perm_objects.Player.y_offset + globals.perm_objects.Player.border_offset_height/2
        local font_choice = globals.default_fonts.love_default

        DefaultShot(mouse_x, mouse_y, start_x, start_y, speed, proj_size, font_choice)
        --Check Upgrades
        if(globals.perm_objects.Player.obtained_upgrades.multishot) then
            Multishot(mouse_x, mouse_y, start_x, start_y, speed, proj_size, font_choice)
        end
    end

    player.update = function (this, dt)

        --Handle Inputs for the frame
        CheckInput(this,dt)

        local mouse_x, mouse_y = love.mouse.getPosition()
        this.update_rotation(mouse_x,mouse_y)

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

    player.draw = function ()
        local mouse_x, mouse_y = love.mouse.getPosition()
        love.graphics.draw(
            player.text,
            globals.win_width * player.x_offset + player.center_x, --Moves relative to window size in both dimensions
            globals.win_height * player.y_offset + player.center_y,
            player.rotation,
            2,
            2,
            player.x_offset + player.center_x,
            player.y_offset + player.center_y
        )
        love.graphics.line(
            player.x_offset * globals.win_width + player.center_x,
            player.y_offset * globals.win_height + player.center_y ,
            mouse_x,
            mouse_y
        )
    end

    return player
end