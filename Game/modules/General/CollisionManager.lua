 --Returns true if a and b are of desired types name1 amd name2
 --without order mattering, makes callbacks much more readable
local function compare(a,b,name1,name2)
    return (a:getUserData() == name1 or a:getUserData() == name2) and
        (b:getUserData() == name1 or b:getUserData() == name2)
end

function beginContact(a, b, coll)
    if(compare(a,b,'Player','Wall')) then
        globals.Player.obtained_upgrades.multishot = true
    end
end

function endContact(a, b, coll)
    if(compare(a,b,'Player', 'Wall')) then
        globals.Player.obtained_upgrades.multishot = false
    end
end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end
