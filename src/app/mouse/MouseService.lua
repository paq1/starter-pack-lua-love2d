local MouseService = {}

function MouseService:new(
        imageFactory --[[ImageFactory]]
)
    local this = {}

    function this:getPosition()
        return love.mouse.getPosition()
    end

    function this:setVisibility(val)
        love.mouse.setVisible(val)
    end

    function this:leftButtonIsPressed()
        return love.mouse.isDown(1)
    end

    function this:rightButtonIsPressed()
        return love.mouse.isDown(2)
    end

    function this:middleButtonIsPressed()
        return love.mouse.isDown(3)
    end

    function this:draw()
        local x, y = this:getPosition()
        local imageCursorSize = 32.0
        local offsetMouse = imageCursorSize / 2.0
        love.graphics.draw(imageFactory.cursorTarget, x - offsetMouse, y - offsetMouse)
    end

    return this
end

return MouseService