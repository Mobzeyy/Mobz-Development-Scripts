local ESX, QBCore = nil, nil

-- Initialize framework
Citizen.CreateThread(function()
    if Config.Framework == 'ESX' then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(200)
        end
    elseif Config.Framework == 'QBCore' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

-- Function to get player's job
function GetPlayerJob()
    if Config.Framework == 'ESX' and ESX then
        return ESX.GetPlayerData().job.name
    elseif Config.Framework == 'QBCore' and QBCore then
        return QBCore.Functions.GetPlayerData().job.name
    end
    return nil
end

-- Function to get player's gang
function GetPlayerGang()
    if Config.Framework == 'ESX' and ESX then
        return ESX.GetPlayerData().gang and ESX.GetPlayerData().gang.name
    elseif Config.Framework == 'QBCore' and QBCore then
        return QBCore.Functions.GetPlayerData().gang and QBCore.Functions.GetPlayerData().gang.name
    end
    return nil
end

-- Function to send notifications using ox_lib
function NotifyPlayer(message)
    lib.notify({
        title = 'Access Denied',
        description = message,
        type = 'error',
        position = 'top-right',
        duration = 5000
    })
end

-- Main loop to check vehicle access
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.CheckInterval)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local seat = GetPedInVehicleSeat(vehicle, -1)
            if seat == playerPed then
                local vehicleModel = GetEntityModel(vehicle)
                local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel):lower()
                local job = GetPlayerJob()
                local gang = GetPlayerGang()
                local authorized = false

                -- Check job authorization
                if Config.EnableJobCheck and Config.AllowedJobs[job] then
                    for _, v in ipairs(Config.AllowedJobs[job].vehicles) do
                        if v == vehicleName then
                            authorized = true
                            break
                        end
                    end
                end

                -- Check gang authorization
                if not authorized and Config.EnableGangCheck and gang and Config.AllowedGangs[gang] then
                    for _, v in ipairs(Config.AllowedGangs[gang].vehicles) do
                        if v == vehicleName then
                            authorized = true
                            break
                        end
                    end
                end

                -- If not authorized, remove player from vehicle
                if not authorized then
                    TaskLeaveVehicle(playerPed, vehicle, 0)
                    NotifyPlayer(Config.DenyMessage)
                end
            elseif not Config.AllowPassenger then
                -- If passengers are not allowed
                local vehicleModel = GetEntityModel(vehicle)
                local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel):lower()
                local job = GetPlayerJob()
                local gang = GetPlayerGang()
                local authorized = false

                -- Check job authorization
                if Config.EnableJobCheck and Config.AllowedJobs[job] then
                    for _, v in ipairs(Config.AllowedJobs[job].vehicles) do
                        if v == vehicleName then
                            authorized = true
                            break
                        end
                    end
                end

                -- Check gang authorization
                if not authorized and Config.EnableGangCheck and gang and Config.AllowedGangs[gang] then
                    for _, v in ipairs(Config.AllowedGangs[gang].vehicles) do
                        if v == vehicleName then
                            authorized = true
                            break
                        end
                    end
                end

                -- If not authorized, remove player from vehicle
                if not authorized then
                    TaskLeaveVehicle(playerPed, vehicle, 0)
                    NotifyPlayer(Config.DenyMessage)
                end
            end
        end
    end
end)
