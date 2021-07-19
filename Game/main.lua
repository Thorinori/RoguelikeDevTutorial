--Includes
require('libs.json')
require('modules.General.DataStructures')
require('modules.General.TableFunctions')
require('modules.General.Colors')
require('modules.General.CollisionCategories')
require('modules.General.CollisionManager')
require('modules.General.Constants')
require('modules.Entities.Player')
require('modules.World.Rooms.TestRoom')

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
        default_chars = {
            player = 'x',
            proj = 'o'
        },
        perm_objects = {},
        temp_objects = {
            bullets = {},
            enemies = {},
            menus = {},
        },
        next_id = 2,
        colors = Colors(),
        collision_categories = CollisionCategories(),
        fire_rate = 10,
        default_fonts = {
            love_default = '/res/fonts/Vera.ttf',
            player = '/res/fonts/origa___.ttf',
        },
        cursor = '/res/cursor.png',
        load_info = {},
        world = love.physics.newWorld(0,0,true)
    }

    love.graphics.setBackgroundColor(globals.colors.black)
    love.mouse.setCursor(love.mouse.newCursor(globals.cursor, 7, 7))

    --Debug variables
    debug = true
    if(debug) then
        debug_globals = {
            current_dt = 0,
            show_debug = false,
            current_object_count = 1,
            Grid = Grid(10,10, true),
        }
    end

    globals.load_info.load_font = love.graphics.newFont(
    globals.default_fonts.love_default,
    80
)

    globals.load_info.load_text = love.graphics.newText(globals.load_info.load_font, "LOADING")


    globals.world:setCallbacks(beginContact,endContact,preSolve,postSolve)


    --Generate Player once ready
    globals.Player = CreatePlayer(
        'x',
        42,
        globals.win_width/2,
        globals.win_height/2,
        1,
        nil,
        globals.default_fonts.player
    )
   
    globals.current_room = TestRoom()
end



function love.update(dt)
    --Only update when window is focused and game is in play mode
    if(love.window.hasFocus() and globals.game_state ~= 'paused') then
        
        globals.world:update(dt)

        --Do updates for all permanent objects
        for _,i in pairs(globals.perm_objects) do
            i.update(dt)
        end

        --Iterates through all categories of temporary objects, then iterates over non-function members of those categories
        for _,v in pairs(globals.temp_objects) do
            if(type(v) == "table") then
                for k,i in pairs(v) do
                    if type(k) =="number" then
                        i.update(dt)
                    end
                end
            end
        end

        globals.current_room.update(dt)

        globals.Player.update(dt)

        --Necessary debug globals updated here
        if(debug) then
            debug_globals.current_dt = dt
            debug_globals.current_mem_usage = collectgarbage('count')
            debug_globals.mouse_x_pos, debug_globals.mouse_y_pos = love.mouse.getPosition()
            debug_globals.Grid.update()
        end
    end
end

function love.draw()
    if(globals.game_state ~= 'loading') then
        for _,i in pairs(globals.perm_objects) do
            i.draw(i)
        end

        --Iterates through all categories of temporary objects besides menus, then iterates over non-function members of those categories
        for k,v in pairs(globals.temp_objects) do
            if(type(v) == "table" and k ~= 'menus') then
                for k,i in pairs(v) do
                    if type(k) =="number" then
                        i.draw(i)
                    end
                end
            end
        end

        if(debug) then
            debug_globals.Grid.draw()
        end
        
        globals.current_room.draw()

        globals.Player.draw()

        --Iterate over specifically menus since they should be on top
        for k,v in pairs(globals.temp_objects) do
            if(type(v) == "table" and k == 'menus') then
                for k,i in pairs(v) do
                    if type(k) =="number" then
                        i.draw(i)
                    end
                end
            end
        end
        
    else
        local load_text = globals.load_info.load_text
        love.graphics.draw(
            load_text,
            globals.win_width/2 - load_text:getWidth()/2,
            globals.win_height/2 - load_text:getHeight()/2
        )
    end

end

function love.resize(w, h)
    globals.win_width = w
    globals.win_height = h

    if(debug) then
        debug_globals.Grid.update_offsets()
    end

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

    globals.current_room.update_offsets()
    globals.Player.update_offsets()
end