--Makes an "Enum" of colors, new ones can be added with https://www.rapidtables.com/web/color/RGB_Color.html
-- {R,G,B, optional A}

function Colors()
    --Metatable for quickly normalizing color values, Alpha is already 0-1
    local mt = {
        __div = function (lhs, rhs)
            return {lhs[1]/rhs, lhs[2]/rhs, lhs[3]/rhs, lhs[4]} --lhs[4] accounts for if an alpha value is provided
        end
    }

    local t = {
        default = {255,255,255},
        white = {255,255,255},
        red = {255,0,0},
        green = {0,255,0},
        blue = {0,0,255},
        black = {0, 0, 0},
        cyan = {39,178,168}
    }
    
    --Normalize all colors from standard RGB to the 0-1 Range Love uses
    local normalizing_value = 255
    for k,v in pairs(t) do
        setmetatable(v,mt)
        t[k] = v/normalizing_value
    end

    return t
end

--Function to use our existing colors and add/change alpha since is isn't in color format by default
function ChangeAlpha(color, new_alpha)
    local t = color
    t[4] = new_alpha
    return t
end