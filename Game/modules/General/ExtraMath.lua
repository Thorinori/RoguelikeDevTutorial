function GetFiringAngle(y2, y1, x2, x1)
    return math.atan2((y2 - y1), (x2 - x1)) --Firing Angle for where projectiles go
end

function NormalizeToWindowWidth(x)
    return x/globals.win_width
end

function NormalizeToWindowHeight(x)
    return x/globals.win_height
end