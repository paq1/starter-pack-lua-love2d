local ImageFactory = {}

function ImageFactory:new()
    local this = {
        tileGrassImage = love.graphics.newImage("assets/sprites/map/grass.png"),
        fullTree = love.graphics.newImage("assets/sprites/map/completTree.png"),

        snakeSpritesheet = love.graphics.newImage("assets/sprites/actor/Snake.png"),
        personnageSpritesheet = love.graphics.newImage("assets/sprites/actor/spitesheet_personnage.png"),
        torcheSpritesheet = love.graphics.newImage("assets/sprites/map/torch_spritesheet.png"),

        cursorTarget = love.graphics.newImage("assets/sprites/hud/cursorTarget.png")
    }

    return this
end

return ImageFactory