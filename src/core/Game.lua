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
    this.mapService = MapService:new(
            Map:new({ x = 20, y = 10 }, 32),
            this.imageFactory,
            this.rendererService,
            this.audioService
    )
    this.playerService = PlayerService:new(
            this.keyboardService,
            this.animationService:create(this.imageFactory.snakeSpritesheet, 16, 16, 1),
            this.audioService
    )
    this.cameraService = CameraService:new()

    function this:update(dt)
        self.audioService:update()
        self.mapService:update(dt)
        self.playerService:update(dt, this.cameraService, this.mapService.map)
    end

    function this:draw()
        self.mapService:render(self.playerService.player, self.cameraService)
        self.playerService:draw(self.cameraService)
    end

    return this
end

return Game