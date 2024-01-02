local AxeEffect = {}

function AxeEffect:new(
        mapService --[[MapService]],
        playerService --[[PlayerService]]
)
    local this = {
        mapService = mapService,
        playerService = playerService
    }

    function this:apply(dt)
        local footPlayer = {
            x = self.playerService.player.position.x,
            y = self.playerService.player.position.y + 16
        }
        local coordPlayer = self.mapService.map:getCoordTile(footPlayer)
        self.mapService.map.firstLayout[coordPlayer.y + 1][coordPlayer.x + 1] = {}
    end

    return this
end

return AxeEffect