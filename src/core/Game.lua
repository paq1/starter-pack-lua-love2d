local Game = {}

local PlayerService = require("src/core/actor/player/PlayerService")
local Map = require("src/core/map/Map")
local MapService = require("src/core/map/MapService")
local CameraService = require("src/core/camera/CameraService")

function Game:new(
        keyboardService --[[KeyboardService]],
        rendererService --[[RendererService]],
        imageFactory --[[ImageFactory]],
        animationService --[[AnimationService]],
        audioService --[[AudioService]]
)
    local this = {
        keyboardService = keyboardService,
        rendererService = rendererService,
        imageFactory = imageFactory,
        animationService = animationService,
        audioService = audioService
    }
    this.playerService = PlayerService:new(
            this.keyboardService,
            this.animationService:create(this.imageFactory.snakeSpritesheet, 16, 16, 1),
            this.audioService
    )

    this.mapService = MapService:new(
            Map:new({ x = 30, y = 30 }, 32),
            this.imageFactory,
            this.rendererService,
            this.audioService,
            this.playerService
    )

    this.cameraService = CameraService:new()

    function this:update(dt)
        self.audioService:update()
        self.playerService:update(dt, this.cameraService, this.mapService.map)
        self.mapService:update(dt, this.cameraService)
    end

    function this:draw()
        self.mapService:render(self.cameraService)
    end

    return this
end

return Game