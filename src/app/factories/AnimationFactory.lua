local AnimationFactory = {}

function AnimationFactory:new(
        animationService --[[AnimationService]],
        imageFactory --[[ImageFactory]]
)
    local this = {
        torcheAnimation = animationService:createHorizontalAnimation(
                imageFactory.torcheSpritesheet, 32, 32, 1.0
        )
    }

    return this
end

return AnimationFactory