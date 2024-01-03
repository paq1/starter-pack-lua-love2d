local TorchEffect = {}

function TorchEffect:new(
        mapService --[[MapService]],
        playerService --[[PlayerService]]
)
    local this = {
        mapService = mapService,
        playerService = playerService
    }

    function this:apply(dt)
        local coordPlayer = self.mapService.map:getCoordTile(self.playerService.player.position)
        local playerPosition = {
            x = (coordPlayer.x * self.mapService.map.tileSize) + 16,
            y = (coordPlayer.y * self.mapService.map.tileSize) + 16
        }

        return self.mapService.map:addLight(playerPosition)
    end

    return this
end

return TorchEffect