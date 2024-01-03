local TorchEffect = {}

function TorchEffect:new(
        map --[[Map]],
        player --[[Player]]
)
    local this = {
        map = map,
        player = player
    }

    function this:apply(dt)
        local coordPlayer = self.map:getCoordTile(self.player.position)
        local playerPosition = {
            x = (coordPlayer.x * self.map.tileSize) + 16,
            y = (coordPlayer.y * self.map.tileSize) + 16
        }

        return self.map:addLight(playerPosition)
    end

    return this
end

return TorchEffect