local ElementDestructible = {}

function ElementDestructible:new(position, elementType, vie, vieMax)
    local this = {
        position = position,
        elementType = elementType,
        vie = vie,
        vieMax = vieMax
    }

    function this:hit(degats)
        if self.vie - degats <= 0 then self.vie = 0
        else self.vie = self.vie - degats end
    end

    return this
end

return ElementDestructible