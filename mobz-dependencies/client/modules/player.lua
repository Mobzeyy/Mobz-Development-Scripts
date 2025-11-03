local playerModule = {}

-------------------------------------------------
-- 🔹 Internal Helpers
-------------------------------------------------
local function Notify(message, type, duration)
    type = type or "info"
    duration = duration or 5000
    if lib and lib.notify then
        lib.notify({ title = "Player", description = message, type = type, duration = duration })
    else
        print(("[Notify] [%s]: %s"):format(type:upper(), message))
        TriggerEvent("chat:addMessage", {
            color = {255, 255, 0},
            multiline = true,
            args = {"Player", message}
        })
    end
end

-------------------------------------------------
-- 🔹 Client Requests to Server
-------------------------------------------------
function playerModule.RequestReward(rewardData)
    if not rewardData or type(rewardData) ~= "table" then return end
    TriggerServerEvent("mobz-dependencies:server:GiveReward", rewardData)
end


-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("Player", playerModule)
if Config.Debug then print("[mobz-dependencies] (Client-Side) Player module loaded") end



-- Exports for other client scripts
exports('RequestReward', function(rewardData) return playerModule.RequestReward(rewardData) end)


--[[


2️⃣ Safe server-side events

In your server module, create events that your client module calls:

-- Server: mobz-dependencies/server/player.lua
RegisterNetEvent("mobz-dependencies:server:GiveReward", function(rewardData)
    local src = source
    playerModule.GiveReward(src, rewardData)
end)

RegisterNetEvent("mobz-dependencies:server:GiveTokens", function(amount)
    local src = source
    playerModule.GiveTokens(src, amount)
end)

RegisterNetEvent("mobz-dependencies:server:SpendTokens", function(amount)
    local src = source
    playerModule.SpendTokens(src, amount)
end)


✅ Now your client scripts only call exports or trigger these events. The server handles all actual changes safely.

3️⃣ Example client usage
-- Give player a reward
exports['mobz-dependencies']:RequestReward({
    type = "item",
    name = "kevlar",
    amount = 1
})

-- Give 5 tokens
exports['mobz-dependencies']:RequestGiveTokens(5)

-- Spend 3 tokens
exports['mobz-dependencies']:RequestSpendTokens(3)


--]]