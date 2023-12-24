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

    function this:actionKeyIsDown()
        return love.keyboard.isDown("e")
    end

    function this:ctrlIsDown()
        return love.keyboard.isDown("lctrl")
    end

    return this
end

return KeyboardService
