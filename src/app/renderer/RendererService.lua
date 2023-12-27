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

    function this:print(text, at, scale)
        at = at or {x = 0, y = 0}
        scale = scale or 1
        love.graphics.print(text, at.x, at. y, 0, scale, scale)
    end

    return this
end

return RendererService