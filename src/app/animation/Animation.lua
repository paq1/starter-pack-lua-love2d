local Animation = {}

function Animation:new(image, width, height, duration)

    local this = {
        spriteSheet = image,
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

    function this:draw(side_index, nb_side, position)
        local spriteNum = math.floor(self.currentTime / self.duration * nb_side) + 1
        love.graphics.draw(self.spriteSheet, self.quads[spriteNum * nb_side - side_index], position.x, position.y, 0, 2)
    end

    return this
end

return Animation