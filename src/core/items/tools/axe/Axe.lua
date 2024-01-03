local AxeItem = {}

local ItemType = require("src/core/items/ItemType")
local HitBox = require("src/core/hitbox/HitBox")

function AxeItem:new(
        effect --[[AxeEffect]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]],
        position
)
    position = position or {}

    local this = {
        itemType = ItemType.TOOLS,
        position = position, -- n'apparait pas sur la map s'il n'a pas de position
        effect = effect,
        imageFactory = imageFactory,
        rendererService = rendererService
    }

    function this:apply(dt)
        self.effect:apply(dt)
        -- ne fait rien d'autre a part utiliser l'effet (n'a pas de durablilité ... etc)
    end

    function this:needDelete()
        return false
    end

    function this:getHitBox()
        if not self:existOnMap() then
            return {}
        end
        return HitBox:new(self.position, { width = 32, height = 32 })
    end

    function this:existOnMap()
        return self.position.x ~= nil and self.position.y ~= nil
    end

    function this:draw(camPos, scale)
        if self:existOnMap() then
            self.rendererService:render(
                    self.imageFactory.itemAxe,
                    {
                        x = (self.position.x * scale) - camPos.x,
                        y = (self.position.y * scale) - camPos.y
                    },
                    scale
            )
        end
    end

    function this:drawInInventaire(pPosition, scale)
        if not self:existOnMap() then
            self.rendererService:render(
                    self.imageFactory.itemAxe,
                    {
                        x = pPosition.x,
                        y = pPosition.y
                    },
                    scale
            )
        end
    end

    return this
end

return AxeItem