local PlayerService = {}

local Player = require("src/core/actor/player/Player")

function PlayerService:new(
        inputService --[[KeyboardService]],
        animation --[[Animation]],
        audioService --[[AudioService]]
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
        anim = animation,
        audioService = audioService,
        player = Player:new(positionInitial, size)
    }

    function this:update(
            dt,
            cameraService --[[CameraService]],
            map --[[Map]]
    )
        self.anim:update(dt, false)

        local seDeplace = self:updateDeplacement(dt, 200, map)

        if seDeplace then
            self.audioService:setStepSongStatus(true)
        else
            self.audioService:setStepSongStatus(false)
        end

        cameraService:updatePosition(self.player.position)
    end

    function this:updateDeplacement(dt, vitesse, map --[[Map]])
        vitesse = vitesse or 200.0
        local seDeplace = false

        if self.inputService:upIsDown() then
            self.sideIndex = 2
            local nouvellePosition = {
                x = self.player.position.x,
                y = self.player.position.y - vitesse * dt
            }
            local tile = map:getTileAt(nouvellePosition)
            if tile ~= -1 then
                self.player.position = nouvellePosition
                seDeplace = true
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
                seDeplace = true
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
                seDeplace = true
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
                seDeplace = true
            end
        end

        return seDeplace
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