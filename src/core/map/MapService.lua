local MapService = {}

local ConfigMap = require("src/core/map/ConfigMap")
local ConfigGame = require("src/core/scenes/game/ConfigGame")
local ElementType = require("src/core/elements/ElementType")

function MapService:new(
        map --[[Map]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]],
        audioService --[[AudioService]],
        playerService --[[PlayerService]],
        cameraService --[[CameraService]],
        canvasService --[[CanvasService]],
        animationFactory --[[AnimationFactory]]
)
    local this = {
        map = map,
        imageFactory = imageFactory,
        rendererService = rendererService,
        audioService = audioService,
        playerService = playerService,
        cameraService = cameraService,
        canvasService = canvasService,
        animationFactory = animationFactory,
        ordoringElements = {}
    }

    this.canvasTilemap = this.canvasService:fromMapToTilemapCanvas(map)


    function this:minRowAndCol(offset)
        local playerPos = self.playerService.player.position

        local minRow = math.floor(playerPos.y / self.map.tileSize) - offset
        local minCol = math.floor(playerPos.x / self.map.tileSize) - offset

        return {
            row = minRow,
            col = minCol
        }
    end

    function this:maxRowAndCol(offset)
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

        local offset = ConfigMap.offset

        local minRowAndCol = self:minRowAndCol(offset)
        local minRow, minCol = minRowAndCol.row, minRowAndCol.col
        local maxRowAndCol = self:maxRowAndCol(offset)
        local maxRow, maxCol = maxRowAndCol.row, maxRowAndCol.col

        for l = minRow, maxRow do
            for c = minCol, maxCol do
                if l > 0 and c > 0 then
                    local arbre = self.map.firstLayout[l][c]
                    if arbre.elementType == ElementType.ARBRE then
                        table.insert(elements, {
                            position = {
                                x = arbre.position.x,
                                y = arbre.position.y
                            },
                            elementType = ElementType.ARBRE,
                            arbreType = arbre.arbreType
                        })
                    end
                end
            end
        end

        for _, torche in pairs(self.map.lights) do
            table.insert(elements, {
                position = {
                    x = torche.position.x,
                    y = torche.position.y
                },
                elementType = ElementType.TORCHE
            })
        end


        local playerPosition = {
            x = self.playerService.player.position.x,
            y = self.playerService.player.position.y
        }
        table.insert(elements, {position = playerPosition, elementType = ElementType.PLAYER})

        return elements
    end

    function compareElement(element1, element2)
        return element1.position.y < element2.position.y
    end

    function this:update(dt)
        self.audioService:setBirdSoundEffectStatus(true) -- mettre en fct de l'environement du joueur
        self.animationFactory.torcheAnimation:update(dt)

        local elements = self:getElementsForDraw()
        self.ordoringElements = elements
        table.sort(self.ordoringElements, compareElement)
    end

    function this:render()
        local camPos = self.cameraService.position

        self.rendererService:render(
                self.canvasTilemap,
                { x = -camPos.x, y = -camPos.y },
                ConfigGame.scale
        )
        self:renderElements(camPos)
    end

    function this:renderElements(camPos)
        local heightSizeOfTree = 64.0
        local offsetTreeY = heightSizeOfTree / 2.0
        local offsetTorcheForCenter = (16 * ConfigGame.scale)

        for elementIndex = 1, #self.ordoringElements do
            local element = self.ordoringElements[elementIndex]

            local drawingPosition = {
                x = (element.position.x * ConfigGame.scale) - camPos.x,
                y = (element.position.y * ConfigGame.scale) - camPos.y
            }
            if element.elementType == ElementType.ARBRE then

                local arbreType = element.arbreType
                local imageArbre = self.imageFactory.fullTree

                if arbreType == "sapin" then
                    imageArbre = self.imageFactory.sapin
                end

                self.rendererService:render(
                        imageArbre,
                        { x = drawingPosition.x, y = drawingPosition.y - (offsetTreeY * ConfigGame.scale) },
                        ConfigGame.scale
                )
            end

            if element.elementType == ElementType.PLAYER then
                self.playerService:draw(cameraService)
            end

            if element.elementType == ElementType.TORCHE then
                local torchePosition = {
                    x = drawingPosition.x - offsetTorcheForCenter,
                    y = drawingPosition.y - offsetTorcheForCenter
                }
                self.animationFactory.torcheAnimation:draw(0, torchePosition, ConfigGame.scale)
            end
        end
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