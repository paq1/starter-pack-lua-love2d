local MapService = {}

local ConfigMap = require("src/core/map/ConfigMap")
local ConfigGame = require("src/core/scenes/game/ConfigGame")
local ElementType = require("src/core/elements/ElementType")
local TreeCategory = require("src/core/map/TreeCategory")

local Axe = require("src/core/items/tools/axe/Axe")
local Torch = require("src/core/items/consommable/torch/Torch")

function MapService:new(
        map --[[Map]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]],
        audioService --[[AudioService]],
        playerService --[[PlayerService]],
        cameraService --[[CameraService]],
        canvasService --[[CanvasService]],
        animationFactory --[[AnimationFactory]],
        itemSideEffectFactory --[[ItemSideEffectFactory]]
)
    local this = {
        map = map,
        ordoringElements = {}
    }

    this.canvasTilemap = canvasService:fromMapToTilemapCanvas(map)

    this.items = {
        Axe:new(
                itemSideEffectFactory:getEffect("axe"),
                imageFactory,
                rendererService,
                 {x = 32, y = 32 * 5}
        ),
        Axe:new(
                itemSideEffectFactory:getEffect("axe"),
                imageFactory,
                rendererService,
                {x = 32, y = 32 * 7}
        ),
        Torch:new(
                itemSideEffectFactory:getEffect("torch"),
                imageFactory,
                rendererService,
                {x = 32, y = 32 * 8},
                10
        ),
        Torch:new(
                itemSideEffectFactory:getEffect("torch"),
                imageFactory,
                rendererService,
                {x = 32, y = 32 * 9},
                10
        )
    }

    function this:update(dt)
        audioService:setBirdSoundEffectStatus(true) -- mettre en fct de l'environement du joueur
        animationFactory.torcheAnimation:update(dt)
        animationFactory.indicationAnimation:update(dt)

        -- on tri les elements à afficher
        local elements = self:getElementsForDraw()
        self.ordoringElements = elements
        table.sort(self.ordoringElements, compareElement)
    end

    function this:render(debugMode)

        debugMode = debugMode or false

        local camPos = cameraService.position

        rendererService:render(
                self.canvasTilemap,
                { x = -camPos.x, y = -camPos.y },
                ConfigGame.scale
        )
        self:renderElements(camPos, debugMode)

        -- todo les afficher dans l'ordre
        -- affichage des items sur la map
        for _,item in pairs(self.items) do
            item:draw(camPos, ConfigGame.scale)
            -- todo decommenter si on veut voir les hitboxes des items
            if debugMode then
                local hitbox = item:getHitBox()
                local position = hitbox.position
                local w, h = hitbox.size.width, hitbox.size.height

                rendererService:drawRectangle(
                        "line",
                        {
                            x = position.x * ConfigGame.scale - camPos.x,
                            y = position.y * ConfigGame.scale - camPos.y
                        },
                        {
                            width = w * ConfigGame.scale,
                            height = h * ConfigGame.scale
                        }
                )
            end
        end
    end

    function this:drawIndication()
        local camPos = cameraService.position

        for _,item in pairs(self.items) do
            local position = item.position
            animationFactory.indicationAnimation:draw(0, {
                x = (position.x) * ConfigGame.scale - camPos.x,
                y = (position.y - 32) * ConfigGame.scale - camPos.y
            }, ConfigGame.scale)
        end
    end


    function this:minRowAndCol(offset)
        local playerPos = playerService.player.position

        local minRow = math.floor(playerPos.y / self.map.tileSize) - offset
        local minCol = math.floor(playerPos.x / self.map.tileSize) - offset

        return {
            row = minRow,
            col = minCol
        }
    end

    function this:maxRowAndCol(offset)
        local playerPos = playerService.player.position
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
            x = playerService.player.position.x,
            y = playerService.player.position.y
        }
        table.insert(elements, {position = playerPosition, elementType = ElementType.PLAYER})

        return elements
    end

    function compareElement(element1, element2)
        return element1.position.y < element2.position.y
    end

    function this:renderElements(camPos, debugMode)

        debugMode = debugMode or false

        local heightSizeOfTree = 64.0
        local offsetTreeY = heightSizeOfTree / 2.0
        local offsetBasiqueElement = (16 * ConfigGame.scale)


        for _, element in pairs(self.ordoringElements) do
            local drawingPosition = {
                x = (element.position.x * ConfigGame.scale) - camPos.x,
                y = (element.position.y * ConfigGame.scale) - camPos.y
            }
            if element.elementType == ElementType.ARBRE then

                local arbreType = element.arbreType
                local imageArbre = imageFactory.fullTree

                if arbreType == TreeCategory.SAPIN then
                    imageArbre = imageFactory.sapin
                end

                rendererService:render(
                        imageArbre,
                        { x = drawingPosition.x, y = drawingPosition.y - (offsetTreeY * ConfigGame.scale + offsetBasiqueElement) },
                        ConfigGame.scale
                )
            end

            if element.elementType == ElementType.PLAYER then
                playerService:draw(debugMode)
            end

            if element.elementType == ElementType.TORCHE then
                local torchePosition = {
                    x = drawingPosition.x - offsetBasiqueElement,
                    y = drawingPosition.y - offsetBasiqueElement
                }
                animationFactory.torcheAnimation:draw(0, torchePosition, ConfigGame.scale)
            end
        end
    end

    function this:printCurrentCoordPlayerOnMap(at, player)
        at = at or { x = 0, y = 0 }
        local pos = player.position
        local footPosition = {
            x = pos.x,
            y = pos.y + 16
        }
        local coord = self.map:getCoordTile(footPosition)

        rendererService:print("current tile : (" .. coord.x .. ", " .. coord.y .. ")", { x = at.x, y = at.y })
    end

    return this
end

return MapService