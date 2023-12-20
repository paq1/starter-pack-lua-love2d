local Components = {}

local KeyboardService = require("src/app/keyboard/KeyboardService")
local RendererService = require("src/app/renderer/RendererService")
local ImageFactory = require("src/app/factories/ImageFactory")
local AnimationService = require("src/app/animation/AnimationService")

local Game = require("src/core/Game")

function Components:new()
    local this = {
        keyboardService = KeyboardService:new(),
        rendererService = RendererService:new(),
        imageFactory = ImageFactory:new(),
        animationService = AnimationService:new()
    }

    this.game = Game:new(
            this.keyboardService,
            this.rendererService,
            this.imageFactory,
            this.animationService
    )

    return this
end

return Components