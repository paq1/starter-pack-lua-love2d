local game_app = {}

local animation = require("src/app/animation/Animation")
local PlayerService = require("src/core/actor/player/playerService")
local KeyboardService = require("src/app/keyboard/KeyboardService")

function game_app.load()
    keyboardService = KeyboardService:new()

    local snakeSpritesheet = love.graphics.newImage("assets/sprites/actor/Snake.png")
    playerAnimation = animation:new(snakeSpritesheet, 16, 16, 1)

    playerService = PlayerService:new(keyboardService, playerAnimation)
end

function game_app.update(dt)
    playerService:update(dt)
end

function game_app.draw()
    playerService:draw()
end

return game_app