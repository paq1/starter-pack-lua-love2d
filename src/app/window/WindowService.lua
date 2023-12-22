local WindowService = {}

function WindowService:new()
    local this = {}

    function this:getSize()
        return {
            width = love.graphics.getWidth(),
            height = love.graphics.getHeight()
        }
    end

    return this
end

return WindowService