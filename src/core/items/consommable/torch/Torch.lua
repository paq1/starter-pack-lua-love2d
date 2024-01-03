local TorchItem = {}

local ItemType = require("src/core/items/ItemType")
local HitBox = require("src/core/hitbox/HitBox")

function TorchItem:new(
        effect --[[TorchEffect]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]],
        position,
        nombre
)
    position = position or {}
    nombre = nombre or 1

    local this = {
        itemType = ItemType.CONSOMMABLES,
        position = position, -- n'apparait pas sur la map s'il n'a pas de position
        effect = effect,
        imageFactory = imageFactory,
        rendererService = rendererService,
        nombre = nombre,
        name = "torche"
    }

    function this:apply(dt)
        if self.effect:apply(dt) then
            self.nombre = self.nombre - 1
        end
    end

    function this:add(nb)
        self.nombre = self.nombre + nb
    end

    function this:needDelete()
        return self.nombre <= 0
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
                    self.imageFactory.itemTorch,
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
                    self.imageFactory.itemTorch,
                    {
                        x = pPosition.x,
                        y = pPosition.y
                    },
                    scale
            )
            local color = {
                r = 1,
                g = 0,
                b = 0,
                a = 1
            }
            self.rendererService:print(
                    self.nombre,
                    {
                        x = pPosition.x + 32,
                        y = pPosition.y + 32
                    },
                    scale,
                    color
            )
        end
    end

    return this
end

return TorchItem