local PlayerService = {}

local Player = require("src/core/actor/player/Player")

function PlayerService:new(
        inputService --[[KeyboardService]],
        animationPlayer --[[Animation]]
)
    local positionInitial = {
        x = 300,
        y = 150
    }
    local size = {
        x = 32,
        y = 32
    }
    local this = {
        inputService = inputService,
        sideIndex = 0,
        anim = animationPlayer,
        player = Player:new(positionInitial, size)
    }

    function this:update(
            dt,
            cameraService --[[CameraService]]
    )
        self.anim:update(dt, false)

        self:updateDeplacement(dt)

        cameraService:updatePosition(self.player.position)
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

    function this:draw(
            cameraService --[[CameraService]]
    )

        local drawPos = {
            x = self.player.position.x - self.player.size.x / 2.0 - cameraService.position.x,
            y = self.player.position.y - self.player.size.y / 2.0 - cameraService.position.y
        }

        self.anim:draw(self.sideIndex, 4, drawPos)
    end

    return this
end

return PlayerService