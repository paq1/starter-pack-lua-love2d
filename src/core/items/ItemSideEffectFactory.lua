local ItemSideEffectFactory = {}

local AxeSideEffect = require("src/core/items/tools/axe/AxeSideEffect")
local TorchSideEffect = require("src/core/items/consommable/torch/TorchSideEffect")


function ItemSideEffectFactory:new(
        map --[[Map]],
        player --[[Player]]
)
    local this = {}

    this.sideEffects = {
        ["torch"] = TorchSideEffect:new(map, player),
        ["axe"] = AxeSideEffect:new(map, player)
    }

    function this:getEffect(behaviorName)
        return self.sideEffects[behaviorName]
    end

    return this
end

return ItemSideEffectFactory