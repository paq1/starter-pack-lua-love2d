local BarreInventaire = {}

local ItemType = require("src/core/items/ItemType")

function BarreInventaire:new(
        tailleMax
)
    local this = {
        tailleMax = tailleMax,
        items = {},
        slotEquipe = {
            itemType = ItemType.EMPTY
        }
    }

    function this:emptyElements()
        local elements = {}
        for _ = 1, self.tailleMax do
            table.insert(elements, {
                itemType = ItemType.EMPTY
            })
        end
        return elements
    end

    this.items = this:emptyElements()


    function this:addItem(item)

        if not this:addConsommable(item) then
            local index = self:firstEmptySlot()
            if index > 0 then
                self.items[index] = item
                return true
            elseif self.slotEquipe.itemType == ItemType.EMPTY then
                self.slotEquipe = item
                return true
            end
        else
            return true
        end

        return false

    end

    function this:addConsommable(item)
        if item.itemType ~= ItemType.CONSOMMABLES then
            return false
        end

        if self.slotEquipe.itemType == ItemType.CONSOMMABLES and self.slotEquipe.name == item.name then
            self.slotEquipe.nombre = self.slotEquipe.nombre + item.nombre
            return true
        end

        for i, currentItem in pairs(self.items) do
            if currentItem.name == item.name then
                self.items[i].nombre = self.items[i].nombre + item.nombre
                return true
            end
        end

        return false

    end

    function this:removeOne(index)
        table.remove(self.items, index)
        self.items[index] = {
            itemType = ItemType.EMPTY
        }
    end

    function this:firstEmptySlot()
        for index = 1, #self.items do
            if self.items[index].itemType == ItemType.EMPTY then
                return index
            end
        end

        return -1
    end

    function this:equipeItem(index)
        local oldItemEquipe = self.slotEquipe
        self.slotEquipe = self.items[index]
        self.items[index] = oldItemEquipe
    end

    return this
end

return BarreInventaire