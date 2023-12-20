local AnimationService = {}

local Animation = require("src/app/animation/Animation")

function AnimationService:new()
    local this = {}

    function this:create(image, width, height, duration)
        return Animation:new(image, width, height, duration)
    end

    return this
end

return AnimationService