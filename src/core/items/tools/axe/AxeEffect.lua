local AxeEffect = {}

local ElementType = require("src/core/elements/ElementType")

function AxeEffect:new(
        mapService --[[MapService]],
        playerService --[[PlayerService]]
)
    local this = {
        mapService = mapService,
        playerService = playerService
    }

    function this:apply(dt)
        local offsetFootPlayer = 16
        local footPlayer = {
            x = self.playerService.player.position.x,
            y = self.playerService.player.position.y + offsetFootPlayer
        }
        local coordPlayer = self.mapService.map:getCoordTile(footPlayer)

        local firstLayoutElement = self.mapService.map.firstLayout[coordPlayer.y + 1][coordPlayer.x + 1]
        if firstLayoutElement.elementType ~= nil and firstLayoutElement.elementType == ElementType.ARBRE then
            self.mapService.map.firstLayout[coordPlayer.y + 1][coordPlayer.x + 1] = {}
        end
    end

    return this
end

return AxeEffect