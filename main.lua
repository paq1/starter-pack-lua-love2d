local app = require("src/app/App")

function love.load()
    app.load()
end

function love.update(dt)
    app.update(dt)
end

function love.draw()
    app.draw()
end
