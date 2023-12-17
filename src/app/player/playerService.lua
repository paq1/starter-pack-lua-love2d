local PlayerService = {}

local playerModule = require("src/core/actor/player/player")

function PlayerService:new(
        inputService --[[KeyboardService]],
        animationPlayer --[[Animation]]
)
    local positionInitial = {
        x = 0,
        y = 0
    }
    local size = {
        x = 32,
        y = 32
    }
    local this = {
        inputService = inputService,
        sideIndex = 0,
        anim = animationPlayer,
        player = playerModule.new(positionInitial, size)
    }

    function this:update(dt)
        self.anim:update(dt, false)

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
        self.anim:draw(self.sideIndex, 4, self.player.position)
    end

    return this
end

return PlayerService