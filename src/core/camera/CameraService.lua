local CameraService = {}

function CameraService:new()
    local this = {
        position = {x = 0, y = 0}
    }

    function this:updatePosition(newPosition)
        self.position = {
            x = newPosition.x - 400 - 16, -- fixme recup la window size
            y = newPosition.y - 300 - 16, -- fixme recup la window size
        }
    end

    return this
end

return CameraService