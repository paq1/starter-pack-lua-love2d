local Menu = {}

local ScenesName = require("src/core/scenes/ScenesName")

function Menu:new(
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

    function this:update(dt)

        if keyboardService:spaceIsDown() then
            return ScenesName.GAME
        end

        return ScenesName.NONE
    end

    function this:draw()
        rendererService:print("press space to start", {x = 100, y = 100})
    end

    return this
end

return Menu