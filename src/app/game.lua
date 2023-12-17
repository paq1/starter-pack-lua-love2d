local game_app = {}

local animation = require("src/app/animation")
local PlayerService = require("src/app/player/playerService")
local KeyboardService = require("src/app/keyboard/KeyboardService")

function game_app.load()
    loaded = false
    whale = love.graphics.newImage("assets/sprites/actor/whale.png")
    keyboardService = KeyboardService:new()
    playerService = PlayerService:new(keyboardService)
    loaded = true
    print("loaded\n")
end

function game_app.update(dt)
    playerService:update(dt)
end

function game_app.draw()
    playerService:draw()
end

return game_app