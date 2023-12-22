local CameraService = {}

function CameraService:new(
        windowService --[[WindowService]]
)
    local this = {
        windowService = windowService,
        position = {x = 0, y = 0}
    }

    function this:updatePosition(newPosition)
        local windowSize = self.windowService.getSize()
        self.position = {
            x = newPosition.x - (windowSize.width / 2.0)  - 16,
            y = newPosition.y - (windowSize.height / 2.0) - 16,
        }
    end

    return this
end

return CameraService