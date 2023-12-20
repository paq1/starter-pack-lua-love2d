local ImageFactory = {}

function ImageFactory:new()
    local this = {
        tileGrassImage = love.graphics.newImage("assets/sprites/map/grass.png"),
        snakeSpritesheet = love.graphics.newImage("assets/sprites/actor/Snake.png")
    }

    return this
end

return ImageFactory