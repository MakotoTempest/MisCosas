
local display_focus = false
local hud = {
    health = 0,
    armor = 0,
    hunger = 0,
    thirst = 0,
}
RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst) -- Triggered in qb-core
    hud.hunger = newHunger
    hud.thirst = newThirst
end)

function SetHungry()
    local playerData = QBCore.Functions.GetPlayerData()
    if not playerData.metadata?.hunger then return end
    local hunger, thirst = playerData.metadata.hunger, playerData.metadata.thirst
    hud.hunger = hunger
    hud.thirst = thirst

end

CreateThread(function()
    SetHungry()
end)

function GetStats()
    local ped = PlayerPedId()
    hud.healt = GetEntityHealth(ped)
    hud.armor = GetPedArmour(ped)
    return hud
end

function displayFocus(bool)
    SetNuiFocus(bool, bool)
    SetNuiFocusKeepInput(bool)
    if display_focus then 
        display_focus = bool
        return
    end
    CreateThread(function() 
        display_focus = bool
        while display_focus do 
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 287, true)
            DisableControlAction(0, 286, true)
            DisableControlAction(0, 18, true)
            DisableControlAction(0, 45, true)
            DisableControlAction(0, 80, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 26, true)
            DisableControlAction(0, 68, true)
            DisableControlAction(0, 69, true)
            DisableControlAction(0, 70, true)
            DisableControlAction(0, 91, true)
            DisableControlAction(0, 92, true)
            Wait(0)
        end
    end) 
end
