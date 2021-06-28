--Function for Player Input that isn't handled by the normal callbacks currently. May move later
function checkInput(this,dt)
    local kb_down = love.keyboard.isDown
    local mouse_down = love.mouse.isDown --1 is left, 2 is right, 3 is middle click
    local shift_val = .2
    local diagonal_val = math.sqrt((math.pow(shift_val,2))/2)
    globals.fire_rate = 10 --Shots per second, needed for firing testing function currently

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
        if(globals.fire_timer) then
            if (globals.fire_timer > 0) then
                globals.fire_timer = globals.fire_timer - dt
            else
                fire()
                globals.fire_timer = 1/globals.fire_rate
            end
        else
            fire()
            globals.fire_timer = 1/globals.fire_rate
        end
    end
end

--Testing function
function fire()
    globals.temp_objects.pushright(globals.temp_objects,CreateProj('x',globals.perm_objects.Player.x_offset,globals.perm_objects.Player.y_offset,globals.next_id,.3))
    globals.next_id = globals.next_id + 1
    globals.object_count = globals.object_count + 1
end

--Handle Love Callbacks

function love.keypressed(key, unicode)
    if key == 'escape' then
        love.window.close()
    end
    if key == 'p' then
        if(globals.game_state == 'play') then
            globals.game_state = 'paused'
        else
            globals.game_state = 'play'
        end
    end
end

function love.keyreleased(key, unicode)

end


function love.mousepressed(x, y, button, istouch, presses)

end


function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        globals.fire_timer = nil
    end
end--