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
    this.imagePlayerSize = 32

    this.playerAnimation = this.animationService:createHorizontalAnimation(
            imageFactory.personnageSpritesheet, this.imagePlayerSize, this.imagePlayerSize, 2
    )

    this.finalText = "Press space to start"
    this.text = ""
    this.textTimer = 0.0
    this.textDuration = 0.1

    function this:update(dt)

        this.playerAnimation:update(dt, false)

        if keyboardService:spaceIsDown() then
            return ScenesName.GAME
        end

        if #this.finalText ~= #this.text then
            this.textTimer = this.textTimer + dt
            if this.textTimer > this.textDuration then
                this.textTimer = this.textTimer - this.textDuration
                this.text = this.text .. string.sub(this.finalText, #this.text + 1, #this.text + 1)
            end
        end

        return ScenesName.NONE
    end

    function this:draw()
        this:drawPlayer()
        this:printPressSpace()
        self.mouseService:draw()
    end

    function this:drawPlayer()
        local windowCenterPosition = self.windowService:getCenter()
        local scale = 5

        local drawingPostion = {
            x = windowCenterPosition.x - (this.imagePlayerSize / 2.0) * scale,
            y = windowCenterPosition.y - (this.imagePlayerSize / 2.0) * scale
        }
        this.playerAnimation:draw(0, drawingPostion, scale)
    end

    function this:printPressSpace()
        local windowCenterPosition = self.windowService:getCenter()
        local windowSize = self.windowService:getSize()
        --local text = "press space to start"
        local text = self.text
        local printPosition = {
            x = windowCenterPosition.x - (#text * 3.3),
            y = windowSize.height - 100
        }
        rendererService:print("[" .. text .. "]", printPosition)
    end

    return this
end

return Menu