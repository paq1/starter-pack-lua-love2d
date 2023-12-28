local ImageFactory = {}

function ImageFactory:new()
    local this = {
        tileForet = love.graphics.newImage("assets/sprites/map/tiles/tile_sol_foret.png"),
        fullTree = love.graphics.newImage("assets/sprites/map/arbres/arbre_classique.png"),
        sapin = love.graphics.newImage("assets/sprites/map/arbres/sapin.png"),

        snakeSpritesheet = love.graphics.newImage("assets/sprites/actor/Snake.png"),
        personnageSpritesheet = love.graphics.newImage("assets/sprites/actor/spitesheet_men_with_hair.png"),
        torcheSpritesheet = love.graphics.newImage("assets/sprites/map/torch_spritesheet.png"),

        cursorTarget = love.graphics.newImage("assets/sprites/hud/cursorTarget.png")
    }

    return this
end

return ImageFactory