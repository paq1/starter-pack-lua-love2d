local AudioService = {}

function AudioService:new(
        audioFactory --[[AudioFactory]]
)

    local this = {
        audioFactory = audioFactory,
    }

    this.stepSongCanBeUsed = false
    this.birdSoundEffect = false

    function this:updateStep()
        if not self.audioFactory.stepDirt:isPlaying() and self.stepSongCanBeUsed then
            self.audioFactory.stepDirt:setPitch(1.5)
            self.audioFactory.stepDirt:play()
        end
    end

    function this:updateBirdSound()
        if not self.audioFactory.bird:isPlaying() and self.birdSoundEffect then
            self.audioFactory.bird:play()
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