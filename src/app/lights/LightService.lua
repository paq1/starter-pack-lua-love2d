local LightService = {}

local LightShader = require("src/app/lights/LightShader")

function LightService:new()
    local this = {}

    this.shader = LightShader:new():newPhongShader()

    function this:drawNightMod(lights, camPos)
        love.graphics.setShader(self.shader)

        self.shader:send("screen" ,{
            love.graphics.getWidth(),
            love.graphics.getHeight()
        })
        self.shader:send("num_lights", #lights)

        for i = 1, #lights do
            local currentLight = lights[i]

            self.shader:send("lights[".. i - 1 .. "].position", {
                currentLight.x - camPos.x,
                currentLight.y - camPos.y,
            })

            self.shader:send("lights[".. i - 1 .. "].diffuse", {1.0, 1.0, 1.0})
            self.shader:send("lights[".. i - 1 .. "].power", 30)
        end
    end

    function this:resetShader()
        love.graphics.setShader()
    end

    return this
end

return LightService