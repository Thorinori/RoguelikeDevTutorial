--Queue from Programming in Lua Chapter 11
--Pushright + popleft for queue functionality

function CreateQueue()
    local Queue = {first=0,last=-1}

    Queue.pushleft = function(this,v)
        local first = this.first - 1
        this.first = first
        this[first] = v
    end

    Queue.pushright = function(this,v)
        local last = this.last + 1
        this.last = last
        this[last] = v
    end
    
    Queue.popleft = function(this)
        local first = this.first
        if first > this.last then return end
        local val = this[first]
        this[first] = nil
        this.first = first + 1
        return val
    end

    Queue.popright = function(this)
        local last = this.last
        if this.first > last then return end
        local val = this[last]
        this[last] = nil
        this.last = last - 1
        return val
    end

    return Queue
end