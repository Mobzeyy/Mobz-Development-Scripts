local PrestigeMultiplierClient = {}

function PrestigeMultiplierClient.GetItemMultiplier()
    local exp = exports["mobz-prestiged"]
    if exp and exp.PrestigeAPI then
        local pdata = exp.PrestigeAPI().GetFullStats()
        return pdata and pdata.multiplier or 1.0
    end
    return 1.0
end

function PrestigeMultiplierClient.GetCooldownMultiplier()
    local exp = exports["mobz-prestiged"]
    if exp and exp.PrestigeAPI then
        local pdata = exp.PrestigeAPI().GetFullStats()
        return pdata and pdata.multiplier or 1.0
    end
    return 1.0
end

function PrestigeMultiplierClient.GetTimeMultiplier()
    local exp = exports["mobz-prestiged"]
    if exp and exp.PrestigeAPI then
        local pdata = exp.PrestigeAPI().GetFullStats()
        return pdata and pdata.multiplier or 1.0
    end
    return 1.0
end

-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("PrestigeMultiplier", PrestigeMultiplierClient)
if Config.Debug then print("[mobz-dependencies] (Client-Side) Prestige Multiplier module loaded") end
