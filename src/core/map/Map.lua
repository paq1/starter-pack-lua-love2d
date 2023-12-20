local Map = {}

function Map:new(size, tileSize)

    size = size or {
        x = 10,
        y = 10
    }

    local this = {
        tileSize = tileSize
    }

    function loadMap(nbRow, nbCol)
        local rows = {}
        for r = 1, nbRow do
            local cols = {}
            for c = 1, nbCol do
                table.insert(cols, 1)
            end
            table.insert(rows, cols)
        end
        return rows
    end
    this.tilemap = loadMap(size.y, size.x)

    function this:getCoordTile(position)
        local row = math.floor(position.y / self.tileSize)
        local col = math.floor(position.x / self.tileSize)
        return {x = col, y = row}
    end

    return this
end

return Map