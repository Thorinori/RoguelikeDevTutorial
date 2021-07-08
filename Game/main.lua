--Includes
require('libs.json')
require('modules.General.DataStructures')
require('modules.General.TableFunctions')
require('modules.General.Colors')
require('modules.Entities.Player')

--LOVE Functions
function love.load()
    --Setup Random Number Generator
    local seed_val = love.timer.getTime()
    love.math.setRandomSeed(seed_val)

    --Basic Window Setup
    love.window.setTitle('The Quaackening')
    love.window.setMode(800,600,{resizable = true, minwidth = 800, minheight = 600})
    love.keyboard.setKeyRepeat(true)

    --Table to store globals
    globals = {
        win_width = love.graphics.getWidth(),
        win_height = love.graphics.getHeight(),
        game_state = 'play',
        max_offset = 1,
        min_offset = 0,
        default_chars = {
            player = '@',
            proj = 'x'
        },
        perm_objects = {},
        temp_objects = {
            bullets = {},
            enemies = {}
        },
        next_id = 2,
        colors = Colors(),
        fire_rate = 10
    }

    love.graphics.setBackgroundColor(globals.colors.black)

    --Debug variables
    debug = true --Preferably only global not in a table
    if(debug) then
        debug_globals = {
            current_dt = 0,
            show_debug = true,
            current_object_count = 1
        }
    end

    --Generate Player once ready
    globals.perm_objects.Player = CreatePlayer(
        '@',
        42,
        love.math.random(),
        love.math.random(),
        1
    )


end

function love.update(dt)
    --Only update when window is focused and game is in play mode
    if(love.window.hasFocus() and globals.game_state ~= 'paused') then

        --Do updates for all permanent objects
        for _,i in pairs(globals.perm_objects) do
            i.update(i,dt)
        end

        --Iterates through all categories of temporary objects, then iterates over non-function members of those categories
        for _,v in pairs(globals.temp_objects) do
            if(type(v) == "table") then
                for k,i in pairs(v) do
                    if type(k) =="number" then
                        i.update(i,dt)
                    end
                end
            end
        end

        --Debug Updates
        if(debug) then
            debug_globals.current_dt = dt
            debug_globals.current_mem_usage = collectgarbage('count')
            debug_globals.mouse_x_pos, debug_globals.mouse_y_pos = love.mouse.getPosition()
        end
    end
end

function love.draw()
    --Debug "prints" basically
    if(debug) then
        if(debug_globals.show_debug) then
        local debug_string = 'Position: (X: '..string.format('%.4f',globals.perm_objects.Player.x_offset * globals.win_width)..
            ' Y: '.. string.format('%.4f',globals.perm_objects.Player.y_offset * globals.win_height)..')'..
            '\nMouse Position: (X: '..string.format('%.4f',debug_globals.mouse_x_pos)..' Y: '.. string.format('%.4f',debug_globals.mouse_y_pos)..')'..
            '\ndT: '..string.format('%.4f',debug_globals.current_dt)..
            '\nFPS: '..string.format('%.0f', love.timer.getFPS())..
            '\nObjects Made: '..globals.next_id..
            '\nCurrent Objects: '..debug_globals.current_object_count..
            '\nCurrent Memory Usage: ' .. string.format('%.2f', math.floor(debug_globals.current_mem_usage/1024)) .. 'MB, '.. string.format('%.2f',debug_globals.current_mem_usage%1024) ..' KB'..
            '\nText Width: ' .. globals.perm_objects.Player.border_offset_width..
            '\nText Height: ' .. globals.perm_objects.Player.border_offset_height..
            '\nFire Rate: '..globals.fire_rate..' shots/sec'..
            '\nFire Timer: '.. string.format('%.4f',globals.fire_timer or 0) ..' seconds'..
            '\nMultishot Enabled: '.. tostring(globals.perm_objects.Player.obtained_upgrades.multishot)

            love.graphics.print(debug_string,10,10)
        end
    end

    for _,i in pairs(globals.perm_objects) do
        i.draw(i)
    end

        --Iterates through all categories of temporary objects, then iterates over non-function members of those categories
    for _,v in pairs(globals.temp_objects) do
        if(type(v) == "table") then
            for k,i in pairs(v) do
                if type(k) =="number" then
                    i.draw(i)
                end
            end
        end
    end
end

function love.resize(w, h)
    globals.win_width = w
    globals.win_height = h

    for _,i in pairs(globals.perm_objects) do
        i.update_offsets()
    end

    --Iterates through all categories of temporary objects, then iterates over non-function members of those categories (Allows for Special Data Structures)
    for _,v in pairs(globals.temp_objects) do
        if(type(v) == "table") then
            for k,i in pairs(v) do
                if type(k) =="number" then
                    i.update_offsets()
                end
            end
        end
    end

end