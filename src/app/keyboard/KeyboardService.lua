local KeyboardService = {}

function KeyboardService:new()

    local this = {}

    function this:upIsDown()
        return love.keyboard.isDown("z")
    end
    function this:rightIsDown()
        return love.keyboard.isDown("d")
    end
    function this:downIsDown()
        return love.keyboard.isDown("s")
    end
    function this:leftIsDown()
        return love.keyboard.isDown("q")
    end

    function this:actionKeyIsDown()
        return love.keyboard.isDown("e")
    end

    return this
end

return KeyboardService