local MapService = {}

function MapService:new(
        map --[[Map]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]],
        audioService --[[AudioService]],
        playerService --[[PlayerService]]
)
    local this = {
        map = map,
        imageFactory = imageFactory,
        rendererService = rendererService,
        audioService = audioService,
        playerService = playerService,
        ordoringElements = {}
    }

    function this:minRowAndCol()
        local playerPos = self.playerService.player.position

        local tileSize = self.map.tileSize
        local offset = 30 -- fixme mettre un offset en fct de la taille de l'ecran
        local minRow = math.floor(playerPos.y / tileSize) - offset
        local minCol = math.floor(playerPos.x / tileSize) - offset

        return {
            row = minRow,
            col = minCol
        }
    end

    function this:maxRowAndCol()
        local playerPos = self.playerService.player.position
        local tileSize = self.map.tileSize
        local offset = 30 -- fixme mettre un offset en fct de la taille de l'ecran
        local maxRowPlayer = math.floor(playerPos.y / tileSize) + offset
        local maxColPlayer = math.floor(playerPos.x / tileSize) + offset
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
        return {
            row = maxRow,
            col = maxCol
        }
    end

    function this:getElementsForDraw(cameraService)
        local elements = {}

        local tileSize = self.map.tileSize
        local camPos = cameraService.position

        local minRowAndCol = self:minRowAndCol()
        local minRow, minCol = minRowAndCol.row, minRowAndCol.col
        local maxRowAndCol = self:maxRowAndCol()
        local maxRow, maxCol = maxRowAndCol.row, maxRowAndCol.col

        for l = minRow, maxRow do
            for c = minCol, maxCol do
                if l > 0 and c > 0 then
                    local arbre = self.map.arbres[l][c]
                    if arbre == 1 then
                        table.insert(
                                elements,
                                {
                                    position = { x = c * tileSize - camPos.x, y = l * tileSize - camPos.y - 32.0 },
                                    elementType = "arbre"
                                }
                        )
                    end
                end
            end
        end

        return elements
    end

    function compareElement(element1, element2)

        if element1.elementType == "player" then
            return element1.position.y - 32 < element2.position.y
        end

        if element2.elementType == "player" then
            return element1.position.y < element2.position.y - 32
        end

        return element1.position.y < element2.position.y
    end

    function this:update(dt, cameraService --[[CameraService]])
        self.audioService:setBirdSoundEffectStatus(true) -- mettre en fct de l'environement du joueur

        local elements = self:getElementsForDraw(cameraService --[[CameraService]])
        table.insert(elements, {position = playerService:playerDrawingPosition(cameraService), elementType = "player"})
        self.ordoringElements = elements
        table.sort(self.ordoringElements, compareElement)
    end

    function this:render(
            cameraService --[[CameraService]]
    )
        local player = self.playerService.player

        local tileSize = self.map.tileSize
        local camPos = cameraService.position

        local minRowAndCol = self:minRowAndCol()
        local minRow, minCol = minRowAndCol.row, minRowAndCol.col
        local maxRowAndCol = self:maxRowAndCol()
        local maxRow, maxCol = maxRowAndCol.row, maxRowAndCol.col

        for l = minRow, maxRow do
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

        for elementIndex = 1, #self.ordoringElements do
            local element = self.ordoringElements[elementIndex]
            if element.elementType == "arbre" then
                self.rendererService:render(
                        self.imageFactory.fullTree,
                        element.position
                )
            end

            if element.elementType == "player" then
                self.playerService:draw(cameraService)
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