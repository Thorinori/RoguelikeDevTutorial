require('modules.World.Rooms.Components.Wall')

function TestRoom()
    local thickness = 10
    local room = {
        name = 'Test Room',
        walls = {
            left = Wall(thickness/2, globals.win_height/2, thickness, globals.win_height, 0),
            top = Wall(globals.win_width/2, thickness/2, globals.win_width, thickness, 0),
            right = Wall(globals.win_width-(thickness/2), globals.win_height/2,thickness, globals.win_height, 0),
            bottom = Wall(globals.win_width/2, globals.win_height-(thickness)/2, globals.win_width,thickness, 0)
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
            room.walls.left = Wall(thickness/2, globals.win_height/2, thickness, globals.win_height)
            room.walls.top = Wall(globals.win_width/2, thickness/2, globals.win_width, thickness)
            room.walls.right = Wall(globals.win_width-(thickness/2), globals.win_height/2,thickness, globals.win_height)
            room.walls.bottom = Wall(globals.win_width/2, globals.win_height-(thickness/2), globals.win_width,thickness)
    end

    return room
end