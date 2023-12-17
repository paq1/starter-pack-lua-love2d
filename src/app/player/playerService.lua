local PlayerService = {}

local playerModule = require("src/core/actor/player/player")
local animation = require("src/app/animation")

function PlayerService:new(
        inputService --[[KeyboardService]]
)
    local positionInitial = {
        x = 0,
        y = 0
    }
    local size = {
        x = 32,
        y = 32
    }
    local snakeSpritesheet = love.graphics.newImage("assets/sprites/actor/Snake.png")
    local this = {
        inputService = inputService,
        sideIndex = 0,
        anim = animation.newAnimation(snakeSpritesheet, 16, 16, 1),
        player = playerModule.new(positionInitial, size)
    }

    function this:update(dt)
        animation.update(dt, self.anim, false)

        self:updateDeplacement(dt)
    end

    function this:updateDeplacement(dt, vitesse)
        vitesse = vitesse or 200.0

        if self.inputService:upIsDown() then
            self.sideIndex = 2
            self.player.position.y = self.player.position.y - vitesse * dt
        end

        if self.inputService:rightIsDown() then
            self.sideIndex = 0
            self.player.position.x = self.player.position.x + vitesse * dt
        end

        if self.inputService:downIsDown() then
            self.sideIndex = 3
            self.player.position.y = self.player.position.y + vitesse * dt
        end

        if self.inputService:leftIsDown() then
            self.sideIndex = 1
            self.player.position.x = self.player.position.x - vitesse * dt
        end
    end

    function this:draw()
        animation.draw(self.anim, self.sideIndex, 4, self.player.position)
    end

    return this
end

return PlayerService