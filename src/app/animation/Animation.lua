local Animation = {}

function Animation:new(image, width, height, duration)

    local nbAnimations = image:getHeight() / height
    local nbDifferentSpritesType = image:getWidth() / width

    local this = {
        spriteSheet = image,
        quads = {},
        nbDifferentSpritesType = nbDifferentSpritesType,
        nbAnimations = nbAnimations,
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

    function this:draw(side_index, position)
        local spriteNum = math.floor(self.currentTime / self.duration * self.nbAnimations) + 1
        local spriteIndex = spriteNum * self.nbAnimations - side_index
        if spriteIndex > #self.quads then
            spriteIndex = #self.quads
        end
        love.graphics.draw(self.spriteSheet, self.quads[spriteIndex], position.x, position.y, 0, 2)
    end

    return this
end

return Animation