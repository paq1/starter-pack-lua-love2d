local BarreInventaire = {}

function BarreInventaire:new(
        tailleMax
)
    local this = {
        tailleMax = tailleMax,
        items = {},
        slotEquipe = {
            itemType = "empty",
            item = {}
        }
    }

    function this:emptyElements()
        local elements = {}
        for _ = 1, self.tailleMax do
            table.insert(elements, {
                itemType = "empty"
            })
        end
        return elements
    end

    this.items = this:emptyElements()


    function this:addItem(item)
        local index = self:firstEmptySlot()
        if index > 0 then
            self.items[index] = item
            return true
        elseif self.slotEquipe.itemType == "empty" then
            self.slotEquipe = item
            return true
        end
    end

    function this:firstEmptySlot()
        for index = 1, #self.items do
            if self.items[index].itemType == "empty" then
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