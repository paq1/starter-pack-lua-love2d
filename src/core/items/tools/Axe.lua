local AxeItem = {}

function AxeItem:new(
        effect --[[AxeEffect]],
        imageFactory --[[ImageFactory]],
        rendererService --[[RendererService]],
        position
)
    position = position or {}

    local this = {
        itemType = "tools",
        position = position, -- n'apparait pas sur la map s'il n'a pas de position
        effect = effect,
        imageFactory = imageFactory,
        rendererService = rendererService
    }

    function this:apply(dt)
        self.effect:apply(dt)
        -- ne fait rien d'autre a part utiliser l'effet (n'a pas de durablilité ... etc)
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