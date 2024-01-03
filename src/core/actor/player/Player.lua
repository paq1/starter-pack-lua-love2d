local Player = {}

local BarreInventaire = require("src/core/inventaire/BarreInventaire")
local HitBox = require("src/core/hitbox/HitBox")

function Player:new(position, size)
    local this = {
        position = position,
        size = size,
        inventaire = BarreInventaire:new(5),
        footHitBox = HitBox:new({
            x = position.x,
            y = position.y + size.y + 3
        }, { width = size.x, height = 3 })
    }

    function this:getHitBox()
        return HitBox:new({
            x = self.position.x - 16,
            y = self.position.y - 16
        }, {
            width = self.size.x,
            height = self.size.y
        })
    end

    function this:getFootHitBox()
        return HitBox:new({
            x = self.position.x,
            y = self.position.y + self.size.y + 3
        }, { width = self.size.x, height = 3 })
    end


    return this
end

return Player