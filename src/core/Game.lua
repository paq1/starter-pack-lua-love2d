local Game = {}

local PlayerService = require("src/core/actor/player/playerService")
local Map = require("src/core/map/Map")
local MapService = require("src/core/map/MapService")

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

    function this:update(dt)
        self.playerService:update(dt)
    end

    function this:draw()
        self.mapService:render(self.playerService.player)
        self.playerService:draw()
    end

    return this
end

return Game