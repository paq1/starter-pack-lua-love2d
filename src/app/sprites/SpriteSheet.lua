local SpriteSheet = {}

function SpriteSheet:new(
        image,
        sizeOneElement --[[{width: number, height: number}]]
)
    local this = {
        image = image,
        quads = {}
    }

    local width, height = sizeOneElement.width, sizeOneElement.height

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(this.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    return this
end

return SpriteSheet