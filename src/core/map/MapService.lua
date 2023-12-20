local MapService = {}

function MapService:new(
        map --[[Map]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]]
)
    local this = {
        map = map,
        imageFactory = imageFactory,
        rendererService = rendererService
    }

    function this:render(
            player,
            cameraService --[[CameraService]]
    )
        for l = 0, self.map.size.y do
            for c = 0, self.map.size.x do
                self.rendererService:render(self.imageFactory.tileGrassImage, { x = c * 32 - cameraService.position.x, y = l * 32 - cameraService.position.y })
            end
        end

        self:printCurrentCoordPlayerOnMap({ x = 0, y = 32 }, player)
    end

    function this:printCurrentCoordPlayerOnMap(at, player)
        at = at or { x = 0, y = 0 }
        local pos = player.position
        local coord = self.map:getCoordTile(pos)

        self.rendererService:print("current tile : (" .. coord.x .. ", " .. coord.y .. ")", { x = at.x, y = at.y })
    end

    return this
end

return MapService