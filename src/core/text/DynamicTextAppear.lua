local DynamicTextAppear = {}

function DynamicTextAppear:new(text, durationPerLetter, timeAfterAppear, timeAfterDisappear)
    timeAfterAppear = timeAfterAppear or 3
    timeAfterDisappear = timeAfterDisappear or 3
    local this = {
        finalText = text,
        currentText = "",
        timer = 0.0,
        durationPerLetter = durationPerLetter
    }

    function this:update(dt)

        if #self.finalText ~= #self.currentText then
            self.timer = self.timer + dt
            if self.timer > self.durationPerLetter then
                self.timer = self.timer - self.durationPerLetter
                local newLetter = string.sub(self.finalText, #self.currentText + 1, #self.currentText + 1)
                self.currentText = self.currentText .. newLetter
            end
        end
    end

    return this
end

return DynamicTextAppear