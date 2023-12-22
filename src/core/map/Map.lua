local Map = {}

local ElementDestructible = require("src/core/map/element/ElementDestructible")
local Vecteur2D = require("src/models/math/Vecteur2D")

function Map:new(
        size,
        tileSize,
        randomService --[[RandomService]]
)

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
    function loadForet(nbRow, nbCol, ptileSize)
        local rows = {}
        for r = 1, nbRow do
            local cols = {}
            for c = 1, nbCol do
                if randomService:generateFromRange(1, 3) == 3 then
                    table.insert(
                            cols,
                            ElementDestructible:new(
                                    Vecteur2D:new(c * ptileSize, r * ptileSize),
                                    "arbre",
                                    100,
                                    100
                            )
                    )
                else
                    table.insert(
                            cols,
                            {}
                    )
                end
            end
            table.insert(rows, cols)
        end
        return rows
    end
    this.tilemap = loadMap(size.y, size.x)
    this.arbres  = loadForet(size.y, size.x, this.tileSize)

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