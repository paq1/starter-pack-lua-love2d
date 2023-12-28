local RandomService = {}

function RandomService:new(seed --[[Int]])
    local this = {}

    math.randomseed(seed)

    function this:generateFromRange(min, max)
        return math.random(min, max)
    end

    function this:random()
        return math.random()
    end

    return this
end

return RandomService