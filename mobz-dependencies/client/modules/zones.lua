local zonesModule = {}
zonesModule.zones = {}

-- Sync zones from server
RegisterNetEvent("zones:sync")
AddEventHandler("zones:sync", function(data)
    zonesModule.zones = data
end)

-- Debug options
zonesModule.debug = {
    enabled = false,
    drawColors = {inside = {0,255,0,100}, outside = {255,0,0,100}}
}

function zonesModule.SetDebug(state)
    zonesModule.debug.enabled = state
end

function zonesModule.SetDebugColors(insideColor, outsideColor)
    zonesModule.debug.drawColors.inside = insideColor or zonesModule.debug.drawColors.inside
    zonesModule.debug.drawColors.outside = outsideColor or zonesModule.debug.drawColors.outside
end

-- Check if player is inside a zone
function zonesModule.IsPlayerInZone(name)
    local zone = zonesModule.zones[name]
    if not zone then return false end
    local plyCoords = GetEntityCoords(PlayerPedId())

    if zone.type == "circle" then
        return #(plyCoords - zone.center) <= zone.radius
    elseif zone.type == "box" then
        local dx, dy, dz = plyCoords.x - zone.center.x, plyCoords.y - zone.center.y, plyCoords.z - zone.center.z
        return math.abs(dx) <= zone.length/2 and math.abs(dy) <= zone.width/2 and math.abs(dz) < 5.0
    elseif zone.type == "poly" then
        local x, y = plyCoords.x, plyCoords.y
        local inside = false
        local j = #zone.points
        for i=1, #zone.points do
            local xi, yi = zone.points[i].x, zone.points[i].y
            local xj, yj = zone.points[j].x, zone.points[j].y
            if ((yi > y) ~= (yj > y)) and (x < (xj-xi)*(y-yi)/(yj-yi+0.00001)+xi) then
                inside = not inside
            end
            j = i
        end
        return inside
    end
    return false
end

-- Draw loop for debug visualization
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(zonesModule.debug.enabled and 0 or 1000)
        if zonesModule.debug.enabled then
            local plyCoords = GetEntityCoords(PlayerPedId())
            for name, zone in pairs(zonesModule.zones) do
                local inside = zonesModule.IsPlayerInZone(name)
                local color = inside and zonesModule.debug.drawColors.inside or zonesModule.debug.drawColors.outside

                if zone.type == "circle" then
                    DrawMarker(28, zone.center.x, zone.center.y, zone.center.z-1, 0,0,0,0,0,0, zone.radius*2, zone.radius*2, 1.0, color[1],color[2],color[3],color[4],false,true,2,false,nil,nil,false)
                elseif zone.type == "box" then
                    DrawMarker(1, zone.center.x, zone.center.y, zone.center.z-1, 0,0,0,0,0,zone.heading, zone.length, zone.width, 1.0, color[1],color[2],color[3],color[4],false,true,2,false,nil,nil,false)
                elseif zone.type == "poly" then
                    for i=1,#zone.points do
                        local p1,p2 = zone.points[i], zone.points[i % #zone.points + 1]
                        DrawLine(p1.x,p1.y,p1.z,p2.x,p2.y,p2.z,color[1],color[2],color[3],color[4])
                    end
                end
            end
        end
    end
end)


-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("Zones", zonesModule)
if Config.Debug then print("[mobz-dependencies] (Client-Side) zones module loaded") end


-- Exports
exports('IsPlayerInZone', function(name) return zonesModule.IsPlayerInZone(name) end)
exports('SetDebug', function(state) zonesModule.SetDebug(state) end)
exports('SetDebugColors', function(inside, outside) zonesModule.SetDebugColors(inside, outside) end)


--[[


exports['mobz-dependencies']:CreateCircle("TestCircle", vector3(200,300,31), 10)
exports['mobz-dependencies']:Save()  -- Save to JSON
exports['mobz-dependencies']:Load()  -- Load and sync to clients

-- Client
local inside = exports['mobz-dependencies']:IsPlayerInZone("TestCircle")
exports['mobz-dependencies']:SetDebug(true)


--]]