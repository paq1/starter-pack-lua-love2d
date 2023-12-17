local Map = {}

function Map:new(size, tileSize)

    size = size or {
        x = 10,
        y = 10
    }

    local this = {
        size = size,
        tileSize = tileSize
    }

    function this:getCoordTile(position)
        local row = math.floor(position.y / self.tileSize)
        local col = math.floor(position.x / self.tileSize)
        return {x = col, y = row}
    end

    return this
end

return Map