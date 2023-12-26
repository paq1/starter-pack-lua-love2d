local WindowService = {}

function WindowService:new()
    local this = {}

    function this:getSize()
        return {
            width = love.graphics.getWidth(),
            height = love.graphics.getHeight()
        }
    end

    function this:getCenter()
        local size = self:getSize()
        return {
            x = size.width / 2.0,
            y = size.height / 2.0
        }
    end

    return this
end

return WindowService