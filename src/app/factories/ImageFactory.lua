local ImageFactory = {}

local SpriteSheet = require("src/app/sprites/SpriteSheet")

function ImageFactory:new()
    local basicSize = { width = 32, height = 32 }

    local this = {
        -- single sprite
        tileForet = love.graphics.newImage("assets/sprites/map/tiles/tile_sol_foret.png"),
        fullTree = love.graphics.newImage("assets/sprites/map/arbres/arbre_classique.png"),
        sapin = love.graphics.newImage("assets/sprites/map/arbres/sapin.png"),
        cursorTarget = love.graphics.newImage("assets/sprites/hud/cursorTarget.png"),

        -- sprite sheet image
        snakeSpritesheet = love.graphics.newImage("assets/sprites/actor/Snake.png"),
        personnageSpritesheet = love.graphics.newImage("assets/sprites/actor/spitesheet_men_with_hair.png"),
        torcheSpritesheet = love.graphics.newImage("assets/sprites/map/torch_spritesheet.png"),
        tileForestSpriteSheetImage = love.graphics.newImage("assets/sprites/map/tiles/forest_ground_tilesheet.png"),
    }
    -- sprite sheet obj
    this.tileForestSpriteSheet = SpriteSheet:new(
            this.tileForestSpriteSheetImage,
            basicSize
    )

    return this
end

return ImageFactory