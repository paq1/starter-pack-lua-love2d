local RendererService = {}

function RendererService:new()
    local this = {}

    function this:setBlendMode()
    end

    function this:render(image, at, scale)
        scale = scale or 1
        at = at or {x = 0, y = 0}
        love.graphics.draw(image, at.x, at. y, 0, scale, scale)
    end

    function this:print(text, at, scale, color)
        at = at or {x = 0, y = 0}
        local defaultColor = {r = 1, g = 1, b = 1, a = 1}
        color = color or defaultColor
        scale = scale or 1
        love.graphics.setColor(color.r, color.g, color.b, color.a)
        love.graphics.print(text, at.x, at. y, 0, scale, scale)
        love.graphics.setColor(defaultColor.r, defaultColor.g, defaultColor.b, defaultColor.a)
    end

    return this
end

return RendererService