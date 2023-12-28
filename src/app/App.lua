local App = {}

local Components = require("src/app/Components")
local ConfigApp = require("src/core/ConfigApp")

function App.load()
    debugMode = ConfigApp.debug
    components = Components:new()
    f1Ready = true
end

function App.update(dt)
    components.scenesService:update(dt)

    if components.keyboardService:f1IsDown() and f1Ready then
        ConfigApp.debug = not ConfigApp.debug
        debugMode = ConfigApp.debug
        f1Ready = false
    end

    if not components.keyboardService:f1IsDown() then f1Ready = true end
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

    printInfoActiveDebugMode()
end

function printFps(at)
    at = at or { x = 0, y = 0 }
    components.rendererService:print("fps : " .. love.timer.getFPS())
end

function printInfoActiveDebugMode(at)
    local center = components.windowService:getCenter()
    local size = components.windowService:getSize()
    local text = "[press f1 to enable debug mod]"
    at = at or { x = center.x - (#text * 3), y = size.height - 32 }
    components.rendererService:print(text, at)
end

return App