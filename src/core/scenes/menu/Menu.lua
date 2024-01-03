local Menu = {}

local ScenesName = require("src/core/scenes/ScenesName")
local DynamicTextAppearDisappear = require("src/core/text/DynamicTextAppearDisappear")

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
    local this = {}
    this.imagePlayerSize = 32

    this.playerAnimation = animationService:createHorizontalAnimation(
            imageFactory.personnageSpritesheet, this.imagePlayerSize, this.imagePlayerSize, 2
    )

    this.dynText = DynamicTextAppearDisappear:new("Press space to start", 0.1)

    function this:update(dt)

        this.playerAnimation:update(dt, false)

        if keyboardService:spaceIsDown() then
            return ScenesName.GAME
        end

        this.dynText:update(dt)

        return ScenesName.NONE
    end

    function this:draw(debugMode)
        debugMode = debugMode or false
        this:drawPlayer()
        this:printPressSpace()
        mouseService:draw()
    end

    function this:drawPlayer()
        local windowCenterPosition = windowService:getCenter()
        local scale = 5

        local drawingPostion = {
            x = windowCenterPosition.x - (this.imagePlayerSize / 2.0) * scale,
            y = windowCenterPosition.y - (this.imagePlayerSize / 2.0) * scale
        }
        this.playerAnimation:draw(0, drawingPostion, scale)
    end

    function this:printPressSpace()
        local windowCenterPosition = windowService:getCenter()
        local windowSize = windowService:getSize()
        --local text = "press space to start"
        local text = self.dynText.currentText
        local printPosition = {
            x = windowCenterPosition.x - (#text * 3.3),
            y = windowSize.height - 100
        }
        rendererService:print("[" .. text .. "]", printPosition)
    end

    return this
end

return Menu