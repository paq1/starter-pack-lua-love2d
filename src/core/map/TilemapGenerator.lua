local TilemapGenerator = {}

local TileType = require("src/core/map/TileType")

function TilemapGenerator.generateTilemap(
        size --[[Table : <x: Int, y: Int>]],
        randomService --[[RandomService]],
        perlinNoiseService --[[PerlinNoiseService]]
)
    local tilemap = {}
    local nbRow, nbCol = size.y, size.x

    for row = 1, nbRow do
        local cols = {}
        for col = 1, nbCol do
            local noise = perlinNoiseService:noise(col + randomService:random(), row + randomService:random())
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
        table.insert(tilemap, cols)
    end

    for row = 1, #tilemap do
        local cols = {}
        for col = 1, #tilemap[row] do

            local tile = tilemap[row][col]

            if tile.tileType == TileType.HERBE then
                if row == 1 and col == 1 then
                    tilemap[row][col] = {
                        tileType = TileType.HERBE,
                        side = 1
                    }
                elseif row == 1 and col == #tilemap[col] then
                    tilemap[row][col] = {
                        tileType = TileType.HERBE,
                        side = 3
                    }
                elseif row == 1 then
                    tilemap[row][col] = {
                        tileType = TileType.HERBE,
                        side = 2
                    }
                elseif row == #tilemap and col == 1 then
                    tilemap[row][col] = {
                        tileType = TileType.HERBE,
                        side = 11
                    }
                elseif row == #tilemap and col == #tilemap[col] then
                    tilemap[row][col] = {
                        tileType = TileType.HERBE,
                        side = 13
                    }
                elseif col == 1 then
                    tilemap[row][col] = {
                        tileType = TileType.HERBE,
                        side = 6
                    }
                elseif col == #tilemap[row] then
                    tilemap[row][col] = {
                        tileType = TileType.HERBE,
                        side = 8
                    }
                elseif row == #tilemap then
                    tilemap[row][col] = {
                        tileType = TileType.HERBE,
                        side = 12
                    }

                elseif tilemap[row][col].tileType == TileType.HERBE then

                    local tileUpIsEmpty = tilemap[row - 1][col].tileType == TileType.EMPTY
                    local tileRightIsEmpty = tilemap[row][col + 1].tileType == TileType.EMPTY
                    local tileDownIsEmpty = tilemap[row + 1][col].tileType == TileType.EMPTY
                    local tileLeftIsEmpty = tilemap[row][col - 1].tileType == TileType.EMPTY

                    if tileUpIsEmpty and not tileRightIsEmpty and not tileLeftIsEmpty and not tileDownIsEmpty then
                        tilemap[row][col] = {
                            tileType = TileType.HERBE,
                            side = 2
                        }
                    elseif tileUpIsEmpty and tileDownIsEmpty and not tileRightIsEmpty and not tileLeftIsEmpty then
                        tilemap[row][col] = {
                            tileType = TileType.HERBE,
                            side = 10
                        }
                    elseif tileRightIsEmpty then
                        tilemap[row][col] = {
                            tileType = TileType.HERBE,
                            side = 8
                        }
                    elseif tileDownIsEmpty then
                        tilemap[row][col] = {
                            tileType = TileType.HERBE,
                            side = 12
                        }
                    elseif tileLeftIsEmpty then
                        tilemap[row][col] = {
                            tileType = TileType.HERBE,
                            side = 6
                        }
                    else
                        tilemap[row][col] = {
                            tileType = TileType.HERBE,
                            side = 7
                        }
                    end

                end
            end

        end
    end

    return tilemap
end

return TilemapGenerator