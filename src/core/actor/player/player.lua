local player_module = {}

function player_module.new(position, size)
    local player = {
        position = position,
        size = size
    }

    return player
end

return player_module