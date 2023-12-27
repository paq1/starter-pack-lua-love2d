local Game = {}

local ConfigGame = require("src/core/scenes/game/ConfigGame")
local PlayerService = require("src/core/actor/player/PlayerService")
local Map = require("src/core/map/Map")
local MapService = require("src/core/map/MapService")
local CameraService = require("src/core/camera/CameraService")
local ConfigMap = require("src/core/map/ConfigMap")
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
        postProcessLumiereService --[[PostProcessLumiereService]]
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
        postProcessLumiereService = postProcessLumiereService
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
            Map:new(ConfigMap.size, ConfigMap.tileSize, this.randomService),
            this.imageFactory,
            this.rendererService,
            this.audioService,
            this.playerService,
            this.cameraService,
            this.canvasService
    )

    this.postProcessLumiereCanvas = this.postProcessLumiereService:createLumiereCanvas(this.mapService.map)

    function this:updatePlayerDestroyTrees()
        if self.mouseService:leftButtonIsPressed() then
            local coordPlayer = self.mapService.map:getCoordTile(self.playerService.player.position)
            self.mapService.map.firstLayout[coordPlayer.y + 1][coordPlayer.x + 1] = {}
        end
    end

    function this:update(dt)
        self.audioService:update()


        self:updatePlayerDestroyTrees()

        self.playerService:update(dt, this.mapService.map)
        self.mapService:update(dt)

        return ScenesName.NONE
    end

    function this:draw()
        self.rendererService:setBlendMode()
        self.mapService:render()
        self.mouseService:draw()
        self.rendererService:render(self.postProcessLumiereCanvas, {x = 0, y = 0})
    end

    return this
end

return Game
