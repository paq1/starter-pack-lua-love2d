local app = require("src/app/App")

local ConfigGame = require("src/core/scenes/game/ConfigGame")

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

function love.wheelmoved(dx, dy)
    local maxScale = 3
    local minScale = 1
    if dy > 0 then
        if ConfigGame.scale < maxScale then
            ConfigGame.scale = ConfigGame.scale + .1
        else
            ConfigGame.scale = maxScale
        end
    elseif dy < 0 then
        text = "Mouse wheel moved down"
        if ConfigGame.scale > minScale then
            ConfigGame.scale = ConfigGame.scale - .1
        else
            ConfigGame.scale = minScale
        end
    end
end