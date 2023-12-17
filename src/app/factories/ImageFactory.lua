local ImageFactory = {}

function ImageFactory:new()
    local this = {
        tileGrassImage = love.graphics.newImage("assets/sprites/map/grass.png")
    }

    return this
end

return ImageFactory