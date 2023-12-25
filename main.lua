local app = require("src/app/App")

function love.load()
    love.graphics.setDefaultFilter( "nearest" )
    app.load()
end

function love.update(dt)
    app.update(dt)
end

function love.draw()
    app.draw()
end
