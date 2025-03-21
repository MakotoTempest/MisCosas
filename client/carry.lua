

local function loadAnim(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end        
    end
    return animDict
end

local function ProcessThread()
	Citizen.CreateThread(function()
		while Config.piggyback.InProgress and not Config.carry.InProgress do
			if Config.piggyback.type == "beingPiggybacked" then
				if not IsEntityPlayingAnim(PlayerPedId(), Config.piggyback.personBeingPiggybacked.animDict, Config.piggyback.personBeingPiggybacked.anim, 3) then
					TaskPlayAnim(PlayerPedId(), Config.piggyback.personBeingPiggybacked.animDict, Config.piggyback.personBeingPiggybacked.anim, 8.0, -8.0, 100000, Config.piggyback.personBeingPiggybacked.flag, 0, false, false, false)
				end
			elseif Config.piggyback.type == "piggybacking" then
				if not IsEntityPlayingAnim(PlayerPedId(), Config.piggyback.personPiggybacking.animDict, Config.piggyback.personPiggybacking.anim, 3) then
					TaskPlayAnim(PlayerPedId(), Config.piggyback.personPiggybacking.animDict, Config.piggyback.personPiggybacking.anim, 8.0, -8.0, 100000, Config.piggyback.personPiggybacking.flag, 0, false, false, false)
				end
			end
            Wait(5)
		end
        while Config.carry.InProgress and not Config.piggyback.InProgress do
            if Config.carry.type == "beingcarried" then
                if not IsEntityPlayingAnim(PlayerPedId(), Config.carry.personCarried.animDict, Config.carry.personCarried.anim, 3) then
                    TaskPlayAnim(PlayerPedId(), Config.carry.personCarried.animDict, Config.carry.personCarried.anim, 8.0, -8.0, 100000, Config.carry.personCarried.flag, 0, false, false, false)
                end
            elseif Config.carry.type == "carrying" then
                if not IsEntityPlayingAnim(PlayerPedId(), Config.carry.personCarrying.animDict, Config.carry.personCarrying.anim, 3) then
                    TaskPlayAnim(PlayerPedId(), Config.carry.personCarrying.animDict, Config.carry.personCarrying.anim, 8.0, -8.0, 100000, Config.carry.personCarrying.flag, 0, false, false, false)
                end
            end
            Wait(10)
        end
		ClearPedTasks(PlayerPedId())
	end)
end

--- Carry
function Carry()
    if Config.piggyback.InProgress then return end
    if not Config.carry.InProgress then 
        local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 1.3 then
            local targetSrc = GetPlayerServerId(closestPlayer)
            if targetSrc and targetSrc ~= -1 then
                Config.carry.InProgress = true
                Config.carry.targetSrc = targetSrc
                TriggerServerEvent('qb-inventory:server:carry', targetSrc)
                loadAnim(Config.carry.personCarrying.animDict)
                Config.carry.type = "carry"
                ProcessThread()
            else
                QBCore.Functions.Notify(Lang:t("carry.NoNearPlayer"), 'error')
            end
        end
    else
        Config.carry.InProgress = false
        TriggerServerEvent('qb-inventory:server:stopcarry', Config.carry.targetSrc)
    end
end

-- RegisterCommand('carry', Carry)

RegisterNetEvent('qb-inventory:client:carry', function(targetSrc)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    Config.carry.InProgress = true
    loadAnim(Config.carry.personCarried.animDict)
    AttachEntityToEntity(PlayerPedId(), targetPed, 0, Config.carry.personCarried.attachX, Config.carry.personCarried.attachY, Config.carry.personCarried.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
    Config.carry.type = "beingcarried"
    ProcessThread()
end)

RegisterNetEvent('qb-inventory:client:stopcarry', function()
    Config.carry.InProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

-- Piggyback


function PiggyBack()
    if Config.carry.InProgress then return end
    if not Config.piggyback.InProgress then
        local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 1.3 then
            local targetSrc = GetPlayerServerId(closestPlayer)
            if targetSrc and targetSrc ~= -1 then
                Config.piggyback.InProgress = true
                Config.piggyback.targetSrc = targetSrc
                TriggerServerEvent('qb-inventory:server:piggyback', targetSrc)
                loadAnim(Config.piggyback.personPiggybacking.animDict)
                Config.piggyback.type = "piggybacking"
                ProcessThread()
            else
                QBCore.Functions.Notify(Lang:t("info.NoNearPlayer"), 'error')
            end
        end
    else
        Config.piggyback.InProgress = false
        TriggerServerEvent('qb-inventory:server:stoppiggyback', Config.piggyback.targetSrc)
    end

end

-- RegisterCommand('piggyback', PiggyBack)

RegisterNetEvent('qb-inventory:client:piggyback', function(targetSrc)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    Config.piggyback.InProgress = true
    loadAnim(Config.piggyback.personBeingPiggybacked.animDict)
    AttachEntityToEntity(PlayerPedId(), targetPed, 0, Config.piggyback.personBeingPiggybacked.attachX, Config.piggyback.personBeingPiggybacked.attachY, Config.piggyback.personBeingPiggybacked.attachZ, 0.5, 0.5, 180, false, false, false, false, 2, false)
    Config.piggyback.type = "beingPiggybacked"
    ProcessThread()
end)

RegisterNetEvent('qb-inventory:client:stoppiggyback', function()
    Config.piggyback.InProgress = false
    ClearPedSecondaryTask(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
end)

RegisterCommand('clearTasks', function()
    ClearPedSecondaryTask(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
end)
