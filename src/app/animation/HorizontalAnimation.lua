local HorizontalAnimation = {}

function HorizontalAnimation:new(image, width, height, duration)

    local nbDifferentSpritesType = image:getHeight() / height
    local nbAnimations = image:getWidth() / width

    local this = {
        spriteSheet = image,
        nbDifferentSpritesType = nbDifferentSpritesType,
        nbAnimations = nbAnimations,
        quads = {},
        duration = duration or 1,
        currentTime = 0
    }
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(this.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    function this:update(dt, reset)
        reset = reset or false

        if reset then
            self.currentTime = 0.0
        end

        self.currentTime = self.currentTime + dt
        if self.currentTime >= self.duration then
            self.currentTime = self.currentTime - self.duration
        end
    end

    function this:draw(side_index, position, scale)
        scale = scale or 1
        local spriteNum = math.floor(self.currentTime / self.duration * self.nbAnimations) + 1
        local quadsIndex = spriteNum + (side_index * self.nbAnimations)
        love.graphics.draw(self.spriteSheet, self.quads[quadsIndex], position.x, position.y, 0, scale)
    end

    return this
end

return HorizontalAnimation