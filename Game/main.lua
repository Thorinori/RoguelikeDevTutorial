--Includes
require('modules.Player')
require('modules.TableFunctions')
require('modules.Proj')
require('modules.DataStructures')

--LOVE Functions
function love.load()
    --Setup Random Number Generator
    local seed_val = love.timer.getTime()
    love.math.setRandomSeed(seed_val)

   --Basic Window Setup
   love.window.setTitle('The Quackening')
   love.window.setMode(800,600,{resizable = true, minwidth = 800, minheight = 600})
    
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
            bullets = {}
        },
        next_id = 2,
        object_count = 1,
    }

    globals.perm_objects.Player = CreatePlayer('nerd', love.math.random(), love.math.random(), 1)

    --Debug variables
    debug = true --Preferably only global not in a table
    if(debug) then
        debug_globals = {
            current_dt = 0,
            show_debug = true,
        }
    end
end

function love.update(dt)
    if(love.window.hasFocus() and globals.game_state ~= 'paused') then
        for k,i in pairs(globals.perm_objects) do
            i.update(i,dt)
        end

        --Iterates over Queue, if statement causes only operating on the contained objects instead of the functions too
        for k,i in pairs(globals.temp_objects.bullets) do
            if type(k) =="number" then
                i.update(i,dt)
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
            '\nCurrent Objects: '..globals.object_count..
            '\nCurrent Memory Usage: ' .. string.format('%.2f', math.floor(debug_globals.current_mem_usage/1024)) .. 'MB, '.. string.format('%.2f',debug_globals.current_mem_usage%1024) ..' KB'..
            '\nText Width: ' .. globals.perm_objects.Player.border_offset_width

            love.graphics.print(debug_string,10,10)
        end
    end

    for k,i in pairs(globals.perm_objects) do
        i.draw(i)
    end

    --Iterates over all temporary objects, if statements prevent trying to draw member functions
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
end