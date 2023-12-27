local PostProcessLumiereService = {}


function PostProcessLumiereService:new(
        windowService --[[WindowService]]
)
    local this = {
        windowService = windowService
    }

    function this:createLumiereCanvas(map --[[Map]])
        local windowSize = self.windowService:getSize()
        local pixelsWidth = windowSize.width
        local pixelsHeight = windowSize.height
        print("(" .. pixelsWidth .. ", " .. pixelsHeight .. ")")

        local canvas = love.graphics.newCanvas(pixelsWidth, pixelsHeight)

        love.graphics.setCanvas({canvas, stencil=true} )

            local windowWidth, windowHeight = love.graphics.getDimensions()

            love.graphics.setScissor(0,0, windowWidth/2,windowHeight)
            --love.graphics.clear(0, 0, .5)

            -- night
            local myColor = {1, 1, 1, 0.5}
            love.graphics.setColor(myColor)
            love.graphics.rectangle("fill", 0, 0, pixelsWidth, pixelsHeight)

            -- light
            local myColor2 = { 1, 1, 1, 0.5}
            love.graphics.setColor(myColor2)
            love.graphics.circle("fill", 400, 300, 50)

            -- on remet la couleur de base en place
            love.graphics.setScissor(0,0, windowWidth,windowHeight)
            love.graphics.setColor({ 1, 1, 1, 1})

        love.graphics.setCanvas()
        return canvas
    end

    return this
end

return PostProcessLumiereService