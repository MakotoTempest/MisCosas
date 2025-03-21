RegisterNUICallback('ActionBar', function(data)
    if data.action == 'anims' then
        exports['mkn-emotes']:OpenEmoteMnenu()
    elseif data.action == 'radio' then 
        TriggerEvent('qb-radio:use')
    elseif data.action == 'work' then
        --- Menu de trabajos
    elseif data.action == 'ilegal' then
        TriggerEvent('origen_ilegal:OpenGangMenu')
    elseif data.action == 'thief' then
        Thief()
    elseif data.action == 'carry' and not Config.piggyback.InProgress then
        Carry()
    elseif data.action == 'piggy' and not Config.carry.InProgress then
        PiggyBack()
    elseif data.action == 'editor' then
        Editor()
    elseif data.action == 'd_f_left' then
        Doors(0)
    elseif data.action == 'd_f_right' then
        Doors(1)
    elseif data.action == 'd_r_left' then
        Doors(2)
    elseif data.action == 'd_r_right' then
        Doors(3)
    elseif data.action == 'hood' then
        Doors(4)
    elseif data.action == 'trunk' then
        Doors(5)
    elseif data.action == 'w_f_left' then
        Windows(0)
    elseif data.action == 'w_f_right' then
        Windows(1)
    elseif data.action == 'w_r_left' then
        Windows(2)
    elseif data.action == 'w_r_right' then
        Windows(3)
    elseif data.action == 's_f_left' then
        Sit(-1)
    elseif data.action == 's_f_right' then
        Sit(0)
    elseif data.action == 's_r_left' then
        Sit(1)
    elseif data.action == 's_r_right' then
        Sit(2)
    elseif data.action == 'limiter' then
        local vehicle = GetVehiclePedIsIn(PlayerPedId())

        if vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            if speedlimiter then
                speedlimiter = false
                SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"))
                QBCore.Functions.Notify("Limitador desactivado", "error")
                print("Limitador desactivado")
            else
                speedlimiter = true
                local currentSpeed = GetEntitySpeed(vehicle)
                SetEntityMaxSpeed(vehicle, currentSpeed)
                QBCore.Functions.Notify("Limitador activado a " .. (currentSpeed * 3.6) .. " km/h", "success")

                Citizen.CreateThread(function()
                    while speedlimiter do
                        Citizen.Wait(100)
                        -- Verificación adicional para asegurarse de que el vehículo esté en tierra
                        if not IsPedInAnyVehicle(PlayerPedId(), false) or IsEntityInAir(vehicle) then
                            speedlimiter = false
                            SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"))
                            QBCore.Functions.Notify("Limitador desactivado automáticamente", "error")
                        end
                    end
                end)
            end
        else
            QBCore.Functions.Notify('No estás en ningún vehículo o no eres el conductor')
            print('No estás en ningún vehículo o no eres el conductor')
        end
    elseif data.action == 'crucero' then
        -- ExecuteCommand('crucero')
    elseif data.action == 'trucos' then
        ExecuteCommand('trucos')
    elseif data.action == 'motor' then
        ExecuteCommand('motor')
    end
end)



RegisterCommand('cargar', function() 
    Carry()
end)

RegisterCommand('caballito', function() 
    PiggyBack()
end)

local cruisecontrol = false
local speedlimiter = false

local function CanDoSteal(serverId)
    local targetPed = GetPlayerPed(serverId)
    for k ,v in pairs(Config.CanStealAnims) do 
        if IsEntityPlayingAnim(targetPed, k, v, 3) == 1 then
            return true
        end
    end
    return false
end
function Thief()
    local closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance > 1.0 then
        QBCore.Functions.Notify(Lang:t('info.NoNearPlayer'), 'error')
        return
    end
    local serverId = GetPlayerServerId(closestPlayer)
    if not CanDoSteal(closestPlayer) then
        QBCore.Functions.Notify(Lang:t('info.NoAction'), 'error')
        return
    end
    QBCore.Functions.Progressbar("search_player_inv", "Cacheando", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@bodysearch@",
        anim = "player_search",
        flags = 49,
    }, {}, {}, function()
       TriggerServerEvent('qb-inventory:server:thief', serverId)
    end)
end

RegisterNUICallback('GetMenuData', function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    if vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        local vehclass = GetVehicleClass(vehicle)

        if vehclass ~= 13 and vehclass ~= 21 then
            local doors = {}

            for i = 0, 6 do
                if DoesVehicleHaveDoor(vehicle, 0) then
                    table.insert(doors, {
                        id = i,
                        closed = GetVehicleDoorAngleRatio(vehicle, i) == 0
                    })
                end
            end

            cb({
                doors = doors,
                speedlimiter = speedlimiter,
                cruisecontrol = cruisecontrol,
                motor = GetIsVehicleEngineRunning(vehicle) == 1,
                ismoto = vehclass == 8,
                isboat = vehclass == 14,
                drift = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff") > 90,
                vehname = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
            })
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

RegisterCommand('thief', Thief)

RegisterNUICallback('ToggleClothing', function(data)
    Preselector(data.action)
end)

RegisterKeyMapping("motor", "Encender/Apagar motor", "MOUSE_BUTTON", "MOUSE_MIDDLE")

RegisterCommand('motor', function(source, args, raw)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    if vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        if GetIsVehicleEngineRunning(vehicle) then
            SetVehicleEngineOn(vehicle, false, false, true)
            SetVehicleUndriveable(vehicle, true)
            QBCore.Functions.Notify('Apagaste el motor')
        else
            SetVehicleEngineOn(vehicle, true, false, true)
            SetVehicleUndriveable(vehicle, false)
            QBCore.Functions.Notify('Encendiste el motor')
        end
    else
        QBCore.Functions.Notify('No estás en ningún vehículo o no eres el conductor')
    end
end)

RegisterCommand('trucos', function(source, args, raw)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local vehclass = GetVehicleClass(vehicle)

    if vehclass ~= 8 then
        return QBCore.Functions.Notify('No puedes hacer trucos en este vehículo')
    end
    
    if vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        local menu = {
            {
                header = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))),
                isMenuHeader = true, 
            },
            { header = "Acostarse", params = {
                handler = function()
                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                        RequestAnimDict("rcmextreme2atv")
                        while not HasAnimDictLoaded("rcmextreme2atv") do
                            Wait(10)
                        end
                        TaskPlayAnim(GetPlayerPed(-1), "rcmextreme2atv", "idle_a", 8.0, 1.0, -1, 32, 32, false, false, false)
                    end
                end
            }, txt="Hacer truco de tumbarse", icon="fa-solid fa-motorcycle"},
            { header = "Asomar izquierda", params = {
                handler = function()
                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                        RequestAnimDict("rcmextreme2atv")
                        while not HasAnimDictLoaded("rcmextreme2atv") do
                            Wait(10)
                        end
                        TaskPlayAnim(GetPlayerPed(-1), "rcmextreme2atv", "idle_b", 8.0, 1.0, -1, 32, 32, false, false, false)
                    end
                end
            }, txt="Hacer truco de asomarse a la izquierda", icon="fa-solid fa-motorcycle"},
            { header = "Asomar derecha", params = {
                handler = function()
                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                        RequestAnimDict("rcmextreme2atv")
                        while not HasAnimDictLoaded("rcmextreme2atv") do
                            Wait(10)
                        end
                        TaskPlayAnim(GetPlayerPed(-1), "rcmextreme2atv", "idle_c", 8.0, 1.0, -1, 32, 32, false, false, false)
                    end
                end
            }, txt="Hacer truco de asomarse a la derecha", icon="fa-solid fa-motorcycle"},
            { header = "Saltar de lado a lado", params = {
                handler = function()
                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                        RequestAnimDict("rcmextreme2atv")
                        while not HasAnimDictLoaded("rcmextreme2atv") do
                            Wait(10)
                        end
                        TaskPlayAnim(GetPlayerPed(-1), "rcmextreme2atv", "idle_d", 8.0, 1.0, -1, 32, 32, false, false, false)
                    end
                end
            }, txt="Hacer truco de saltar de lado a lado", icon="fa-solid fa-motorcycle"},
            { header = "Surf", params = {
                handler = function()
                    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                        RequestAnimDict("rcmextreme2atv")
                        while not HasAnimDictLoaded("rcmextreme2atv") do
                            Wait(10)
                        end
                        TaskPlayAnim(GetPlayerPed(-1), "rcmextreme2atv", "idle_e", 8.0, 1.0, -1, 32, 32, false, false, false)
                    end
                end
            }, txt="Hacer truco de surfear", icon="fa-solid fa-motorcycle"}
        }
        exports['qb-menu']:openMenu(menu) 
    else
        QBCore.Functions.Notify('No estás en ningún vehículo o no eres el conductor')
    end
end)

-- RegisterCommand('crucero', function(source, args, raw)
--     local vehicle = GetVehiclePedIsIn(PlayerPedId())

--     if vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
--         if cruisecontrol then
--             cruisecontrol = false
--         else
--             local speed = GetEntitySpeed(vehicle)
--             local timeturn = 0
--             cruisecontrol = true
--             Citizen.CreateThread(function()
--                 while cruisecontrol do
--                     Citizen.Wait(5)
--                     local roll = GetEntityRoll(vehicle)
--                     local sp = GetEntitySpeed(vehicle)

--                     if not IsPedInAnyVehicle(PlayerPedId(), false) or IsControlJustPressed(0, 71) or IsControlJustPressed(0, 72) or IsControlJustPressed(0, 76) or speed - sp > 10 or IsEntityInAir(vehicle) or (roll > 75.0 or roll < -75.0) or GetVehicleClass(vehicle) == 14 or not IsVehicleOnAllWheels(vehicle) then
--                         cruisecontrol = false
--                     end
--                     if IsControlPressed(0, 63) or IsControlPressed(0, 64) or IsControlPressed(0, 69) then
--                         timeturn = timeturn + 5
--                     else
--                         timeturn = 0
--                     end
--                     if sp >= 20 and timeturn >= 100 then
--                         cruisecontrol = false
--                     end
                    
--                     if cruisecontrol then
--                         SetVehicleForwardSpeed(vehicle, speed)
--                     end
--                 end
--             end)
--         end
--     else
--         QBCore.Functions.Notify('No estás en ningún vehículo o no eres el conductor')
--     end
-- end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            if IsControlPressed(2, 75) then
                Citizen.Wait(250)
                if IsPedInAnyVehicle(PlayerPedId(), false) and IsControlPressed(2, 75) then
                    local veh = GetVehiclePedIsIn(PlayerPedId())
                    SetVehicleEngineOn(veh, true, true, false)
                    TaskLeaveVehicle(PlayerPedId(), veh, 0)
                end
            end
        else
            Citizen.Wait(1500)
        end
	end
end)
