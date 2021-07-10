function DefaultShot(mouse_x, mouse_y, start_x, start_y, speed, size, font_choice)
    local Player = globals.perm_objects.Player
    local speed = speed or love.math.random()
    local proj_char = 'o'
    local char_size = size or 20
    local dest_x = NormalizeToWindowWidth(mouse_x)
    local dest_y = NormalizeToWindowHeight(mouse_y)
    local start_x = start_x or Player.x_offset + Player.border_offset_width/2
    local start_y = start_y or Player.y_offset + Player.border_offset_height/2
    local angle =  GetFiringAngle(dest_y, start_y, dest_x, start_x)
    globals.temp_objects.bullets[globals.next_id] = CreateProj(
        globals.perm_objects.Player,
        proj_char,
        char_size,
        start_x,
        start_y,
        globals.next_id,
        speed,
        dest_x,
        dest_y,
        angle,
        globals.colors.cyan,
        font_choice
    )
    globals.next_id = globals.next_id + 1
    if(debug) then
        debug_globals.current_object_count = debug_globals.current_object_count + 1
    end
end