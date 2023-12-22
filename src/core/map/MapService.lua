local MapService = {}

local ConfigMap = require("src/core/map/ConfigMap")
local ElementType = require("src/core/elements/ElementType")

function MapService:new(
        map --[[Map]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]],
        audioService --[[AudioService]],
        playerService --[[PlayerService]],
        cameraService --[[CameraService]]
)
    local this = {
        map = map,
        imageFactory = imageFactory,
        rendererService = rendererService,
        audioService = audioService,
        playerService = playerService,
        cameraService = cameraService,
        ordoringElements = {}
    }

    function this:minRowAndCol(offset)
        --local playerPos = self.playerService:playerDrawingPosition()
        local playerPos = self.playerService.player.position

        local minRow = math.floor(playerPos.y / self.map.tileSize) - offset
        local minCol = math.floor(playerPos.x / self.map.tileSize) - offset

        return {
            row = minRow,
            col = minCol
        }
    end

    function this:maxRowAndCol(offset)
        --local playerPos = self.playerService:playerDrawingPosition()
        local playerPos = self.playerService.player.position
        local maxRowPlayer = math.floor(playerPos.y / self.map.tileSize) + offset
        local maxColPlayer = math.floor(playerPos.x / self.map.tileSize) + offset
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

    function this:getElementsForDraw()
        local elements = {}

        local camPos = self.cameraService.position
        local offset = ConfigMap.offset

        local minRowAndCol = self:minRowAndCol(offset)
        local minRow, minCol = minRowAndCol.row, minRowAndCol.col
        local maxRowAndCol = self:maxRowAndCol(offset)
        local maxRow, maxCol = maxRowAndCol.row, maxRowAndCol.col

        for l = minRow, maxRow do
            for c = minCol, maxCol do
                if l > 0 and c > 0 then
                    local arbre = self.map.arbres[l][c]
                    if arbre.elementType == ElementType.ARBRE then
                        table.insert(
                                elements,
                                {
                                    position = { x = arbre.position.x - camPos.x, y = arbre.position.y - camPos.y - 32.0 },
                                    elementType = ElementType.ARBRE
                                }
                        )
                    end
                end
            end
        end

        return elements
    end

    function compareElement(element1, element2)

        local offsetPlayerArbre = 32

        if element1.elementType == ElementType.PLAYER then
            return element1.position.y - offsetPlayerArbre < element2.position.y
        end

        if element2.elementType == ElementType.PLAYER then
            return element1.position.y < element2.position.y - offsetPlayerArbre
        end

        return element1.position.y < element2.position.y
    end

    function this:update(dt)
        self.audioService:setBirdSoundEffectStatus(true) -- mettre en fct de l'environement du joueur

        local elements = self:getElementsForDraw()
        table.insert(elements, {position = playerService:playerDrawingPosition(), elementType = ElementType.PLAYER})
        self.ordoringElements = elements
        table.sort(self.ordoringElements, compareElement)
    end

    function this:render()
        local player = self.playerService.player

        local tileSize = self.map.tileSize
        local camPos = self.cameraService.position
        local offset = ConfigMap.offset

        local minRowAndCol = self:minRowAndCol(offset)
        local minRow, minCol = minRowAndCol.row, minRowAndCol.col
        local maxRowAndCol = self:maxRowAndCol(offset)
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
            if element.elementType == ElementType.ARBRE then
                self.rendererService:render(
                        self.imageFactory.fullTree,
                        element.position
                )
            end

            if element.elementType == ElementType.PLAYER then
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