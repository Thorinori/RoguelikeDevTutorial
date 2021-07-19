require('modules.Entities.Projectile')
require('modules.Upgrades.Multishot')
require('modules.Upgrades.DefaultShot')

if(debug) then
    require('modules.UI.DebugMenu')
    require('modules.UI.Grid')
end

--Function for Player Input that isn't handled by the normal callbacks currently. May move later
function CheckInput(dt)
    local player = globals.Player
    local kb_down = love.keyboard.isDown
    local mouse_down = love.mouse.isDown --1 is left, 2 is right, 3 is middle click
    local shift_val = 150
    local diagonal_val = math.sqrt(math.pow(shift_val,2)/2)
    local proj_speed = 200

    local old_x = player.x
    local old_y = player.y

    local top_wall = globals.current_room.walls.top
    local bottom_wall = globals.current_room.walls.bottom
    local left_wall = globals.current_room.walls.left
    local right_wall = globals.current_room.walls.right

    --Check diagonal inputs first since they have most requirements then check single directions
    if kb_down('d') and kb_down('w') then

        player.body:setX(player.body:getX() + (diagonal_val * dt))
        player.body:setY(player.body:getY() - (diagonal_val * dt))

    elseif kb_down('d') and kb_down('s') then

        player.body:setX(player.body:getX() + (diagonal_val * dt))
        player.body:setY(player.body:getY() + (diagonal_val * dt))

    elseif kb_down('a') and kb_down('w') then

        player.body:setX(player.body:getX() - (diagonal_val * dt))
        player.body:setY(player.body:getY() - (diagonal_val * dt))

    elseif kb_down('a') and kb_down('s') then

        player.body:setX(player.body:getX() - (diagonal_val * dt))
        player.body:setY(player.body:getY() + (diagonal_val * dt))

    elseif kb_down('d') then

        player.body:setX(player.body:getX() + (shift_val * dt))

    elseif kb_down('a') then

        player.body:setX(player.body:getX() - (shift_val * dt))

    elseif kb_down('w') then

        player.body:setY(player.body:getY() - (shift_val * dt))

    elseif kb_down('s') then

        player.body:setY(player.body:getY() + (shift_val * dt))

    end

    if mouse_down('1') then
        local x_pos, y_pos = love.mouse.getPosition() --Main Projectile Target
        if(globals.fire_timer) then --If I can fire now
            if (globals.fire_timer > 0) then
                globals.fire_timer = globals.fire_timer - dt
            else
                player.FireProj(x_pos, y_pos, proj_speed)
                globals.fire_timer = 1/globals.fire_rate
            end
        else
            player.FireProj(x_pos, y_pos, proj_speed)
            globals.fire_timer = 1/globals.fire_rate
        end
    end
end

--Handle Love Callbacks
function love.keypressed(key, unicode)
    --Makes sure everything only works while game has focus
    if(love.window.hasFocus()) then
        if key == 'escape' then
            love.window.close()
        end

        if key == 'p' then
            if(globals.game_state == 'play') then
                globals.game_state = 'paused'
            else
                globals.game_state = 'play'
                globals.fire_timer = 0
            end
        end

        if key == 'l' then
            if(globals.game_state == 'loading') then
                globals.game_state = 'play'
            else
                globals.game_state = 'loading'
            end
        end

        if key == 'v' then
            if(love.window.getVSync() == 1) then
                love.window.setVSync(0)
            else
                love.window.setVSync(1)
            end
        end

        if key == 'x' then
            for k,v in pairs(globals.temp_objects.bullets) do
                if(type(k) == 'number' and v.getSource() == globals.perm_objects.Player) then
                    v.delete()
                end
            end
        end

        if(debug) then
            if key == '\\' then
                if(debug_globals.show_debug) then
                    debug_globals.show_debug = false
                else
                    debug_globals.show_debug = true
                    globals.temp_objects.menus[globals.next_id] = OpenDebugMenu(globals.next_id)
                    globals.next_id = globals.next_id + 1
                    debug_globals.current_object_count = debug_globals.current_object_count + 1
                end
            end
            if key == 'g' then
                if(debug_globals.Grid.visible) then
                    debug_globals.Grid.visible = false
                else
                    debug_globals.Grid.visible = true
                end
            end
            if key == ']' and love.keyboard.isDown('lshift') then
                globals.Player.change_size(globals.Player.size + 1)
            end
            if key == '[' and love.keyboard.isDown('lshift')then
                globals.Player.change_size(globals.Player.size - 1)
            end
            if key == ']' and not love.keyboard.isDown('lshift') then
                globals.fire_rate = globals.fire_rate + 1
            end
            if key == '[' and not love.keyboard.isDown('lshift') then
                globals.fire_rate = globals.fire_rate - 1
            end
            if key == '1' then
                if(globals.Player.obtained_upgrades['multishot']) then
                    globals.Player.obtained_upgrades['multishot'] = false
                else
                    globals.Player.obtained_upgrades['multishot'] = true
                end
            end
        end
        --Keys that should work only when game is in play
        if(globals.game_state == 'play') then

        end
    end
end

function love.keyreleased(key, unicode)
    if(love.window.hasFocus()) then
        --Inputs that only work while game is in play
        if(globals.game_state == 'play') then

        end
    end
end


function love.mousepressed(x, y, button, istouch, presses)
    --[[if(love.window.hasFocus()) then
        --Inputs that only work while game is in play
    end]]
end


function love.mousereleased(x, y, button, istouch, presses)
    --Makes sure everything only works while game has focus
    if(love.window.hasFocus()) then
        --Inputs that only work while game is in play
        if(globals.game_state == 'play') then
            --Resets fire rate limiter on release to allow automatic or semi-automatic options
            if button == 1 then
                globals.fire_timer = nil
            end
        end
    end
end--