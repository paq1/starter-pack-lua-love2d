local MapService = {}

local ConfigMap = require("src/core/map/ConfigMap")
local ConfigGame = require("src/core/scenes/game/ConfigGame")
local ElementType = require("src/core/elements/ElementType")
local TreeCategory = require("src/core/map/TreeCategory")

local Axe = require("src/core/items/tools/axe/Axe")
local AxeEffect = require("src/core/items/tools/axe/AxeEffect")

local Torch = require("src/core/items/tools/torch/Torch")
local TorchEffect = require("src/core/items/tools/torch/TorchEffect")

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

    this.items = {
        Axe:new(
                AxeEffect:new(this, this.playerService),
                this.imageFactory,
                this.rendererService,
                 {x = 32, y = 32 * 5}
        ),
        Axe:new(
                AxeEffect:new(this, this.playerService),
                this.imageFactory,
                this.rendererService,
                {x = 32, y = 32 * 7}
        ),
        Torch:new(
                TorchEffect:new(this, this.playerService),
                this.imageFactory,
                this.rendererService,
                {x = 32, y = 32 * 8}
        )
    }

    function this:update(dt)
        self.audioService:setBirdSoundEffectStatus(true) -- mettre en fct de l'environement du joueur
        self.animationFactory.torcheAnimation:update(dt)

        local elements = self:getElementsForDraw()
        self.ordoringElements = elements
        table.sort(self.ordoringElements, compareElement)

        self:playerCanTakeItem()
    end

    function this:render()
        local camPos = self.cameraService.position

        self.rendererService:render(
                self.canvasTilemap,
                { x = -camPos.x, y = -camPos.y },
                ConfigGame.scale
        )
        self:renderElements(camPos)

        -- todo les afficher dans l'ordre
        -- affichage des items sur la map
        for _,item in pairs(self.items) do
            item:draw(camPos, ConfigGame.scale)

            -- todo decommenter si on veut voir les hitboxes des items
            --local hitbox = item:getHitBox()
            --local position = hitbox.position
            --local w, h = hitbox.size.width, hitbox.size.height
            --love.graphics.rectangle("fill", (position.x * ConfigGame.scale) - camPos.x,( position.y * ConfigGame.scale) - camPos.y, w * ConfigGame.scale, h * ConfigGame.scale)

        end
    end

    function this:playerCanTakeItem()
        local playerHitBox = self.playerService.player:getHitBox()
        for index, item in pairs(self.items) do
            local itemHitBox = item:getHitBox()
            if playerHitBox:collide(itemHitBox) then
                local successAdd = playerService.player.inventaire:addItem(self.items[index])
                if successAdd then
                    self.items[index].position = {} -- disparait de la map
                    table.remove(self.items, index)
                end
            end
        end
    end


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

    function this:renderElements(camPos)
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
                local imageArbre = self.imageFactory.fullTree

                if arbreType == TreeCategory.SAPIN then
                    imageArbre = self.imageFactory.sapin
                end

                self.rendererService:render(
                        imageArbre,
                        { x = drawingPosition.x, y = drawingPosition.y - (offsetTreeY * ConfigGame.scale + offsetBasiqueElement) },
                        ConfigGame.scale
                )
            end

            if element.elementType == ElementType.PLAYER then
                self.playerService:draw(cameraService)
            end

            if element.elementType == ElementType.TORCHE then
                local torchePosition = {
                    x = drawingPosition.x - offsetBasiqueElement,
                    y = drawingPosition.y - offsetBasiqueElement
                }
                self.animationFactory.torcheAnimation:draw(0, torchePosition, ConfigGame.scale)
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

        self.rendererService:print("current tile : (" .. coord.x .. ", " .. coord.y .. ")", { x = at.x, y = at.y })
    end

    return this
end

return MapService