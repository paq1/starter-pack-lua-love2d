local DynamicTextAppearDisappear = {}

function DynamicTextAppearDisappear:new(text, durationPerLetter, timeAfterAppear, timeAfterDisappear)
    timeAfterAppear = timeAfterAppear or 3
    timeAfterDisappear = timeAfterDisappear or 3
    local this = {
        finalText = text,
        currentText = "",
        timer = 0.0,
        durationPerLetter = durationPerLetter,
        timeAfterAppear = timeAfterDisappear,
        timeAfterDisappear = timeAfterDisappear,
        timerAppearPart = 0.0,
        readyToAppear = true,
        readyToDisappear = false
    }

    function this:update(dt)
        self:updateDisappear(dt)

        if self.readyToAppear then
            self.timer = self.timer + dt
            if self.timer > self.durationPerLetter then
                self.timer = self.timer - self.durationPerLetter
                local newLetter = string.sub(self.finalText, #self.currentText + 1, #self.currentText + 1)
                self.currentText = self.currentText .. newLetter
            end
        end

        if self.readyToDisappear then
            self.timer = self.timer + dt
            if self.timer > self.durationPerLetter then
                self.timer = self.timer - self.durationPerLetter
                self.currentText = string.sub(self.currentText, 1, #self.currentText - 1)
            end
        end
    end

    function this:updateDisappear(dt)
        if #self.finalText == #self.currentText then
            self.readyToAppear = false

            self.timerAppearPart = self.timerAppearPart + dt
            if self.timerAppearPart > self.timeAfterAppear then
                self.readyToDisappear = true
                self.timerAppearPart = 0.0
            end
        end

        if #self.currentText == 0 then
            self.readyToDisappear = false

            self.timerAppearPart = self.timerAppearPart + dt
            if self.timerAppearPart > self.timeAfterDisappear then
                self.readyToAppear = true
                self.timerAppearPart = 0.0
            end
        end
    end

    return this
end

return DynamicTextAppearDisappear