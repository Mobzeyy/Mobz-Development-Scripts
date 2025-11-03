local PrestigeMultiplier = {}

-- Config
PrestigeMultiplier.Settings = {
    maxItemMultiplier = 5.0,      -- max number of extra items
    maxCooldownMultiplier = 5.0,  -- max speedup for cooldowns
    maxTimeMultiplier = 5.0,      -- max extra time for buffs
}

-- Lazy load mobz-prestiged API
local function GetPrestigeAPI()
    if not PrestigeMultiplier.API then
        local exp = exports["mobz-prestiged"]
        if exp and exp.PrestigeAPI then
            PrestigeMultiplier.API = exp.PrestigeAPI()
        else
            print("^1[Mobz Dependencies]^7 Prestige API not found.")
        end
    end
    return PrestigeMultiplier.API
end

-- 🔹 Get multiplier safely
local function GetPlayerMultiplier(identifier)
    local api = GetPrestigeAPI()
    if not api then return 1.0 end

    local pdata = api.GetFullStats(identifier)
    if not pdata or not pdata.multiplier then
        return 1.0
    end

    return pdata.multiplier
end

-- 🔹 Items multiplier
function PrestigeMultiplier.GetItemMultiplier(identifier)
    local mult = GetPlayerMultiplier(identifier)
    return math.min(mult, PrestigeMultiplier.Settings.maxItemMultiplier)
end

function PrestigeMultiplier.ApplyItems(baseAmount, identifier)
    local mult = PrestigeMultiplier.GetItemMultiplier(identifier)
    return math.floor(baseAmount * mult)
end

-- 🔹 Cooldown multiplier (speed up progress bars, etc.)
function PrestigeMultiplier.GetCooldownMultiplier(identifier)
    local mult = GetPlayerMultiplier(identifier)
    return math.min(mult, PrestigeMultiplier.Settings.maxCooldownMultiplier)
end

function PrestigeMultiplier.ApplyCooldown(baseTime, identifier)
    local mult = PrestigeMultiplier.GetCooldownMultiplier(identifier)
    return baseTime / mult -- higher multiplier → faster cooldowns
end

-- 🔹 Time multiplier (buffs, effect durations, etc.)
function PrestigeMultiplier.GetTimeMultiplier(identifier)
    local mult = GetPlayerMultiplier(identifier)
    return math.min(mult, PrestigeMultiplier.Settings.maxTimeMultiplier)
end

function PrestigeMultiplier.ApplyTime(baseTime, identifier)
    local mult = PrestigeMultiplier.GetTimeMultiplier(identifier)
    return baseTime * mult -- higher multiplier → longer buffs/effects
end

-- Export API
exports("PrestigeMultiplierAPI", function()
    return PrestigeMultiplier
end)


-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("PrestigeMultiplier", PrestigeMultiplier)
if Config.Debug then print("[mobz-dependencies] (Server-side) Prestige Multiplier module loaded") end


--[[


2️⃣ Using Cooldown Multiplier (Progress Bars / Timers)

Anywhere you have a cooldown or timer:

local Multi = Modules["prestige_multiplier"]
local identifier = GetPrimaryIdentifier(source)

local baseCooldown = 120 -- seconds
local adjustedCooldown = Multi.ApplyCooldown(baseCooldown, identifier)

-- Use adjustedCooldown in your timer
StartTimer(adjustedCooldown)


Higher multiplier = faster cooldown

Works for crafting, skills, or any timed system

3️⃣ Using Time Multiplier (Buffs / Effects)

For any buffs, temporary XP boosts, stamina, or other timed effects:

local Multi = Modules["prestige_multiplier"]
local identifier = GetPrimaryIdentifier(source)

local baseBuffTime = 60 -- seconds
local extendedTime = Multi.ApplyTime(baseBuffTime, identifier)

-- Apply buff/effect for extendedTime
ApplyBuffToPlayer(source, "stamina_boost", extendedTime)


Higher multiplier = longer buffs/effects

Works for armor boosts, temporary speed, or other timed effects





2️⃣ Using Cooldown Multiplier (Progress Bars / Timers)

Anywhere you have a cooldown or timer:

local Multi = Modules["prestige_multiplier"]
local identifier = GetPrimaryIdentifier(source)

local baseCooldown = 120 -- seconds
local adjustedCooldown = Multi.ApplyCooldown(baseCooldown, identifier)

-- Use adjustedCooldown in your timer
StartTimer(adjustedCooldown)


Higher multiplier = faster cooldown

Works for crafting, skills, or any timed system

3️⃣ Using Time Multiplier (Buffs / Effects)

For any buffs, temporary XP boosts, stamina, or other timed effects:

local Multi = Modules["prestige_multiplier"]
local identifier = GetPrimaryIdentifier(source)

local baseBuffTime = 60 -- seconds
local extendedTime = Multi.ApplyTime(baseBuffTime, identifier)

-- Apply buff/effect for extendedTime
ApplyBuffToPlayer(source, "stamina_boost", extendedTime)


Higher multiplier = longer buffs/effects

Works for armor boosts, temporary speed, or other timed effects

--]]