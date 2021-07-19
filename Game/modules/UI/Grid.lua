function Grid(width, height, visible)
    local grid = {
        data={
            current_win_width = globals.win_width,
            current_win_height = globals.win_height,
            width = width,
            height = height
        },
        visible = visible
    }

    local tInsert = table.insert

    grid.update =  function()
        grid.data = {
            current_win_width = grid.data.current_win_width,
            current_win_height = grid.data.current_win_height,
            width = width,
            height = height
        }

        for i = 0, width do
            local x = (grid.data.current_win_width)/grid.data.width  * i
            tInsert(
                grid.data,
                {
                    x_1 = x,
                    y_1 = 0,
                    x_2 = x,
                    y_2 = grid.data.current_win_height
                }
        )
        end

        for i = 0, height do
            local y = (grid.data.current_win_height)/grid.data.height * i
            tInsert(
                grid.data,
                {
                    x_1 = 0,
                    y_1 = y,
                    x_2 = grid.data.current_win_width,
                    y_2 = y
                }
        )
        end
    end

    grid.draw = function()
        if(grid.visible) then
            for _,v in ipairs(grid.data) do
                love.graphics.setColor(globals.colors.red)
                love.graphics.line(v.x_1, v.y_1, v.x_2, v.y_2)
                love.graphics.setColor(globals.colors.default)
            end
        end
    end

    grid.update_offsets = function ()
        grid.data.current_win_width = globals.win_width
        grid.data.current_win_height = globals.win_height
    end

    return grid
end