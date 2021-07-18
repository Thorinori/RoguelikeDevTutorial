require('modules.World.Rooms.Components.Wall')

function TestRoom()
    local thickness = 10
    local room = {
        name = 'Test Room',
        walls = {
            left = Wall(0, 0, thickness, globals.win_height, thickness),
            top = Wall(0, 0, globals.win_width,  thickness, thickness),
            right = Wall(globals.win_width-thickness, thickness, thickness, globals.win_height, thickness),
            bottom = Wall(2, globals.win_height-thickness, globals.win_width, thickness, thickness)
        },
        hazards = {},
        exits = {},
        start_point = {
            x = 100,
            y = 100
        }
    }


    room.update = function()

    end
    
    room.draw = function()
        for _,v in pairs(room.walls) do
            v.draw()
        end
    end

    room.update_offsets = function()
        room.walls.left = Wall(0, 0, thickness, globals.win_height)
        room.walls.top = Wall(0, 0, globals.win_width,  thickness)
        room.walls.right = Wall(globals.win_width-thickness, thickness, thickness, globals.win_height-(2 * thickness))
        room.walls.bottom = Wall(2, globals.win_height-thickness, globals.win_width, thickness)
    end

    return room
end