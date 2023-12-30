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


        self:updatePlayerDestroyTrees()
        self:updatePlayerPutLight()

        self.playerService:update(dt, this.mapService.map)
        self.mapService:update(dt)

        return ScenesName.NONE
    end

    function this:draw()
        self.lightService:drawNightMod(self.mapService.map.lights, self.cameraService.position)
        self.mapService:render()
        self.lightService:resetShader()

        self.mouseService:draw()
        if ConfigApp.debug then
            self.mapService:printCurrentCoordPlayerOnMap({ x = self.windowService:getCenter().x, y = 0 }, self.playerService.player)
            self:printNbLight({ x = 0, y = 64 })
        end
    end

    function this:updatePlayerDestroyTrees()
        if self.mouseService:leftButtonIsPressed() then
            local footPlayer = {
                x = self.playerService.player.position.x,
                y = self.playerService.player.position.y + 16
            }
            local coordPlayer = self.mapService.map:getCoordTile(footPlayer)
            self.mapService.map.firstLayout[coordPlayer.y + 1][coordPlayer.x + 1] = {}
        end
    end

    function this:updatePlayerPutLight()
        local coordPlayer = self.mapService.map:getCoordTile(self.playerService.player.position)
        local playerPosition = {
            x = (coordPlayer.x * self.mapService.map.tileSize) + 16,
            y = (coordPlayer.y * self.mapService.map.tileSize) + 16
        }

        if self.keyboardService:actionKeyIsDown() then
            self.mapService.map:addLight(playerPosition)
        end
    end

    function this:printNbLight(at)
        at = at or { x = 0, y = 0 }
        self.rendererService:print("lights : " .. #self.mapService.map.lights, at)
    end

    return this
end

return Game
