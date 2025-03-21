RegisterNetEvent('inventory:server:OpenInventory', function(type, other, data)
    if type == 'shop' then
        exports['qb-inventory']:CreateShop({
            name = other,
            label = data.label,
            slots = data.slots or 20,
            coords = data.coords or GetEntityCoords(GetPlayerPed(source)),
            items = data.items,
        })
        exports['qb-inventory']:OpenShop(source, other)
        return
    end
    if tonumber(other) then 
        return exports['qb-inventory']:OpenInventoryById(source, tonumber(other)) 
    end
    exports['qb-inventory']:OpenInventory(source, other, data)
end)