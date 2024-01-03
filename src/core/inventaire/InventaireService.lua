local InventaireService = {}

local ItemType = require("src/core/items/ItemType")

function InventaireService:new(
        keyboardService --[[KeyboardService]],
        rendererService --[[RendererService]],
        windowService --[[WindowService]],
        imageFactory --[[ImageFactory]]
)
    local this = {
        keyboardService = keyboardService,
        rendererService = rendererService,
        windowService = windowService,
        imageFactory = imageFactory
    }

    this.slotSelected = { false, false, false, false, false }

    function this:update(dt, inventaire --[[BarreInventaire]])

        self:updateOne(dt, inventaire, self.keyboardService:slotItem1IsDown(), 1)
        self:updateOne(dt, inventaire, self.keyboardService:slotItem2IsDown(), 2)
        self:updateOne(dt, inventaire, self.keyboardService:slotItem3IsDown(), 3)
        self:updateOne(dt, inventaire, self.keyboardService:slotItem4IsDown(), 4)
        self:updateOne(dt, inventaire, self.keyboardService:slotItem5IsDown(), 5)

        this:updateClearItem(inventaire)

    end

    function this:updateOne(dt, inventaire --[[BarreInventaire]], slotPressed, indexSlot)
        if slotPressed and not self.slotSelected[indexSlot] then
            self.slotSelected[indexSlot] = true
            inventaire:equipeItem(indexSlot)
        end
        if not slotPressed then
            self.slotSelected[indexSlot] = false
        end
    end

    function this:updateClearItem(inventaire --[[BarreInventaire]])
        for i = 1, #inventaire.items do
            local item = inventaire.items[i]
            if item.itemType ~= ItemType.EMPTY and item:needDelete() then
                inventaire:removeOne(i)
            end
        end

        if inventaire.slotEquipe.itemType ~= ItemType.EMPTY and inventaire.slotEquipe:needDelete() then
            inventaire.slotEquipe = {
                itemType = ItemType.EMPTY
            }
        end
    end

    function this:draw(inventaire --[[BarreInventaire]], scale)
        local items = inventaire.items
        local nbSlots = #items
        local windowSize = self.windowService:getSize()
        local OneSlotWidth = 32
        local totalPixelWidthInventaire = nbSlots * OneSlotWidth * scale
        for index = 1, nbSlots do

            local item = items[index]

            local position = {
                x = (index - 1) * 32 * scale + windowSize.width / 2 - totalPixelWidthInventaire / 2,
                y = windowSize.height - 64 * scale
            }

            self.rendererService:render(
                    self.imageFactory.itemInventaire,
                    position,
                    scale
            )

            if item.itemType ~= ItemType.EMPTY then
                item:drawInInventaire(position, scale)
            end
        end


        -- item equiper joueur
        local item = inventaire.slotEquipe
        local offsetSlotEquipe = 32 * scale

        local position = {
            x = (nbSlots) * 32 * scale + windowSize.width / 2 - totalPixelWidthInventaire / 2 + offsetSlotEquipe,
            y = windowSize.height - 64 * scale
        }

        self.rendererService:render(
                self.imageFactory.itemInventaire,
                position,
                scale
        )

        if item.itemType ~= ItemType.EMPTY then
            item:drawInInventaire(position, scale)
        end
    end

    return this
end

return InventaireService