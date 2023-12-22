local Vecteur2D = {}

function Vecteur2D:new(x --[[Double]], y --[[Double]])
    local this = {
        x = x,
        y = y
    }

    function this:norme()
        math.sqrt(self.x * self.x + self.y * self.y)
    end

    function this:unitaire()
        local norme = self:norme()
        if norme ~= 0 then
            return Vecteur2D:new(self.x / norme, self.y / norme)
        else
            return Vecteur2D:new(0.0, 0.0)
        end
    end

    return this
end

return Vecteur2D