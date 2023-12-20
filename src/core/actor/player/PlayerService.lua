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
            cameraService --[[CameraService]],
            map --[[Map]]
    )
        self.anim:update(dt, false)

        self:updateDeplacement(dt, 200, map)

        cameraService:updatePosition(self.player.position)
    end

    function this:updateDeplacement(dt, vitesse, map --[[Map]])
        vitesse = vitesse or 200.0

        if self.inputService:upIsDown() then
            self.sideIndex = 2
            local nouvellePosition = {
                x = self.player.position.x,
                y = self.player.position.y - vitesse * dt
            }
            local tile = map:getTileAt(nouvellePosition)
            if tile ~= -1 then
                self.player.position = nouvellePosition
            end
        end

        if self.inputService:rightIsDown() then
            self.sideIndex = 0
            local nouvellePosition = {
                x = self.player.position.x + vitesse * dt,
                y = self.player.position.y
            }
            local tile = map:getTileAt(nouvellePosition)
            if tile ~= -1 then
                self.player.position = nouvellePosition
            end
        end

        if self.inputService:downIsDown() then
            self.sideIndex = 3
            local nouvellePosition = {
                x = self.player.position.x,
                y = self.player.position.y + vitesse * dt
            }
            local tile = map:getTileAt(nouvellePosition)
            if tile ~= -1 then
                self.player.position = nouvellePosition
            end
        end

        if self.inputService:leftIsDown() then
            self.sideIndex = 1
            local nouvellePosition = {
                x = self.player.position.x - vitesse * dt,
                y = self.player.position.y
            }
            local tile = map:getTileAt(nouvellePosition)
            if tile ~= -1 then
                self.player.position = nouvellePosition
            end
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