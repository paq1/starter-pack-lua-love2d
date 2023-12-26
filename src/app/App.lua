local App = {}

local Components = require("src/app/Components")

function App.load()
    debugMode = true
    components = Components:new()
end

function App.update(dt)
    components.scenesService:update(dt)
end

function drawMiddleLine()
    local center = components.windowService:getCenter()
    local size = components.windowService:getSize()
    -- horizontal
    love.graphics.line(0, center.y, size.width, center.y)
    -- vertical
    love.graphics.line(center.x, 0, center.x, size.height)
end

function App.draw()
    components.scenesService:draw()

    if debugMode then
        printFps()
        drawMiddleLine()
    end

end

function printFps(at)
    at = at or { x = 0, y = 0 }
    components.rendererService:print("fps : " .. love.timer.getFPS())
end

return App