local CanvasService = {}

function CanvasService:new(
        imageFactory --[[ImageFactory]]
)
    local this = {
        imageFactory = imageFactory
    }

    function this:fromMapToTilemapCanvas(map --[[Map]])
        local pixelMapWidth = #map.tilemap[1] * map.tileSize
        local pixelMapHeight = #map.tilemap * map.tileSize

        -- imageFactory.tileGrassImage
        local canvas = love.graphics.newCanvas(pixelMapWidth, pixelMapHeight)
        local oldCanvas = love.graphics.getCanvas()

        love.graphics.setCanvas(canvas)

            for l = 1, #map.tilemap do
                for c = 1, #map.tilemap[1] do
                    love.graphics.draw(self.imageFactory.tileGrassImage, c * map.tileSize, l * map.tileSize)
                end
            end

        love.graphics.setCanvas(oldCanvas)

        return canvas
    end

    return this
end

return CanvasService