--Includes
require('modules.InputManager')
require('modules.Player')
require('modules.TableFunctions')
require('modules.Proj')
require('modules.DataStructures')




--Function Aliases
tInsert = table.insert

--LOVE Functions
function love.load()
    --Setup Random Number Generator
    seed_val = love.timer.getTime()
    love.math.setRandomSeed(seed_val)

    --Table to store globals since I don't like globals
    globals = {}
    globals.perm_objects = {}
    globals.temp_objects = CreateQueue()
    globals.object_count = 1
    globals.game_state = 'play'

    --Basic Window Setupa
    love.window.setTitle('The Quackening')
    love.window.setMode(800,600,{resizable = true, minwidth = 800, minheight = 600})

    --Values for positioning to keep everything scaled and in visible bounds
    globals.max_offset = 1.01
    globals.min_offset = -.05

    --Stores Current Window Dimensions
    globals.win_width = love.graphics.getWidth()
    globals.win_height = love.graphics.getHeight()
    
    globals.perm_objects.Player = CreatePlayer("Quack", love.math.random(), love.math.random(), 1)
    globals.next_id = 1
    
    --Debug variables
    debug = true --Preferably only global not in a table
    if(debug) then
        debug_globals = {}
        debug_globals.current_dt = 0
    end
end

function love.update(dt)
    if(love.window.hasFocus() and globals.game_state ~= 'paused') then
        for k,i in pairs(globals.perm_objects) do
            i.update(i,dt)
        end

        --Iterates over Queue, if statement causes only operating on the contained objects instead of the functions too
        for k,i in pairs(globals.temp_objects) do
            if type(k) =="number" then
                i.update(i,dt)
            end
        end
        --Debug Updates
        if(debug) then
            debug_globals.current_dt = dt
        end
    end
end

function love.draw()
    if(debug) then
        local debug_string = 'X: '..globals.perm_objects.Player.x_offset..
        '\nY: '..globals.perm_objects.Player.y_offset..
        '\ndT: '..debug_globals.current_dt..
        '\nObjects Made: '..globals.next_id..
        '\nCurrent Objects: '..globals.object_count


        love.graphics.print(debug_string,10,10)
    end

    for k,i in pairs(globals.perm_objects) do
        i.draw(i)
    end

    --Iterates over Queue, if statement causes only operating on the contained objects instead of the functions too
    for k,i in pairs(globals.temp_objects) do
        if type(k) =="number" then
            i.draw(i)
        end
    end
end

function love.resize(w, h)
    globals.win_width = w
    globals.win_height = h
end