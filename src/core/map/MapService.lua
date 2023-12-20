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

        local camPos = cameraService.position
        local offset = 30 -- fixme mettre un offset en fct de la taille de l'ecran
        local minRow = math.floor(player.position.y / 32.0) - offset
        local minCol = math.floor(player.position.x / 32.0) - offset
        local maxRow = math.floor(player.position.y / 32.0) + offset
        local maxCol = math.floor(player.position.x / 32.0) + offset

        for l = minRow,maxRow do
            for c = minCol, maxCol do
                if l > 0 and c > 0 then
                    local tile = self.map.tilemap[l][c]
                    if tile == 1 then
                        self.rendererService:render(
                                self.imageFactory.tileGrassImage, { x = c * 32 - camPos.x, y = l * 32 - camPos.y }
                        )
                    end
                end
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