local animation_module = {}

function animation_module.newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

function animation_module.update(dt, animation, reset)
    reset = reset or false

    if reset then
        animation.currentTime = 0.0
    end

    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end
end

-- side_index : from 0 to nb_side - 1
-- nb_side : size of spriteSheet column
function animation_module.draw(animation, side_index, nb_side, position)
    local spriteNum = math.floor(animation.currentTime / animation.duration * nb_side) + 1

    love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum * nb_side - side_index], position.x, position.y, 0, 2)
end

return animation_module