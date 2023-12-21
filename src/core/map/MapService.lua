local MapService = {}

function MapService:new(
        map --[[Map]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]],
        audioService --[[AudioService]]
)
    local this = {
        map = map,
        imageFactory = imageFactory,
        rendererService = rendererService,
        audioService = audioService
    }

    function this:update(dt)
        self.audioService:setBirdSoundEffectStatus(true) -- mettre en fct de l'environement du joueur
    end

    function this:render(
            player --[[Player]],
            cameraService --[[CameraService]]
    )

        local tileSize = self.map.tileSize
        local camPos = cameraService.position
        local offset = 30 -- fixme mettre un offset en fct de la taille de l'ecran
        local minRow = math.floor(player.position.y / tileSize) - offset
        local minCol = math.floor(player.position.x / tileSize) - offset

        local maxRowPlayer = math.floor(player.position.y / tileSize) + offset
        local maxColPlayer = math.floor(player.position.x / tileSize) + offset

        local maxRowFromMap = #self.map.tilemap
        local maxColFromMap = #self.map.tilemap[1]

        local maxRow = maxRowPlayer
        local maxCol = maxColPlayer

        if maxRowPlayer > maxRowFromMap then
            maxRow = maxRowFromMap
        end

        if maxColPlayer > maxColFromMap then
            maxCol = maxColFromMap
        end

        for l = minRow,maxRow do
            for c = minCol, maxCol do
                if l > 0 and c > 0 then
                    local tile = self.map.tilemap[l][c]
                    if tile == 1 then
                        self.rendererService:render(
                                self.imageFactory.tileGrassImage,
                                { x = c * tileSize - camPos.x, y = l * tileSize - camPos.y }
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