local genderModule = {}

-- Detect framework
local FrameworkType = Modules["framework"] and Modules["framework"].Type or "none"

-- Get player gender
-- If playerPed is nil, defaults to local player
function genderModule.GetGender(playerPed)
    playerPed = playerPed or PlayerPedId()

    -- Check framework metadata first
    if FrameworkType == "qb" and QBCore then
        local playerId = GetPlayerServerId(PlayerId())
        local Player = QBCore.Functions.GetPlayerData()
        if Player and Player.charinfo and Player.charinfo.gender then
            return Player.charinfo.gender == 1 and "male" or "female"
        end
    elseif FrameworkType == "esx" and ESX then
        local playerData = ESX.GetPlayerData()
        if playerData and playerData.sex then
            return playerData.sex == "m" and "male" or "female"
        end
    end

    -- Fallback: check ped model
    local model = GetEntityModel(playerPed)

    local malePeds = {
        `mp_m_freemode_01`, `a_m_m_skater_01`, `a_m_m_business_01`, `a_m_y_business_01`
    }

    local femalePeds = {
        `mp_f_freemode_01`, `a_f_m_beach_01`, `a_f_y_business_01`, `a_f_y_hipster_01`
    }

    for _, pedHash in pairs(malePeds) do
        if model == pedHash then return "male" end
    end

    for _, pedHash in pairs(femalePeds) do
        if model == pedHash then return "female" end
    end

    return "unknown"
end

Modules["gender"] = genderModule


-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("gender", genderModule)
if Config.Debug then print("[mobz-dependencies] (Client-Side) Gender module loaded") end


-- Export for other client scripts
exports('GetGender', function(playerPed) return genderModule.GetGender(playerPed) end)


--[[


2️⃣ Example Usage
Get local player gender
local gender = exports['your_framework_resource']:GetGender()
print("My gender is: "..gender)

Get another player’s gender
local targetPed = GetPlayerPed(GetPlayerFromServerId(2))
local gender = exports['your_framework_resource']:GetGender(targetPed)
print("Target player gender: "..gender)


--]]