local Map = {}

local ElementType = require("src/core/elements/ElementType")
local TileType = require("src/core/map/TileType")
local Vecteur2D = require("src/models/math/Vecteur2D")
local TreeCategory = require("src/core/map/TreeCategory")
local ConfigMap = require("src/core/map/ConfigMap")

function Map:new(
        size --[[Table : <x: Int, y: Int>]],
        tileSize --[[Int]],
        randomService --[[RandomService]],
        perlinNoiseService --[[PerlinNoiseService]]
)

    size = size or {
        x = 10,
        y = 10
    }

    local this = {
        size = size,
        tileSize = tileSize,
        defaultLightPower = ConfigMap.torchBasePower,
        randomService = randomService,
        perlinNoiseService = perlinNoiseService
    }

    function this:loadMap()
        local nbRow, nbCol = self.size.y, self.size.x

        local rows = {}
        for row = 1, nbRow do
            local cols = {}
            for col = 1, nbCol do
                local noise = self.perlinNoiseService:noise(col + self.randomService:random(), row + self.randomService:random())
                noise = 2 -- todo commenter pour tester les collision avec les tiles Empty
                if noise > 0.2 then
                    table.insert(cols, {
                        tileType = TileType.HERBE,
                        side = 5
                    })
                else
                    table.insert(cols, {
                        tileType = TileType.EMPTY
                    })
                end

            end
            table.insert(rows, cols)
        end

        for row = 1, #rows do
            local cols = {}
            for col = 1, #rows[row] do

                local tile = rows[row][col]

                if tile.tileType == TileType.HERBE then
                    if row == 1 and col == 1 then
                        rows[row][col] = {
                            tileType = TileType.HERBE,
                            side = 1
                        }
                    elseif row == 1 and col == #rows[col] then
                        rows[row][col] = {
                            tileType = TileType.HERBE,
                            side = 3
                        }
                    elseif row == 1 then
                        rows[row][col] = {
                            tileType = TileType.HERBE,
                            side = 2
                        }
                    elseif row == #rows and col == 1 then
                        rows[row][col] = {
                            tileType = TileType.HERBE,
                            side = 11
                        }
                    elseif row == #rows and col == #rows[col] then
                        rows[row][col] = {
                            tileType = TileType.HERBE,
                            side = 13
                        }
                    elseif col == 1 then
                        rows[row][col] = {
                            tileType = TileType.HERBE,
                            side = 6
                        }
                    elseif col == #rows[row] then
                        rows[row][col] = {
                            tileType = TileType.HERBE,
                            side = 8
                        }
                    elseif row == #rows then
                        rows[row][col] = {
                            tileType = TileType.HERBE,
                            side = 12
                        }

                    elseif rows[row][col].tileType == TileType.HERBE then

                        local tileUpIsEmpty = rows[row - 1][col].tileType == TileType.EMPTY
                        local tileRightIsEmpty = rows[row][col + 1].tileType == TileType.EMPTY
                        local tileDownIsEmpty = rows[row + 1][col].tileType == TileType.EMPTY
                        local tileLeftIsEmpty = rows[row][col - 1].tileType == TileType.EMPTY

                        if tileUpIsEmpty and not tileRightIsEmpty and not tileLeftIsEmpty and not tileDownIsEmpty then
                            rows[row][col] = {
                                tileType = TileType.HERBE,
                                side = 2
                            }
                        elseif tileUpIsEmpty and tileDownIsEmpty and not tileRightIsEmpty and not tileLeftIsEmpty then
                            rows[row][col] = {
                                tileType = TileType.HERBE,
                                side = 10
                            }
                        elseif tileRightIsEmpty then
                            rows[row][col] = {
                                tileType = TileType.HERBE,
                                side = 8
                            }
                        elseif tileDownIsEmpty then
                            rows[row][col] = {
                                tileType = TileType.HERBE,
                                side = 12
                            }
                        elseif tileLeftIsEmpty then
                            rows[row][col] = {
                                tileType = TileType.HERBE,
                                side = 6
                            }
                        else
                            rows[row][col] = {
                                tileType = TileType.HERBE,
                                side = 7
                            }
                        end

                    end
                end

            end
        end


        return rows
    end


    function this:loadForest()

        local nbRow, nbCol = self.size.y, self.size.x

        local rows = {}

        for r = 0, nbRow - 1 do
            local cols = {}
            for c = 0, nbCol - 1 do
                local randomTypeArbre = randomService:generateFromRange(1, 3)

                if randomService:generateFromRange(1, 3) == 3 and self.tilemap[r + 1][c + 1].tileType == TileType.HERBE then
                    local arbreType = TreeCategory.BASIQUE

                    if randomTypeArbre == 2 then
                        arbreType = TreeCategory.SAPIN
                    end

                    table.insert(
                            cols,
                            {
                                position = Vecteur2D:new(c * self.tileSize, r * self.tileSize),
                                elementType = ElementType.ARBRE,
                                vie = 100,
                                vieMax = 100,
                                arbreType = arbreType
                            }
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
    this.tilemap = this:loadMap()

    this.firstLayout = this:loadForest()
    this.lights = {
        {
            position = {
                x = (this.tileSize * 5) + this.tileSize / 2,
                y = (this.tileSize * 5) + this.tileSize / 2
            },
            power = this.defaultLightPower
        },
        {
            position = {
                x = (this.tileSize * 2) + this.tileSize / 2,
                y = (this.tileSize * 25) + this.tileSize / 2
            },
            power = this.defaultLightPower
        },
        {
            position = {
                x = (this.tileSize * 0) + this.tileSize / 2,
                y = (this.tileSize * 0) + this.tileSize / 2
            },
            power = this.defaultLightPower
        }
    }

    function this:getCoordTile(position)
        local row = math.floor(position.y / self.tileSize)
        local col = math.floor(position.x / self.tileSize)
        return {x = col, y = row}
    end

    function this:lightExist(position)
        for _, element in pairs(self.lights) do
            if element.position.x == position.x and element.position.y == position.y then
                return true
            end
        end
        return false
    end

    function this:addLight(position, power)
        power = power or this.defaultLightPower
        if not this:lightExist(position) and #self.lights < 256 then
            table.insert(self.lights, {
                position = { x = position.x, y = position.y },
                power = power
            })
        end
    end

    function this:getTileAt(position)
        local coord = self:getCoordTile(position)
        if coord.x < 0 or coord.x > #self.tilemap[1] - 1 or coord.y < 0 or coord.y > #self.tilemap - 1 then
            return { tileType = TileType.EMPTY }
        else
            return self.tilemap[coord.y + 1][coord.x + 1]
        end
    end

    return this
end

return Map