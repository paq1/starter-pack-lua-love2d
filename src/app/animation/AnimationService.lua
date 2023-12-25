local AnimationService = {}

local Animation = require("src/app/animation/Animation")
local HorizontalAnimation = require("src/app/animation/HorizontalAnimation")

function AnimationService:new()
    local this = {}

    function this:create(image, width, height, duration)
        return Animation:new(image, width, height, duration)
    end

    function this:createHorizontalAnimation(image, width, height, duration)
        return HorizontalAnimation:new(image, width, height, duration)
    end

    return this
end

return AnimationService