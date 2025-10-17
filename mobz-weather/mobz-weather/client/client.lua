
local freezeAtTen = false

-- Update weather from server
RegisterNetEvent("weather:update")
AddEventHandler("weather:update", function(weather)
    -- Set weather persistently
    SetWeatherTypeOvertimePersist(weather, 15.0)  -- Smooth transition to new weather
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)
    SetOverrideWeather(weather)
end)

-- Freeze time at 10:00 AM if the setting is enabled
RegisterNetEvent("time:freezeAtTen")
AddEventHandler("time:freezeAtTen", function()
    freezeAtTen = true
end)

-- Keep time frozen at 10:00 AM
CreateThread(function()
    while true do
        Wait(500)
        if freezeAtTen then
            NetworkOverrideClockTime(10, 0, 0)
        end
    end
end)

--[[
-- Request time freeze on player join
CreateThread(function()
    Wait(2000)  -- Wait for the player to fully load
    TriggerClientEvent("time:freezeAtTen", -1)
end)
--]]