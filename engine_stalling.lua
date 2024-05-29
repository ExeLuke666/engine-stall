local lastVehicleHealth = 0

function CheckStalling(vehicle)
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        local currentHealth = GetVehicleBodyHealth(vehicle)
        local healthDifference = lastVehicleHealth - currentHealth
        local speed = GetEntitySpeed(vehicle) * 2.236936
        if healthDifference > Config.MinHealthDifference and speed > Config.MinimumSpeedForStalling then
            TriggerEvent("carEngineStalling:stallEngine", vehicle)
        end
        lastVehicleHealth = currentHealth
    end
end

function StallEngine(vehicle)
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        SetVehicleEngineOn(vehicle, false, false, true)
        SetTimeout(Config.StallingDuration * 1000, function()
            SetVehicleEngineOn(vehicle, true, false, true)
        end)
    end
end

RegisterNetEvent("carEngineStalling:checkStalling")
AddEventHandler("carEngineStalling:checkStalling", CheckStalling)

RegisterNetEvent("carEngineStalling:stallEngine")
AddEventHandler("carEngineStalling:stallEngine", StallEngine)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local playerPed = PlayerPedId()
        if playerPed and IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
                local currentHealth = GetVehicleBodyHealth(vehicle)
                if lastVehicleHealth == 0 then
                    lastVehicleHealth = currentHealth
                end
            end
        end
    end
end)
