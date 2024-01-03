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
        canvasService --[[CanvasService]],
        lightService --[[LightService]],
        animationFactory --[[AnimationFactory]],
        perlinNoiseService --[[PerlinNoiseService]]
)
    local this = {}

    this.scenes = {
        [ScenesName.MENU] = Menu:new(
                keyboardService,
                rendererService,
                imageFactory,
                animationService,
                audioService,
                randomService,
                windowService,
                mouseService,
                canvasService
        ),
        [ScenesName.GAME] = Game:new(
                keyboardService,
                rendererService,
                imageFactory,
                animationService,
                audioService,
                randomService,
                windowService,
                mouseService,
                canvasService,
                lightService,
                animationFactory,
                perlinNoiseService
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

    function this:draw(debugMode)
        debugMode = debugMode or false
        self.scenes[self.currentScene]:draw(debugMode)
    end

    return this
end

return ScenesService