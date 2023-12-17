local RendererService = {}

function RendererService:new()
    local this = {}

    function this:render(image, at)

        at = at or {x = 0, y = 0}
        love.graphics.draw(image, at.x, at. y)

    end

    return this
end

return RendererService