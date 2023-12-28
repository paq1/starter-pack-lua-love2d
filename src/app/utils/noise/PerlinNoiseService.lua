local PerlinNoiseService = {}

function PerlinNoiseService:new()
    local this = {}

    function this:noise(x, y)
        return love.math.noise(x, y)
    end

    return this
end

return PerlinNoiseService