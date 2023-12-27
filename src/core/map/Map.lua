local Map = {}

local ElementDestructible = require("src/core/elements/ElementDestructible")
local ElementType = require("src/core/elements/ElementType")
local TileType = require("src/core/map/TileType")
local Vecteur2D = require("src/models/math/Vecteur2D")

function Map:new(
        size --[[Table : <x: Int, y: Int>]],
        tileSize --[[Int]],
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
        for _ = 1, nbRow do
            local cols = {}
            for _ = 1, nbCol do
                table.insert(cols, TileType.HERBE)
            end
            table.insert(rows, cols)
        end
        return rows
    end
    function loadForet(nbRow, nbCol, ptileSize)
        local rows = {}
        for r = 0, nbRow - 1 do
            local cols = {}
            for c = 0, nbCol - 1 do
                if randomService:generateFromRange(1, 3) == 3 then
                    table.insert(
                            cols,
                            ElementDestructible:new(
                                    Vecteur2D:new(c * ptileSize, r * ptileSize),
                                    ElementType.ARBRE,
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
    this.firstLayout = loadForet(size.y, size.x, this.tileSize)
    this.lights = {}
    table.insert(
            this.lights,
            {
                x = 32 * 5,
                y = 32 * 5
            }
    )

    function this:getCoordTile(position)
        local row = math.floor(position.y / self.tileSize)
        local col = math.floor(position.x / self.tileSize)
        return {x = col, y = row}
    end

    function this:getTileAt(position)
        local coord = self:getCoordTile(position)
        if coord.x < 0 or coord.x > #self.tilemap[1] - 1 or coord.y < 0 or coord.y > #self.tilemap - 1 then
            return -1
        else
            return self.tilemap[coord.y + 1][coord.x + 1]
        end
    end

    return this
end

return Map