local ScenesService = {}

local Menu = require("src/core/scenes/menu/Menu")
local Game = require("src/core/scenes/game/Game")
local Options = require("src/core/scenes/options/Options")
local ScenesName = require("src/core/scenes/ScenesName")

function ScenesService:new(
        keyboardService --[[KeyboardService]],
        rendererService --[[RendererService]],
        imageFactory --[[ImageFactory]],
        animationService --[[AnimationService]],
        audioService --[[AudioService]],
        randomService --[[RandomService]],
        windowService --[[WindowService]],
        mouseService --[[MouseService]],
        canvasService --[[CanvasService]]
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
        canvasService = canvasService
    }

    this.scenes = {
        [ScenesName.MENU] = Menu:new(
                this.keyboardService,
                this.rendererService,
                this.imageFactory,
                this.animationService,
                this.audioService,
                this.randomService,
                this.windowService,
                this.mouseService,
                this.canvasService
        ),
        [ScenesName.GAME] = Game:new(
                this.keyboardService,
                this.rendererService,
                this.imageFactory,
                this.animationService,
                this.audioService,
                this.randomService,
                this.windowService,
                this.mouseService,
                this.canvasService
        ),
        [ScenesName.OPTIONS] = Options:new()
    }

    this.currentScene = ScenesName.MENU

    function this:update(dt)
        local newScene = self.scenes[this.currentScene]:update(dt)

        if newScene ~= ScenesName.NONE then
            this.currentScene = newScene
        end
    end

    function this:draw()
        self.scenes[this.currentScene]:draw()
    end

    return this
end

return ScenesService