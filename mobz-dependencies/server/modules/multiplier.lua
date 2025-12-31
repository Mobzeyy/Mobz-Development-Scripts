local PrestigeMultiplier = {}

-- Config
PrestigeMultiplier.Settings = {
    maxCooldownMultiplier = 5.0,
    maxTimeMultiplier     = 5.0,
}

-- Generate level-based multipliers for cooldown & time (1 → 200)
PrestigeMultiplier.LevelMultipliers = {}
for level = 1, 200 do
    PrestigeMultiplier.LevelMultipliers[level] = {
        cooldownMultiplier = 1.0 + (level / 200) * (PrestigeMultiplier.Settings.maxCooldownMultiplier - 1.0),
        timeMultiplier     = 1.0 + (level / 200) * (PrestigeMultiplier.Settings.maxTimeMultiplier - 1.0),
    }
end

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

-- 🔹 Get player data safely
local function GetPlayerMultiplier(identifier)
    local api = GetPrestigeAPI()
    if not api then
        return {itemMultiplier=1, cooldownMultiplier=1.0, timeMultiplier=1.0}
    end

    local pdata = api.GetFullStats(identifier)
    if not pdata or not pdata.level then
        return {itemMultiplier=1, cooldownMultiplier=1.0, timeMultiplier=1.0}
    end

    local level = math.min(math.max(pdata.level, 1), 200)
    local multipliers = PrestigeMultiplier.LevelMultipliers[level]

    -- Determine tiered item multiplier
    local itemMultiplier = 1
    if level >= 50 and level < 100 then
        itemMultiplier = 2
    elseif level >= 100 and level < 150 then
        itemMultiplier = 3
    elseif level >= 150 and level < 200 then
        itemMultiplier = 3
    elseif level == 200 then
        itemMultiplier = 4
    end

    multipliers.itemMultiplier = itemMultiplier
    return multipliers
end

-- 🔹 Item multiplier
function PrestigeMultiplier.GetItemMultiplier(identifier)
    return GetPlayerMultiplier(identifier).itemMultiplier
end

function PrestigeMultiplier.ApplyItems(baseAmount, identifier)
    local mult = PrestigeMultiplier.GetItemMultiplier(identifier)
    return baseAmount * mult
end

-- 🔹 Cooldown multiplier
function PrestigeMultiplier.GetCooldownMultiplier(identifier)
    return GetPlayerMultiplier(identifier).cooldownMultiplier
end

function PrestigeMultiplier.ApplyCooldown(baseTime, identifier)
    local mult = PrestigeMultiplier.GetCooldownMultiplier(identifier)
    return baseTime / mult
end

-- 🔹 Time multiplier (buffs)
function PrestigeMultiplier.GetTimeMultiplier(identifier)
    return GetPlayerMultiplier(identifier).timeMultiplier
end

function PrestigeMultiplier.ApplyTime(baseTime, identifier)
    local mult = PrestigeMultiplier.GetTimeMultiplier(identifier)
    return baseTime * mult
end

-- Export API
exports("PrestigeMultiplierAPI", function()
    return PrestigeMultiplier
end)

-- Register Module
RegisterModule("PrestigeMultiplier", PrestigeMultiplier)
if Config.Debug then 
    print("[mobz-dependencies] (Server-side) Prestige Multiplier module loaded") 
end


--[[

Item multiplier now follows your tier system:

Level 1–49 → 1 item

Level 50–99 → 2 items

Level 100–149 → 3 items

Level 150–199 → 3 items

Level 200 → 4 items

Cooldown and Time multipliers still scale smoothly from 1 → 5.


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




| Level | Items | Cooldown Multiplier | Time Multiplier |
| ----- | ----- | ------------------- | --------------- |
| 1     | 1     | 1.00                | 1.00            |
| 2     | 1     | 1.02                | 1.02            |
| 3     | 1     | 1.04                | 1.04            |
| 4     | 1     | 1.06                | 1.06            |
| 5     | 1     | 1.08                | 1.08            |
| 6     | 1     | 1.10                | 1.10            |
| 7     | 1     | 1.12                | 1.12            |
| 8     | 1     | 1.14                | 1.14            |
| 9     | 1     | 1.16                | 1.16            |
| 10    | 1     | 1.18                | 1.18            |
| 11    | 1     | 1.20                | 1.20            |
| 12    | 1     | 1.22                | 1.22            |
| 13    | 1     | 1.24                | 1.24            |
| 14    | 1     | 1.26                | 1.26            |
| 15    | 1     | 1.28                | 1.28            |
| 16    | 1     | 1.30                | 1.30            |
| 17    | 1     | 1.32                | 1.32            |
| 18    | 1     | 1.34                | 1.34            |
| 19    | 1     | 1.36                | 1.36            |
| 20    | 1     | 1.38                | 1.38            |
| 21    | 1     | 1.40                | 1.40            |
| 22    | 1     | 1.42                | 1.42            |
| 23    | 1     | 1.44                | 1.44            |
| 24    | 1     | 1.46                | 1.46            |
| 25    | 1     | 1.48                | 1.48            |
| 26    | 1     | 1.50                | 1.50            |
| 27    | 1     | 1.52                | 1.52            |
| 28    | 1     | 1.54                | 1.54            |
| 29    | 1     | 1.56                | 1.56            |
| 30    | 1     | 1.58                | 1.58            |
| 31    | 1     | 1.60                | 1.60            |
| 32    | 1     | 1.62                | 1.62            |
| 33    | 1     | 1.64                | 1.64            |
| 34    | 1     | 1.66                | 1.66            |
| 35    | 1     | 1.68                | 1.68            |
| 36    | 1     | 1.70                | 1.70            |
| 37    | 1     | 1.72                | 1.72            |
| 38    | 1     | 1.74                | 1.74            |
| 39    | 1     | 1.76                | 1.76            |
| 40    | 1     | 1.78                | 1.78            |
| 41    | 1     | 1.80                | 1.80            |
| 42    | 1     | 1.82                | 1.82            |
| 43    | 1     | 1.84                | 1.84            |
| 44    | 1     | 1.86                | 1.86            |
| 45    | 1     | 1.88                | 1.88            |
| 46    | 1     | 1.90                | 1.90            |
| 47    | 1     | 1.92                | 1.92            |
| 48    | 1     | 1.94                | 1.94            |
| 49    | 1     | 1.96                | 1.96            |
| 50    | 2     | 1.98                | 1.98            |
| 51    | 2     | 2.00                | 2.00            |
| 52    | 2     | 2.02                | 2.02            |
| 53    | 2     | 2.04                | 2.04            |
| 54    | 2     | 2.06                | 2.06            |
| 55    | 2     | 2.08                | 2.08            |
| 56    | 2     | 2.10                | 2.10            |
| 57    | 2     | 2.12                | 2.12            |
| 58    | 2     | 2.14                | 2.14            |
| 59    | 2     | 2.16                | 2.16            |
| 60    | 2     | 2.18                | 2.18            |
| 61    | 2     | 2.20                | 2.20            |
| 62    | 2     | 2.22                | 2.22            |
| 63    | 2     | 2.24                | 2.24            |
| 64    | 2     | 2.26                | 2.26            |
| 65    | 2     | 2.28                | 2.28            |
| 66    | 2     | 2.30                | 2.30            |
| 67    | 2     | 2.32                | 2.32            |
| 68    | 2     | 2.34                | 2.34            |
| 69    | 2     | 2.36                | 2.36            |
| 70    | 2     | 2.38                | 2.38            |
| 71    | 2     | 2.40                | 2.40            |
| 72    | 2     | 2.42                | 2.42            |
| 73    | 2     | 2.44                | 2.44            |
| 74    | 2     | 2.46                | 2.46            |
| 75    | 2     | 2.48                | 2.48            |
| 76    | 2     | 2.50                | 2.50            |
| 77    | 2     | 2.52                | 2.52            |
| 78    | 2     | 2.54                | 2.54            |
| 79    | 2     | 2.56                | 2.56            |
| 80    | 2     | 2.58                | 2.58            |
| 81    | 2     | 2.60                | 2.60            |
| 82    | 2     | 2.62                | 2.62            |
| 83    | 2     | 2.64                | 2.64            |
| 84    | 2     | 2.66                | 2.66            |
| 85    | 2     | 2.68                | 2.68            |
| 86    | 2     | 2.70                | 2.70            |
| 87    | 2     | 2.72                | 2.72            |
| 88    | 2     | 2.74                | 2.74            |
| 89    | 2     | 2.76                | 2.76            |
| 90    | 2     | 2.78                | 2.78            |
| 91    | 2     | 2.80                | 2.80            |
| 92    | 2     | 2.82                | 2.82            |
| 93    | 2     | 2.84                | 2.84            |
| 94    | 2     | 2.86                | 2.86            |
| 95    | 2     | 2.88                | 2.88            |
| 96    | 2     | 2.90                | 2.90            |
| 97    | 2     | 2.92                | 2.92            |
| 98    | 2     | 2.94                | 2.94            |
| 99    | 2     | 2.96                | 2.96            |
| 100   | 2     | 2.98                | 2.98            |
| 101   | 3     | 3.00                | 3.00            |
| 102   | 3     | 3.02                | 3.02            |
| …     | …     | …                   | …               |
| 150   | 3     | 4.00                | 4.00            |
| 151   | 3     | 4.02                | 4.02            |
| 199   | 3     | 4.98                | 4.98            |
| 200   | 4     | 5.00                | 5.00            |



--]]