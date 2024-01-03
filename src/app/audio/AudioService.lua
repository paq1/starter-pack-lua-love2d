local AudioService = {}

function AudioService:new(
        audioFactory --[[AudioFactory]]
)

    local this = {}

    this.stepSongCanBeUsed = false
    this.birdSoundEffect = false

    function this:updateStep()
        if not audioFactory.stepDirt:isPlaying() and self.stepSongCanBeUsed then
            audioFactory.stepDirt:setPitch(1.5)
            audioFactory.stepDirt:play()
        end
    end

    function this:updateBirdSound()
        if not audioFactory.bird:isPlaying() and self.birdSoundEffect then
            audioFactory.bird:play()
        end
    end

    function this:update()
        self:updateStep()
        self:updateBirdSound()
    end

    function this:setStepSongStatus(val --[[Boolean]])
        self.stepSongCanBeUsed = val
    end

    function this:setBirdSoundEffectStatus(val --[[Boolean]])
        self.birdSoundEffect = val
    end

    return this
end

return AudioService