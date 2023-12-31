local PlayerService = {}

local ConfigGame = require("src/core/scenes/game/ConfigGame")
local TileType = require("src/core/map/TileType")

function PlayerService:new(
        inputService --[[KeyboardService]],
        animation --[[Animation]],
        audioService --[[AudioService]],
        cameraService --[[CameraService]],
        player --[[Player]],
        rendererService --[[RendererService]]
)
    local this = {
        sideIndex = 0,
        anim = animation,
        player = player
    }

    function this:update(
            dt,
            map --[[Map]]
    )
        self.anim:update(dt, false)

        if self:updateDeplacement(dt, 200, map) then
            audioService:setStepSongStatus(true)
        else
            audioService:setStepSongStatus(false)
        end

        cameraService:updatePosition({
            x = self.player.position.x * ConfigGame.scale,
            y = self.player.position.y * ConfigGame.scale
        })
    end

    function this:draw(debugMode)

        debugMode = debugMode or false

        local drawPos = self:playerDrawingPosition(cameraService)
        self.anim:draw(self.sideIndex, drawPos, ConfigGame.scale)

        if debugMode then
            local camPos = cameraService.position
            local hitbox = player:getHitBox()
            local position = hitbox.position
            local w, h = hitbox.size.width, hitbox.size.height

            rendererService:drawRectangle(
                    "line",
                    {
                        x = position.x * ConfigGame.scale - camPos.x,
                        y = position.y * ConfigGame.scale - camPos.y
                    },
                    {
                        width = w * ConfigGame.scale,
                        height = h * ConfigGame.scale
                    }
            )
        end
    end

    -- return true si le joueur a bougé sinon false
    function this:movingPlayer(vecteurDeplacement, map --[[Map]])
        local nouvellePosition = {
            x = self.player.position.x + vecteurDeplacement.x,
            y = self.player.position.y + vecteurDeplacement.y
        }
        local footPlayer = {
            x = nouvellePosition.x,
            y = nouvellePosition.y + 16
        }
        local tile = map:getTileAt(footPlayer)
        if tile.tileType == TileType.HERBE then
            self.player.position = nouvellePosition
            return true
        end

        return false
    end

    -- return true si le joueur a bougé sinon false
    function this:updateDeplacement(dt, vitesse, map --[[Map]])
        vitesse = vitesse or 200.0
        if (inputService.ctrlIsDown()) then
            vitesse = vitesse + 150.0
        end
        local seDeplace = false

        if inputService:upIsDown() then
            --self.sideIndex = 2
            local isMoving = self:movingPlayer({ x = 0, y = - vitesse * dt}, map)
            if isMoving then seDeplace = true end
        end

        if inputService:rightIsDown() then
            self.sideIndex = 0
            local isMoving = self:movingPlayer({ x = vitesse * dt, y = 0}, map)
            if isMoving then seDeplace = true end
        end

        if inputService:downIsDown() then
            --self.sideIndex = 3
            local isMoving = self:movingPlayer({ x = 0, y = vitesse * dt}, map)
            if isMoving then seDeplace = true end
        end

        if inputService:leftIsDown() then
            self.sideIndex = 1
            local isMoving = self:movingPlayer({ x = - vitesse * dt, y = 0}, map)
            if isMoving then seDeplace = true end
        end

        return seDeplace
    end

    function this:playerDrawingPosition()
        return {
            x = (self.player.position.x - self.player.size.x / 2.0) * ConfigGame.scale - cameraService.position.x,
            y = (self.player.position.y - self.player.size.y / 2.0) * ConfigGame.scale - cameraService.position.y
        }
    end

    return this
end

return PlayerService
