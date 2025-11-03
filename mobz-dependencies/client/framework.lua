-- mobz-dependecies/framework.lua
local frameworkClient = {}
local QBCore, ESX
local lib

-- Global registry for modules
Modules = Modules or {}

-- Helper function to register a module
function RegisterModule(name, module)
    Modules[name] = module
    print(("[mobz-dependencies] (Client-Side-FrameWork) Module registered: %s"):format(name))
end

frameworkClient.Type = 'none'

-- Detect framework
CreateThread(function()
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        frameworkClient.Type = 'qb'
        frameworkClient.GetPlayerData = function() return QBCore.Functions.GetPlayerData() end
        print('[Framework] ✅ Using QB-Core (client)')

    elseif GetResourceState('es_extended') == 'started' then
        local status, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
        if status and obj then ESX = obj end
        frameworkClient.Type = 'esx'
        frameworkClient.GetPlayerData = function() return ESX.GetPlayerData() end
        print('[Framework] ✅ Using ESX (client)')

    elseif GetResourceState('ox_lib') == 'started' then
        lib = exports.ox_lib
        frameworkClient.Type = 'ox'
        print('[Framework] ✅ Using ox_lib (client)')

    else
        frameworkClient.Type = 'none'
        print('[Framework] ⚠️ No supported framework detected on client!')
    end
end)

-- Player data getter
function frameworkClient.GetPlayer_cl()
    if frameworkClient.Type == 'qb' then return QBCore.Functions.GetPlayerData() end
    if frameworkClient.Type == 'esx' then return ESX.GetPlayerData() end
end

-- Check for item
function frameworkClient.HasItem(item, count)
    count = count or 1
    if frameworkClient.Type == 'qb' then
        local items = QBCore.Functions.GetPlayerData().items
        for _, v in pairs(items) do if v.name == item and v.amount >= count then return true end end
    elseif frameworkClient.Type == 'esx' then
        local items = ESX.GetPlayerData().inventory
        for _, v in pairs(items) do if v.name == item and v.count >= count then return true end end
    elseif frameworkClient.Type == 'ox' then
        local ok, result = pcall(function() return exports.ox_inventory:Search("count", item) end)
        return ok and result >= count
    end
    return false
end

-- Notification handler
function frameworkClient.Notify(message, notifType, duration)
    notifType = notifType or "info"
    duration = duration or 5000

    if Config.Notify == "qb" and QBCore then
        QBCore.Functions.Notify(message, notifType, duration)

    elseif Config.Notify == "esx" and ESX then
        ESX.ShowNotification(message)

    elseif Config.Notify == "ox_lib" then
        if GetResourceState('ox_lib') == 'started' then
            exports.ox_lib:notify({
                title = "Notification",
                description = message,
                type = notifType,
                duration = duration
            })
        else
            print("[Notify] ⚠ ox_lib not ready yet!")
        end

    elseif Config.Notify == "custom" then
        print(("[Notify] [%s]: %s"):format(notifType:upper(), message))
        TriggerEvent("chat:addMessage", {
            color = {255, 255, 0},
            multiline = true,
            args = {"Custom Notify", message}
        })
    else
        print("[Notify] No matching framework found for notification!")
    end
end

-- Listen for server notifications
RegisterNetEvent('framework:serverNotify', function(message, notifType, duration)
    frameworkClient.Notify(message, notifType, duration)
end)

Modules["framework"] = frameworkClient


-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("frameworkClient", frameworkClient)
if Config.Debug then print("[mobz-dependencies] (Client-Framework) frameworkClient module loaded") end


-- Exports
exports('GetPlayer_cl', function() return frameworkClient.GetPlayer_cl() end)
exports('HasItem', function(item, count) return frameworkClient.HasItem(item, count) end)
exports('Notify', function(message, type, duration) frameworkClient.Notify(message, type, duration) end)






-- Test command for notifications
RegisterCommand("testnotify", function()
    -- Test messages for all types
    local testMessages = {
        {msg = "Info notification test!", type = "info"},
        {msg = "Success notification test!", type = "success"},
        {msg = "Warning notification test!", type = "warning"},
        {msg = "Error notification test!", type = "error"}
    }

    for _, v in pairs(testMessages) do
        exports["mobz-dependencies"]:Notify(v.msg, v.type, 5000)
        Wait(200) -- Small delay so messages don’t overlap too much
    end
end, false)


-- Test all framework exports
RegisterCommand("testframework", function()
    -- 1️⃣ Test notifications
    local testMessages = {
        {msg = "Info notification test!", type = "info"},
        {msg = "Success notification test!", type = "success"},
        {msg = "Warning notification test!", type = "warning"},
        {msg = "Error notification test!", type = "error"}
    }

    for _, v in pairs(testMessages) do
        exports["mobz-dependencies"]:Notify(v.msg, v.type, 5000)
        Wait(200)
    end

    -- 2️⃣ Test GetPlayer
    local playerData = exports["mobz-dependenciesV2"]:GetPlayer_cl()
    if playerData then
        print("[TestFramework] Player data retrieved:")
        print(json.encode(playerData, {indent = true}))
        exports["mobz-dependencies"]:Notify("Player data retrieved! Check console.", "success", 4000)
    else
        exports["mobz-dependencies"]:Notify("Failed to retrieve player data!", "error", 4000)
    end

    -- 3️⃣ Test HasItem
    local testItem = "water" -- replace with an item name you have
    local hasItem = exports["mobz-dependenciesV2"]:HasItem(testItem, 1)
    if hasItem then
        exports["mobz-dependencies"]:Notify("You have at least 1 " .. testItem .. "!", "success", 4000)
    else
        exports["mobz-dependencies"]:Notify("You do NOT have a " .. testItem .. "!", "warning", 4000)
    end
end, false)

--[[
local fwClient = Modules["framework_client"]

RegisterCommand("myjob", function()
    local pdata = fwClient.GetPlayerData()
    if fwClient.Type == "qb" then
        print("QB Job:", pdata.job.name)
    elseif fwClient.Type == "esx" then
        print("ESX Job:", pdata.job.name)
    else
        print("No framework found.")
    end
end)
--]]