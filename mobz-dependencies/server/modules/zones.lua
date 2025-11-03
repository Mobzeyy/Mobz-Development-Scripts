local Zones = {}
Zones.zones = {}

-- Create zones
function Zones.CreateCircle(name, center, radius)
    Zones.zones[name] = {type="circle", center=center, radius=radius}
    TriggerClientEvent("zones:sync", -1, Zones.zones)
end

function Zones.CreateBox(name, center, length, width, heading)
    Zones.zones[name] = {type="box", center=center, length=length, width=width, heading=heading or 0.0}
    TriggerClientEvent("zones:sync", -1, Zones.zones)
end

function Zones.CreatePoly(name, points)
    Zones.zones[name] = {type="poly", points=points}
    TriggerClientEvent("zones:sync", -1, Zones.zones)
end

-- Save to JSON
function Zones.Save(filename)
    filename = filename or "zones.json"
    local jsonData = json.encode(Zones.zones, {indent=true})
    SaveResourceFile(GetCurrentResourceName(), filename, jsonData, -1)
    print("[Zones] Saved zones to " .. filename)
end

-- Load from JSON
function Zones.Load(filename)
    filename = filename or "zones.json"
    local content = LoadResourceFile(GetCurrentResourceName(), filename)
    if content then
        local success, data = pcall(json.decode, content)
        if success then
            Zones.zones = data
            TriggerClientEvent("zones:sync", -1, Zones.zones)
            print("[Zones] Loaded zones from " .. filename)
        else
            print("[Zones] Failed to decode JSON")
        end
    else
        print("[Zones] File not found: " .. filename)
    end
end


-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("Zones", Zones)
if Config.Debug then print("[mobz-dependencies] (Server-side) Zones module loaded") end


-- Exports
exports("CreateCircle", function(name, center, radius) Zones.CreateCircle(name, center, radius) end)
exports("CreateBox", function(name, center, length, width, heading) Zones.CreateBox(name, center, length, width, heading) end)
exports("CreatePoly", function(name, points) Zones.CreatePoly(name, points) end)
exports("Save", function(filename) Zones.Save(filename) end)
exports("Load", function(filename) Zones.Load(filename) end)
