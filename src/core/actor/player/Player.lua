local Player = {}

local BarreInventaire = require("src/core/inventaire/BarreInventaire")

function Player:new(position, size)
    local this = {
        position = position,
        size = size,
        inventaire = BarreInventaire:new(5)
    }

    return this
end

return Player