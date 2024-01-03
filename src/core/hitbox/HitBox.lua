local HitBox = {}

function HitBox:new(
        position,
        size
)
    local this = {
        position = position,
        size = size
    }

    function this:collide(other --[[HitBox]])
        local points = {
            self.position, -- haut gauche
            {
                x = self.position.x + self.size.width,
                y = self.position.y
            },
            {
                x = self.position.x + self.size.width,
                y = self.position.y + self.size.height
            },
            {
                x = self.position.x,
                y = self.position.y + self.size.height
            }
        }

        for _, point in pairs(points) do
            if other:collidePoint(point) then return true end
        end
        return false
    end

    function this:collidePoint(point)
        return point.x > self.position.x and point.x < self.position.x + self.size.width
            and point.y > self.position.y and point.y < self.position.y + self.size.height
    end

    return this
end

return HitBox