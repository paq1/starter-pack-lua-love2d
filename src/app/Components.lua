local Components = {}

local KeyboardService = require("src/app/keyboard/KeyboardService")
local MouseService = require("src/app/mouse/MouseService")
local RendererService = require("src/app/renderer/RendererService")
local ImageFactory = require("src/app/factories/ImageFactory")
local AnimationService = require("src/app/animation/AnimationService")
local AudioFactory = require("src/app/factories/AudioFactory")
local AudioService = require("src/app/audio/AudioService")
local RandomService = require("src/app/random/RandomService")
local WindowService = require("src/app/window/WindowService")
local CanvasService = require("src/app/canvas/CanvasService")
local LightService = require("src/app/lights/LightService")
local AnimationFactory = require("src/app/factories/AnimationFactory")
local PerlinNoiseService = require("src/app/utils/noise/PerlinNoiseService")

local ScenesService = require("src/core/scenes/ScenesService")

function Components:new()
    local this = {
        keyboardService = KeyboardService:new(),
        rendererService = RendererService:new(),
        imageFactory = ImageFactory:new(),
        animationService = AnimationService:new(),
        audioService = AudioService:new(AudioFactory:new()),
        randomService = RandomService:new(1234),
        windowService = WindowService:new()
    }
    this.mouseService = MouseService:new(this.imageFactory)
    this.canvasService = CanvasService:new(this.imageFactory)
    this.lightService = LightService:new()
    this.animationFactory = AnimationFactory:new(this.animationService, this.imageFactory)
    this.perlinNoiseService = PerlinNoiseService:new()

    this.scenesService = ScenesService:new(
            this.keyboardService,
            this.rendererService,
            this.imageFactory,
            this.animationService,
            this.audioService,
            this.randomService,
            this.windowService,
            this.mouseService,
            this.canvasService,
            this.lightService,
            this.animationFactory,
            this.perlinNoiseService
    )

    return this
end

return Components