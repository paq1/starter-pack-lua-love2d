local Components = {}

local KeyboardService = require("src/app/keyboard/KeyboardService")
local RendererService = require("src/app/renderer/RendererService")
local ImageFactory = require("src/app/factories/ImageFactory")
local AnimationService = require("src/app/animation/AnimationService")
local AudioFactory = require("src/app/factories/AudioFactory")
local AudioService = require("src/app/audio/AudioService")

local Game = require("src/core/Game")

function Components:new()
    local this = {
        keyboardService = KeyboardService:new(),
        rendererService = RendererService:new(),
        imageFactory = ImageFactory:new(),
        animationService = AnimationService:new(),
        audioService = AudioService:new(AudioFactory:new())
    }

    this.game = Game:new(
            this.keyboardService,
            this.rendererService,
            this.imageFactory,  -- fixme pas de factory dans le game (services uniquement)
            this.animationService,
            this.audioService
    )

    return this
end

return Components