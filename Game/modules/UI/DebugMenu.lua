require('modules.UI.MenuWindow')

local function VSyncStatus()
    if(love.window.getVSync() == 1)then
        return 'On'
    else
        return 'Off'
    end
end

local function update_debug_string()
    local debug_string = 
    'Position: (X: '..string.format('%.4f',globals.perm_objects.Player.x_offset * globals.win_width)..
    ' Y: '.. string.format('%.4f',globals.perm_objects.Player.y_offset * globals.win_height)..')'..
    '\nMouse Position: ('..string.format('%.4f',debug_globals.mouse_x_pos)..', '.. string.format('%.4f',debug_globals.mouse_y_pos)..')'..
    '\nVSync: ' .. VSyncStatus()..
    '\ndT: '..string.format('%.4f',debug_globals.current_dt)..
    '\nFPS: '..string.format('%.0f', love.timer.getFPS())..
    '\nObjects Made: '..tostring(globals.next_id - 1)..
    '\nCurrent Objects: '..debug_globals.current_object_count..
    '\nCurrent Memory Usage: ' .. string.format('%.2f', debug_globals.current_mem_usage/1024.0) .. 'MB'..
    '\nFire Rate: '..globals.fire_rate..' shots/sec'..
    '\nMultishot Enabled: '.. tostring(globals.perm_objects.Player.obtained_upgrades.multishot)..
    ''

    return debug_string
end

function OpenDebugMenu(id)
    local debug_string = love.graphics.newText(love.graphics.getFont(), update_debug_string())

    local DebugMenu = CreateWindow(
        'Debug Menu',
        'fill',
        10,
        10,
        debug_string:getWidth(),
        debug_string:getHeight(),
        id
    )

    DebugMenu.update = function ()
        if(not debug_globals.show_debug) then
            debug_globals.current_object_count = debug_globals.current_object_count - 1
            globals.temp_objects.menus[DebugMenu.id] = nil
        end
    end

    DebugMenu.draw = function ()
        if(debug) then
            if(debug_globals.show_debug) then
                debug_string = love.graphics.newText(love.graphics.getFont(), update_debug_string())

                if(debug_string:getWidth() > DebugMenu.width) then
                    DebugMenu.width = debug_string:getWidth()
                end

                if(debug_string:getHeight() > DebugMenu.height) then
                    DebugMenu.height = debug_string:getHeight()
                end

                love.graphics.setColor(ChangeAlpha(globals.colors.red,.35))
                love.graphics.rectangle(
                    DebugMenu.mode,
                    DebugMenu.x_offset,
                    DebugMenu.y_offset,
                    DebugMenu.width,
                    DebugMenu.height
                )

                love.graphics.setColor(globals.colors.white)
                love.graphics.draw(debug_string,DebugMenu.x_offset,DebugMenu.y_offset)
                love.graphics.setColor(globals.colors.default)
            end
        end
    end

    return DebugMenu
end
