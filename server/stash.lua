local function StashCanCarryItem(stashid, item, amount, slots, maxWeight)
    local stashidlower = stashid:lower()
    local stashId = stashidlower:match('stash(.*)') and stashid or 'Stash-' .. stashid
    local stash = Inventories[stashId] or  InitializeInventory(stashId, {label = stashId})
    local totalWeight = GetTotalWeight(stash.items)
    local itemInfo = QBCore.Shared.Items[item:lower()]
    if not itemInfo then
		print("^1[ERROR] Item does not exist^7", item:lower())
        return false
    end
    amount = tonumber(amount) or 1
    if totalWeight + ((itemInfo.weight or 1) * amount ) > (tonumber(stash.maxWeight) or 1000000) then
        return false
    end
    return true
end

exports("StashCanCarryItem", StashCanCarryItem)

local function AddItemIntoStash(stashid, item, amount, slot, info, slots, maxWeight)
    local stashidlower = stashid:lower()
    local stashId = stashidlower:match('stash(.*)') and stashid or 'Stash-' .. stashid
    local stash = Inventories[stashId] or  InitializeInventory(stashId, {label = stashId})
    local totalWeight = GetTotalWeight(stash.items)
    local itemInfo = QBCore.Shared.Items[item:lower()]
    if not itemInfo then
        print("^1[ERROR] Item does not exist^7", item:lower())
        return false
    end
    amount = tonumber(amount) or 1
    slot = tonumber(slot) or GetFirstSlotByItem(stash.items, item)
    info = info or {}
    if itemInfo.type == 'wepaon' then
        info.serie = info.serie or  info.serie or tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
        info.quality = info.quality or 100
    end

    if (slot and stash.items[slot]) and (stash.items[slot].name:lower() == item:lower()  ) and (itemInfo.type == 'item' and not itemInfo.unique) then
        Inventories[stashId].items[slot].amount = Inventories[stashId].items[slot].amount + amount
        return true 
    elseif (not itemInfo.unique and slot) or (slot and stash.items[slot] == nil) then 
        Inventories[stashId].items[slot] = {
            name = itemInfo.name, 
            amount = amount, 
            info = info or '', 
            label = itemInfo.label, 
            description = itemInfo.description or '',
            weight = itemInfo.weight or 1,
            type = itemInfo.type,
            unique = itemInfo.unique or false,
            useable = itemInfo.useable or false,
            image = itemInfo.image or 'default.png',
            shouldClose = itemInfo.shouldClose,
            slot = slot,
            combinable = itemInfo.combinable,
        }
        return true
    elseif itemInfo.unique or (not slot or slot == nil) or itemInfo.type == 'weapon' then 
        for i = 1, Config.StashSize.slots, 1 do 
            if stash.items[i] == nil then 
                Inventories[stashId].items[i] = {
                    name = itemInfo.name, 
                    amount = amount, 
                    info = info or '', 
                    label = itemInfo.label, 
                    description = itemInfo.description or '',
                    weight = itemInfo.weight or 1,
                    type = itemInfo.type,
                    unique = itemInfo.unique or false,
                    useable = itemInfo.useable or false,
                    image = itemInfo.image or 'default.png',
                    shouldClose = itemInfo.shouldClose,
                    slot = i,
                    combinable = itemInfo.combinable,
                }
                return true
            end
        end
    end
    return false
end

exports("AddItemIntoStash", AddItemIntoStash)

local function RemoveItemIntoStash(stashid, item, amount, slot, slots, maxWeight)
    local stashidlower = stashid:lower()
    local stashId = stashidlower:match('stash(.*)') and stashid or 'Stash-' .. stashid
    local stash = Inventories[stashId]
    if not stash then
        return false
    end
    amount = tonumber(amount) or 1
    slot = tonumber(slot)
    if slot then 
        if  stash.items[slot] and stash.items[slot].amount > amount then
            Inventories[stashId].items[slot].amount = Inventories[stashId].items[slot].amount - amount
            return true
        else
            stash.items[slot] = nil
            return true
        end
    else
        local slots = GetSlotsByItem(stash.items, item)
        local amountToRemove = amount
        if not slots then return false end
        for k, v in pairs(slots) do
            if Inventories[stashId].items[v].amount > amountToRemove then
                Inventories[stashId].items[v].amount = Inventories[stashId].items[v].amount - amountToRemove
                return true
            else
                amountToRemove = amountToRemove - Inventories[stashId].items[v].amount
                Inventories[stashId].items[v] = nil
            end
        end
    end
    return false
end

exports("RemoveItemIntoStash", RemoveItemIntoStash)

-- CreateThread(function() 
--     -- Verificar si la columna 'weight' ya existe
--     MySQL.query([[
--         SELECT COUNT(*) AS count
--         FROM information_schema.columns
--         WHERE TABLE_NAME = 'inventories'
--         AND COLUMN_NAME = 'weight';
--     ]], {}, function(result)
--         -- Si la columna no existe, entonces agregamos la columna
--         if result[1].count == 0 then
--             MySQL.query([[
--                 ALTER TABLE `inventories` ADD COLUMN `weight` INT(25) NOT NULL DEFAULT '100000' AFTER `items`;
--             ]])
--         end
--     end)
-- end)
