-- hennus
function Doors(index)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            if GetVehicleDoorAngleRatio(vehicle, index) > 0.0 then
                SetVehicleDoorShut(vehicle, index, false)     
            else
                SetVehicleDoorOpen(vehicle, index, false, false)
            end
        end
    end
end

function Windows(index)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
            if not IsVehicleWindowIntact(vehicle, index) then
                RollUpWindow(vehicle, index)
            else
                RollDownWindow(vehicle, index)
            end
        end
    end
end

function Sit(index)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if not vehicle or vehicle == 0 then return end
    if GetPedInVehicleSeat(vehicle, tonumber(index)) ~= 0 then return end
    local sits = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))
    if sits < tonumber(index) then return end
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, tonumber(index))
end