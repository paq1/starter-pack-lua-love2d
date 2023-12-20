local App = {}

local Components = require("src/app/Components")

function App.load()
    components = Components:new()
end

function App.update(dt)
    components.game:update(dt)
end

function App.draw()
    components.game:draw()

    printFps()
end

function printFps(at)
    at = at or { x = 0, y = 0 }
    components.rendererService:print("fps : " .. love.timer.getFPS())
end

return App