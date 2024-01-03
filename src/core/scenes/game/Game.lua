local Game = {}

local ConfigGame = require("src/core/scenes/game/ConfigGame")
local PlayerService = require("src/core/actor/player/PlayerService")
local Map = require("src/core/map/Map")
local MapService = require("src/core/map/MapService")
local CameraService = require("src/core/camera/CameraService")
local ConfigMap = require("src/core/map/ConfigMap")
local ConfigApp = require("src/core/ConfigApp")
local Player = require("src/core/actor/player/Player")
local ScenesName = require("src/core/scenes/ScenesName")
local ItemType = require("src/core/items/ItemType")
local InventaireService = require("src/core/inventaire/InventaireService")

function Game:new(
        keyboardService --[[KeyboardService]],
        rendererService --[[RendererService]],
        imageFactory --[[ImageFactory]],
        animationService --[[AnimationService]],
        audioService --[[AudioService]],
        randomService --[[RandomService]],
        windowService --[[WindowService]],
        mouseService --[[MouseService]],
        canvasService --[[CanvasService]],
        lightService --[[LightService]],
        animationFactory --[[AnimationFactory]],
        perlinNoiseService --[[PerlinNoiseService]]
)
    local this = {
        keyboardService = keyboardService,
        rendererService = rendererService,
        imageFactory = imageFactory,
        animationService = animationService,
        audioService = audioService,
        randomService = randomService,
        windowService = windowService,
        mouseService = mouseService,
        canvasService = canvasService,
        lightService = lightService,
        animationFactory = animationFactory,
        perlinNoiseService = perlinNoiseService
    }
    this.cameraService = CameraService:new(this.windowService)
    this.inventaireService = InventaireService:new(
            this.keyboardService,
            this.rendererService,
            this.windowService,
            this.imageFactory
    )


    this.mouseService:setVisibility(false)

    local tailleUneImageDeLAnimation = 32
    local playerSize = { x = 32.0, y = 32.0 }

    this.playerService = PlayerService:new(
            this.keyboardService,
            this.animationService:createHorizontalAnimation(
                    this.imageFactory.personnageSpritesheet,
                    tailleUneImageDeLAnimation,
                    tailleUneImageDeLAnimation,
                    1
            ),
            this.audioService,
            this.cameraService,
            Player:new(ConfigGame.positionInitialePlayer, playerSize)
    )


    this.mapService = MapService:new(
            Map:new(
                    ConfigMap.size,
                    ConfigMap.tileSize,
                    this.randomService,
                    this.perlinNoiseService
            ),
            this.imageFactory,
            this.rendererService,
            this.audioService,
            this.playerService,
            this.cameraService,
            this.canvasService,
            this.animationFactory
    )

    function this:update(dt)
        self.audioService:update()

        self:playerCanUseEquippedItem(dt)
        self:playerCanTakeItemOnMap()

        self.playerService:update(dt, self.mapService.map)
        self.mapService:update(dt)

        self.inventaireService:update(dt, self.playerService.player.inventaire)


        return ScenesName.NONE
    end

    function this:draw(debugMode)

        debugMode = debugMode or false

        self.lightService:drawNightMod(self.mapService.map.lights, self.cameraService.position)
        self.mapService:render(debugMode)
        self.lightService:resetShader()

        self.inventaireService:draw(self.playerService.player.inventaire, ConfigGame.scale)
        self.mapService:drawIndication()

        self.mouseService:draw()
        if ConfigApp.debug then
            self.mapService:printCurrentCoordPlayerOnMap({ x = self.windowService:getCenter().x, y = 0 }, self.playerService.player)
            self:printNbLight({ x = 0, y = 64 })
        end
    end

    function this:playerCanUseEquippedItem(dt)
        if self.mouseService:leftButtonIsPressed() then
            local item = self.playerService.player.inventaire.slotEquipe
            if item.itemType ~= ItemType.EMPTY then
                item:apply(dt)
            end
        end
    end

    function this:playerCanTakeItemOnMap()
        local playerHitBox = self.playerService.player:getHitBox()
        for index, item in pairs(self.mapService.items) do
            local itemHitBox = item:getHitBox()
            if playerHitBox:collide(itemHitBox) then
                local successAdd = self.playerService.player.inventaire:addItem(self.mapService.items[index])
                if successAdd then
                    self.mapService.items[index].position = {} -- disparait de la map
                    table.remove(self.mapService.items, index)
                end
            end
        end
    end

    function this:printNbLight(at)
        at = at or { x = 0, y = 0 }
        self.rendererService:print("lights : " .. #self.mapService.map.lights, at)
    end

    return this
end

return Game
