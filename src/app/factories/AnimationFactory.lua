local AnimationFactory = {}

function AnimationFactory:new(
        animationService --[[AnimationService]],
        imageFactory --[[ImageFactory]]
)
    local this = {
        torcheAnimation = animationService:createHorizontalAnimation(
                imageFactory.torcheSpritesheet, 32, 32, 1.0
        ),
        indicationAnimation = animationService:createHorizontalAnimation(
                imageFactory.indicationSpriteSheetImage, 32, 32, 0.5
        )
    }

    return this
end

return AnimationFactory