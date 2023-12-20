local Game = {}

local PlayerService = require("src/core/actor/player/playerService")
local Map = require("src/core/map/Map")
local MapService = require("src/core/map/MapService")
local CameraService = require("src/core/camera/CameraService")

function Game:new(
        keyboardService --[[KeyboardService]],
        rendererService --[[RendererService]],
        imageFactory --[[ImageFactory]],
        animationService --[[AnimationService]]
)
    local this = {
        keyboardService = keyboardService,
        rendererService = rendererService,
        imageFactory = imageFactory,
        animationService = animationService
    }
    this.mapService = MapService:new(
            Map:new({ x = 25, y = 10 }, 32),
            this.imageFactory,
            this.rendererService
    )
    this.playerService = PlayerService:new(
            this.keyboardService,
            this.animationService:create(this.imageFactory.snakeSpritesheet, 16, 16, 1)
    )
    this.cameraService = CameraService:new()

    function this:update(dt)
        self.playerService:update(dt, this.cameraService)
    end

    function this:draw()
        self.mapService:render(self.playerService.player, self.cameraService)
        self.playerService:draw(self.cameraService)
    end

    return this
end

return Game