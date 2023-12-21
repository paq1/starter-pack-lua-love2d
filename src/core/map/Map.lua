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
    function loadForet(nbRow, nbCol)
        local rows = {}
        for r = 1, nbRow do
            local cols = {}
            for c = 1, nbCol do
                if math.fmod(c, 3) == 0 and math.fmod(r, 2) == 0 then
                    table.insert(cols, 1)
                else
                    table.insert(cols, 0)
                end
            end
            table.insert(rows, cols)
        end
        return rows
    end
    this.tilemap = loadMap(size.y, size.x)
    this.arbres  = loadForet(size.y, size.x)

    function this:getCoordTile(position)
        local row = math.floor(position.y / self.tileSize)
        local col = math.floor(position.x / self.tileSize)
        return {x = col, y = row}
    end

    function this:getTileAt(position)
        local coord = self:getCoordTile(position)
        if coord.x < 1 or coord.x > #self.tilemap[1] or coord.y < 1 or coord.y > #self.tilemap then
            return -1
        else
            return self.tilemap[coord.y][coord.x]
        end
    end

    return this
end

return Map