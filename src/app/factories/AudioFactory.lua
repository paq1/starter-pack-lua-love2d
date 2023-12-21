local AudioFactory = {}

function AudioFactory:new()

    local LOADING_IN_MEMORY = "static" -- cool pour les sons courts
    local LOADING_FROM_DISK = "stream" -- mieux pour les musiques ou sons long

    local this = {
        bird = love.audio.newSource("assets/sounds/effects/13_Birds_loop.wav", LOADING_FROM_DISK),
        crickets = love.audio.newSource("assets/sounds/effects/11_Crickets_2_loop.wav", LOADING_FROM_DISK),
        stepGrass = love.audio.newSource("assets/sounds/effects/04_step_grass_1.wav", LOADING_IN_MEMORY),
        stepDirt = love.audio.newSource("assets/sounds/effects/05_step_dirt_1.wav", LOADING_IN_MEMORY)
    }

    return this
end

return AudioFactory