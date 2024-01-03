local AxeSideEffect = {}

local ElementType = require("src/core/elements/ElementType")

function AxeSideEffect:new(
        map --[[Map]],
        player --[[Player]]
)
    local this = {
        map = map,
        player = player
    }

    function this:apply(dt)
        local offsetFootPlayer = 16
        local footPlayer = {
            x = self.player.position.x,
            y = self.player.position.y + offsetFootPlayer
        }
        local coordPlayer = self.map:getCoordTile(footPlayer)

        local firstLayoutElement = self.map.firstLayout[coordPlayer.y + 1][coordPlayer.x + 1]
        if firstLayoutElement.elementType ~= nil and firstLayoutElement.elementType == ElementType.ARBRE then
            self.map.firstLayout[coordPlayer.y + 1][coordPlayer.x + 1] = {}
        end
    end

    return this
end

return AxeSideEffect