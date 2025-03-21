--[[CreateThread(function() 
    Wait(2000)
    ExecuteCommand('inventory')
end)

RegisterCommand('has_item', function(source, args, rawCommand)
    local item = args[1]
    local amount = args[2]
    print(exports['qb-inventory']:HasItem(item, tonumber(amount)))
end)]]