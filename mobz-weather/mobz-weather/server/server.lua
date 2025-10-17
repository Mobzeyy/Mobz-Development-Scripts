
-- Define available weather types
local weatherTypes = { "CLEAR", "EXTRASUNNY", "CLOUDS", "RAIN", "FOGGY", "THUNDER", "SMOG", "XMAS", "HALLOWEEN" }
local currentIndex = 1

-- Function to rotate weather
local function rotateWeather()
    currentIndex = currentIndex + 1
    if currentIndex > #weatherTypes then
        currentIndex = 1
    end
    local newWeather = weatherTypes[currentIndex]
    print("Changing weather to: " .. newWeather)
    TriggerClientEvent("weather:update", -1, newWeather)
end

-- Start the weather cycle if enabled in config
if Config.enableWeatherCycle then
    CreateThread(function()
        while true do
            Wait(Config.weatherCycleInterval * 60000)  -- Convert minutes to milliseconds
            rotateWeather()
        end
    end)
end

-- Freeze time at 10:00 AM if enabled in config
if Config.freezeTimeAtTen then
    CreateThread(function()
        while true do
            Wait(500)
            TriggerClientEvent("time:freezeAtTen", -1)
        end
    end)
end