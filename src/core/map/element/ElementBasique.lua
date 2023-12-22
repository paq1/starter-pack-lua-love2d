local ElementBasique = {}

function ElementBasique:new(position, elementType)
    local this = {
        position = position,
        elementType = elementType
    }

    return this
end

return ElementBasique