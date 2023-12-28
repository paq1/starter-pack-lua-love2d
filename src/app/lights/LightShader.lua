local LightShader = {}

function LightShader:new()
    local this = {}

    function this:newPhongShader()

        -- le language utilisé est du GLSL (très similaire a du C)
        local shaderCode = [[
        #define NUM_LIGHTS 256

        struct Light {
          vec2 position;
          vec3 diffuse;
          float power;
        };

        uniform Light lights[NUM_LIGHTS];
        uniform int num_lights;
        uniform vec2 screen;

        const float constant = 1.0;
        const float linear = 1.0;
        const float quadratic = 0.032;

        vec3 fromLightToDiffuse(Light light, vec2 norm_screen);

        vec4 effect( vec4 color, Image image, vec2 texture_coords, vec2 screen_coords ){
            vec4 pixel = Texel(image, texture_coords);

            vec2 norm_screen = screen_coords / screen;
            vec3 diffuse = vec3(0);

            for (int i = 0; i < num_lights; i++) {
                diffuse += fromLightToDiffuse(lights[i], norm_screen);
            }

            diffuse = clamp(diffuse, 0.0, 1.0);

            return pixel * vec4(diffuse, 1.0);
        }

        vec3 fromLightToDiffuse(Light light, vec2 norm_screen) {
            vec2 norm_pos = light.position / screen;

            float distance = length(norm_pos - norm_screen) * light.power;
            float attenuation = 1.0 / (constant + linear * distance + quadratic * (distance * distance));

            return light.diffuse * attenuation;
        }

        ]]

        return love.graphics.newShader(shaderCode)
    end

    return this
end

return LightShader