local Options = {}

local ScenesName = require("src/core/scenes/ScenesName")

function Options:new()
    local this = {}

    function this:update(dt)

        return ScenesName.NONE
    end

    function this:draw(debugMode)
        debugMode = debugMode or false
    end

    return this
end

return Options