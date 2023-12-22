local Game = {}

local PlayerService = require("src/core/actor/player/PlayerService")
local Map = require("src/core/map/Map")
local MapService = require("src/core/map/MapService")
local CameraService = require("src/core/camera/CameraService")
local ConfigMap = require("src/core/map/ConfigMap")

function Game:new(
        keyboardService --[[KeyboardService]],
        rendererService --[[RendererService]],
        imageFactory --[[ImageFactory]],
        animationService --[[AnimationService]],
        audioService --[[AudioService]],
        randomService --[[RandomService]],
        windowService --[[WindowService]]
)
    local this = {
        keyboardService = keyboardService,
        rendererService = rendererService,
        imageFactory = imageFactory,
        animationService = animationService,
        audioService = audioService,
        randomService = randomService,
        windowService = windowService
    }
    this.cameraService = CameraService:new(this.windowService)

    this.playerService = PlayerService:new(
            this.keyboardService,
            this.animationService:create(this.imageFactory.snakeSpritesheet, 16, 16, 1),
            this.audioService,
            this.cameraService
    )


    this.mapService = MapService:new(
            Map:new(ConfigMap.size, ConfigMap.tileSize, this.randomService),
            this.imageFactory,
            this.rendererService,
            this.audioService,
            this.playerService,
            this.cameraService
    )

    function this:updatePlayerDestroyTrees()
        if self.keyboardService:actionKeyIsDown() then
            local coordPlayer = self.mapService.map:getCoordTile(self.playerService.player.position)
            self.mapService.map.arbres[coordPlayer.y][coordPlayer.x] = {}
        end
    end

    function this:update(dt)
        self.audioService:update()


        self:updatePlayerDestroyTrees()

        self.playerService:update(dt, this.mapService.map)
        self.mapService:update(dt)
    end

    function this:draw()
        self.mapService:render()
    end

    return this
end

return Game