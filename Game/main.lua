--Includes
require('libs.json')
require('modules.General.DataStructures')
require('modules.General.TableFunctions')
require('modules.General.Colors')
require('modules.General.Constants')
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
            player = 'x',
            proj = 'o'
        },
        perm_objects = {},
        temp_objects = {
            bullets = {},
            enemies = {},
            menus = {}
        },
        next_id = 2,
        colors = Colors(),
        fire_rate = 10,
        default_fonts = {
            love_default = '/res/fonts/Vera.ttf',
            player = '/res/fonts/origa___.ttf',
        },
        cursor = '/res/cursor.png'
    }

    love.graphics.setBackgroundColor(globals.colors.black)
    love.mouse.setCursor(love.mouse.newCursor(globals.cursor, 7, 7))

    --Debug variables
    debug = true
    if(debug) then
        debug_globals = {
            current_dt = 0,
            show_debug = false,
            current_object_count = 1
        }
    end

    --Generate Player once ready
    globals.perm_objects.Player = CreatePlayer(
        'x',
        42,
        love.math.random(),
        love.math.random(),
        1,
        nil,
        globals.default_fonts.player
    )


end

function love.update(dt)
    --Only update when window is focused and game is in play mode
    if(love.window.hasFocus() and globals.game_state ~= 'paused') then
        --Necessary debug globals updated here
        if(debug) then
            debug_globals.current_dt = dt
            debug_globals.current_mem_usage = collectgarbage('count')
            debug_globals.mouse_x_pos, debug_globals.mouse_y_pos = love.mouse.getPosition()
        end

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
    end
end

function love.draw()
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