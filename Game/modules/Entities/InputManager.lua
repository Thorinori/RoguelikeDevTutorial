require('modules.Entities.Projectile')

--Function for Player Input that isn't handled by the normal callbacks currently. May move later
function CheckInput(this,dt)
    local kb_down = love.keyboard.isDown
    local mouse_down = love.mouse.isDown --1 is left, 2 is right, 3 is middle click
    local shift_val = .2
    local diagonal_val = math.sqrt(math.pow(shift_val,2)/2)
    local proj_speed = .3
    globals.fire_rate = 10 --Shots per second, needed for firing testing function currently

    --Check diagonal inputs first since they have most requirements then check single directions
    if kb_down('d') and kb_down('w') then
        this.x_offset = this.x_offset + (diagonal_val * dt)
        this.y_offset = this.y_offset - (diagonal_val * dt)

    elseif kb_down('d') and kb_down('s') then
        this.x_offset = this.x_offset + (diagonal_val * dt)
        this.y_offset = this.y_offset + (diagonal_val * dt)

    elseif kb_down('a') and kb_down('w') then
        this.x_offset = this.x_offset - (diagonal_val * dt)
        this.y_offset = this.y_offset - (diagonal_val * dt)

    elseif kb_down('a') and kb_down('s') then
        this.x_offset = this.x_offset - (diagonal_val * dt)
        this.y_offset = this.y_offset + (diagonal_val * dt)

    elseif kb_down('d') then
        this.x_offset = this.x_offset + (shift_val * dt)

    elseif kb_down('a') then
        this.x_offset = this.x_offset - (shift_val * dt)

    elseif kb_down('w') then
        this.y_offset = this.y_offset - (shift_val * dt)

    elseif kb_down('s') then
        this.y_offset = this.y_offset + (shift_val * dt)
    end

    if mouse_down('1') then
        local x_pos, y_pos = love.mouse.getPosition()
        if(globals.fire_timer) then
            if (globals.fire_timer > 0) then
                globals.fire_timer = globals.fire_timer - dt
            else
                FireProj(x_pos, y_pos, proj_speed)
                globals.fire_timer = 1/globals.fire_rate
            end
        else
            FireProj(x_pos, y_pos, proj_speed)
            globals.fire_timer = 1/globals.fire_rate
        end
    end
end

--Testing function
function FireProj(mouse_x, mouse_y, speed)
    local speed = speed or love.math.random()
    local proj_char = 'x'
    globals.temp_objects.bullets[globals.next_id] = CreateProj(globals.perm_objects.Player,
        proj_char,globals.perm_objects.Player.x_offset,
        globals.perm_objects.Player.y_offset,
        globals.next_id,
        speed,
        mouse_x,
        mouse_y
    )
    globals.next_id = globals.next_id + 1
    if(debug) then
        debug_globals.current_object_count = debug_globals.current_object_count + 1
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

        if(debug) then
            if key == '\\' then
                if(debug_globals.show_debug == true) then
                    debug_globals.show_debug = false
                else
                    debug_globals.show_debug = true
                end
            end
        end
        --Keys that should work only when game is in play
        if(globals.game_state == 'play') then
            if key == ']' then
                globals.fire_rate = globals.fire_rate + 1
            end
            if key == '[' then
                globals.fire_rate = globals.fire_rate - 1
            end
        end
    end
end

function love.keyreleased(key, unicode)
    --[[if(love.window.hasFocus()) then
        --Inputs that only work while game is in play
        if(globals.game_state == 'play') then

        end
    end]]
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