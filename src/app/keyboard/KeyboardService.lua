local KeyboardService = {}

function KeyboardService:new()

    local this = {}

    function this:upIsDown()
        return love.keyboard.isDown("z") or love.keyboard.isDown("up")
    end

    function this:rightIsDown()
        return love.keyboard.isDown("d") or love.keyboard.isDown("right")
    end

    function this:downIsDown()
        return love.keyboard.isDown("s") or love.keyboard.isDown("down")
    end

    function this:leftIsDown()
        return love.keyboard.isDown("q") or love.keyboard.isDown("left")
    end

    function this:spaceIsDown()
        return love.keyboard.isDown("space")
    end

    function this:actionKeyIsDown()
        return love.keyboard.isDown("e")
    end

    function this:ctrlIsDown()
        return love.keyboard.isDown("lctrl")
    end

    function this:f1IsDown()
        return love.keyboard.isDown("f1")
    end

    function this:slotItem1IsDown()
        return love.keyboard.isDown("kp1")
    end
    function this:slotItem2IsDown()
        return love.keyboard.isDown("kp2")
    end
    function this:slotItem3IsDown()
        return love.keyboard.isDown("kp3")
    end
    function this:slotItem4IsDown()
        return love.keyboard.isDown("kp4")
    end
    function this:slotItem5IsDown()
        return love.keyboard.isDown("kp5")
    end

    return this
end

return KeyboardService
