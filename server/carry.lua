--Carry
local carrying = {}
local carried = {}
RegisterNetEvent('qb-inventory:server:carry', function(targetSrc) 
    local src = source
    local srcCoords = GetEntityCoords(GetPlayerPed(src))
    local targetCoords = GetEntityCoords(GetPlayerPed(targetSrc))
    if #(srcCoords - targetCoords) < 3.0 then
        carrying[src] = targetSrc
		carried[targetSrc] = src
        TriggerClientEvent('qb-inventory:client:carry', targetSrc, src)
    end
end)

RegisterNetEvent('qb-inventory:server:stopcarry', function(targetSrc)
    local src = source
    if carried[src] then 
        TriggerClientEvent('qb-inventory:client:stopcarry', carried[src])
        carrying[carried[src]] = nil
		carried[src] = nil
    elseif carrying[src] then
        TriggerClientEvent('qb-inventory:client:stopcarry', carrying[src])
        carrying[src] = nil
		carried[targetSrc] = nil
    end 
end)

--piggyback

local piggybacking = {}
local piggybacked = {}
RegisterNetEvent('qb-inventory:server:piggyback', function(targetSrc) 
    local src = source
    local srcCoords = GetEntityCoords(GetPlayerPed(src))
    local targetCoords = GetEntityCoords(GetPlayerPed(targetSrc))
    if #(srcCoords - targetCoords) < 3.0 then
        piggybacking[src] = targetSrc
        piggybacked[targetSrc] = src
        TriggerClientEvent('qb-inventory:client:piggyback', targetSrc, src)
    end
end)

RegisterNetEvent('qb-inventory:server:stoppiggyback', function(targetSrc)
    local src = source
    if piggybacked[src] then 
        TriggerClientEvent('qb-inventory:client:stoppiggyback', piggybacked[src])
        piggybacking[piggybacked[src]] = nil
        piggybacked[src] = nil
    elseif piggybacking[src] then
        TriggerClientEvent('qb-inventory:client:stoppiggyback', piggybacking[src])
        piggybacking[src] = nil
        piggybacked[targetSrc] = nil
    end 
end)
