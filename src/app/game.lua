local game_app = {}

local KeyboardService = require("src/app/keyboard/KeyboardService")
local RendererService = require("src/app/renderer/RendererService")
local ImageFactory = require("src/app/factories/ImageFactory")
local animation = require("src/app/animation/Animation")

local PlayerService = require("src/core/actor/player/playerService")
local Map = require("src/core/map/Map")
local MapService = require("src/core/map/MapService")

function game_app.load()
    keyboardService = KeyboardService:new()
    rendererService = RendererService:new()
    imageFactory = ImageFactory:new()

    local snakeSpritesheet = love.graphics.newImage("assets/sprites/actor/Snake.png")
    playerAnimation = animation:new(snakeSpritesheet, 16, 16, 1)

    playerService = PlayerService:new(keyboardService, playerAnimation)
    mapService = MapService:new(
            Map:new({ x = 25, y = 10 }, 32),
            imageFactory,
            rendererService
    )
end

function game_app.update(dt)
    playerService:update(dt)
end

function game_app.draw()
    mapService:render()

    playerService:draw()

    printFps()
    printCurrentCoordPlayerOnMap({ x = 0, y = 32 })
end

function printCurrentCoordPlayerOnMap(at)
    at = at or { x = 0, y = 0 }
    local pos = playerService.player.position
    local coord = mapService.map:getCoordTile(pos)

    love.graphics.print("current tile : (" .. coord.x .. ", " .. coord.y .. ")", at.x, at.y)
end

function printFps(at)
    at = at or { x = 0, y = 0 }
    love.graphics.print("fps : " .. love.timer.getFPS())
end

return game_app