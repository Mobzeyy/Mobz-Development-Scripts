-- mobz-dependencies/server/player.lua

local playerModule = {}
local fw = Modules["framework"]

-------------------------------------------------
-- 🔹 Internal Helpers
-------------------------------------------------
local function GetPlayerIdentifier(src)
    local ids = GetPlayerIdentifiers(src)
    return ids[1] or ("temp:" .. tostring(src))
end

-------------------------------------------------
-- 🔹 Internal Helpers
-------------------------------------------------
local function NotifyPlayer(src, msg, typ, time)
    exports["mobz-dependencies"]:NotifyPlayer(src, msg, typ or "info", time or 5000)
end

-------------------------------------------------
-- 🔹 Money
-------------------------------------------------
function playerModule.GiveMoney(src, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then return false end

    if Config.Inventory == "qb" and fw.Type == "qb" then
        local Player = fw.GetPlayer(src)
        if Player then Player.Functions.AddMoney("cash", amount) end
    elseif Config.Inventory == "esx" and fw.Type == "esx" then
        local xPlayer = fw.GetPlayer(src)
        if xPlayer then xPlayer.addMoney(amount) end
    elseif Config.Inventory == "ox_inventory" and exports.ox_inventory then
        exports.ox_inventory:AddItem(src, "money", amount)
    end

    NotifyPlayer(src, ("You received $%s"):format(amount), "success")
    return true
end

-------------------------------------------------
-- 🔹 Item
-------------------------------------------------
function playerModule.GiveItem(src, itemName, amount)
    amount = tonumber(amount) or 1
    if not itemName or amount <= 0 then return false end

    if Config.Inventory == "qb" and fw.Type == "qb" then
        local Player = fw.GetPlayer(src)
        if Player then Player.Functions.AddItem(itemName, amount) end
    elseif Config.Inventory == "esx" and fw.Type == "esx" then
        local xPlayer = fw.GetPlayer(src)
        if xPlayer then xPlayer.addInventoryItem(itemName, amount) end
    elseif Config.Inventory == "ox_inventory" and exports.ox_inventory then
        exports.ox_inventory:AddItem(src, itemName, amount)
    end

    NotifyPlayer(src, ("You received x%s %s"):format(amount, itemName), "success")
    return true
end


-------------------------------------------------
-- 🔹 Reward Dispatcher
-------------------------------------------------
-- rewardData = { type="money|item", amount=..., name=... }
function playerModule.GiveReward(src, rewardData)
    if not rewardData or type(rewardData) ~= "table" then return false end
    local typ = rewardData.type

    if typ == "money" then
        return playerModule.GiveMoney(src, rewardData.amount)
    elseif typ == "item" then
        return playerModule.GiveItem(src, rewardData.name, rewardData.amount)
    else
        print("[mobz-dependencies] Unknown reward type:", typ)
        return false
    end
end


-- Server: mobz-dependencies/server/player.lua
RegisterNetEvent("mobz-dependencies:server:GiveReward", function(rewardData)
    local src = source
    playerModule.GiveReward(src, rewardData)
end)


-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("Player", playerModule)
if Config.Debug then print("[mobz-dependencies] (Server-side) Player module loaded") end



-- Exports
exports('GiveMoney', function(src, amount) return playerModule.GiveMoney(src, amount) end)
exports('GiveItem', function(src, itemName, amount) return playerModule.GiveItem(src, itemName, amount) end)
exports('GiveReward', function(src, rewardData) return playerModule.GiveReward(src, rewardData) end)
