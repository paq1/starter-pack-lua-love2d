local CanvasService = {}

local TileType = require("src/core/map/TileType")

function CanvasService:new(
        imageFactory --[[ImageFactory]]
)
    local this = {
        imageFactory = imageFactory
    }

    function this:fromMapToTilemapCanvas(map --[[Map]])
        local pixelMapWidth = (#map.tilemap[1] + 1) * map.tileSize
        local pixelMapHeight = (#map.tilemap + 1) * map.tileSize

        local canvas = love.graphics.newCanvas(pixelMapWidth, pixelMapHeight)

        love.graphics.setCanvas(canvas)

            for r = 0, #map.tilemap - 1 do
                for c = 0, #map.tilemap[r + 1] - 1 do
                    local tile = map.tilemap[r + 1][c + 1]
                    if tile.tileType == TileType.HERBE then
                        love.graphics.draw(
                                self.imageFactory.tileForestSpriteSheetImage,
                                self.imageFactory.tileForestSpriteSheet.quads[tile.side],
                                c * map.tileSize,
                                r * map.tileSize
                        )
                    end
                end
            end

        love.graphics.setCanvas()

        return canvas
    end

    return this
end

return CanvasService