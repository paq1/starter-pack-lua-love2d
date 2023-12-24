local PlayerService = {}

function PlayerService:new(
        inputService --[[KeyboardService]],
        animation --[[Animation]],
        audioService --[[AudioService]],
        cameraService --[[CameraService]],
        player --[[Player]]
)
    local this = {
        inputService = inputService,
        sideIndex = 0,
        anim = animation,
        audioService = audioService,
        cameraService = cameraService,
        player = player
    }

    function this:update(
            dt,
            map --[[Map]]
    )
        self.anim:update(dt, false)

        local seDeplace = self:updateDeplacement(dt, 200, map)

        if seDeplace then
            self.audioService:setStepSongStatus(true)
        else
            self.audioService:setStepSongStatus(false)
        end

        self.cameraService:updatePosition(self.player.position)
    end

    -- return true si le joueur a bougé sinon false
    function this:movingPlayer(vecteurDeplacement, map --[[Map]])
        local nouvellePosition = {
            x = self.player.position.x + vecteurDeplacement.x,
            y = self.player.position.y + vecteurDeplacement.y
        }
        local tile = map:getTileAt(nouvellePosition)
        if tile ~= -1 then
            self.player.position = nouvellePosition
           return true
        end

        return false
    end

    -- return true si le joueur a bougé sinon false
    function this:updateDeplacement(dt, vitesse, map --[[Map]])
        vitesse = vitesse or 200.0
        if (self.inputService.ctrlIsDown()) then
            vitesse = vitesse + 150.0
        end
        local seDeplace = false

        if self.inputService:upIsDown() then
            self.sideIndex = 2
            local isMoving = self:movingPlayer({ x = 0, y = - vitesse * dt}, map)
            if isMoving then seDeplace = true end
        end

        if self.inputService:rightIsDown() then
            self.sideIndex = 0
            local isMoving = self:movingPlayer({ x = vitesse * dt, y = 0}, map)
            if isMoving then seDeplace = true end
        end

        if self.inputService:downIsDown() then
            self.sideIndex = 3
            local isMoving = self:movingPlayer({ x = 0, y = vitesse * dt}, map)
            if isMoving then seDeplace = true end
        end

        if self.inputService:leftIsDown() then
            self.sideIndex = 1
            local isMoving = self:movingPlayer({ x = - vitesse * dt, y = 0}, map)
            if isMoving then seDeplace = true end
        end

        return seDeplace
    end

    function this:playerDrawingPosition()
        return {
            x = self.player.position.x - self.player.size.x / 2.0 - self.cameraService.position.x,
            y = self.player.position.y - self.player.size.y / 2.0 - self.cameraService.position.y
        }
    end

    function this:draw()
        local drawPos = self:playerDrawingPosition(self.cameraService)
        self.anim:draw(self.sideIndex, 4, drawPos)
    end

    return this
end

return PlayerService
