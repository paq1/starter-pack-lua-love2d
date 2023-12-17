local Player = {}

function Player:new(position, size)
    local this = {
        position = position,
        size = size
    }

    return this
end

return Player