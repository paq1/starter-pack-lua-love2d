local MapService = {}

function MapService:new(
        map --[[Map]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]]
)
    local this = {
        map = map,
        imageFactory = imageFactory,
        rendererService = rendererService
    }

    function this:render()
        for l = 0, self.map.size.y do
            for c = 0, self.map.size.x do
                self.rendererService:render(self.imageFactory.tileGrassImage, { x = c * 32, y = l * 32 })
            end
        end
    end

    return this
end

return MapService