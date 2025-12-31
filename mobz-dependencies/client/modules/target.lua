-------------------------------------------------
-- 🔹 mobz-dependencies Target Module
-------------------------------------------------

local TargetModule = {}
local targetType = nil
local fallbackZones = {}
local showing3DText = false

-------------------------------------------------
-- 🔹 Auto-detect Target System
-------------------------------------------------
CreateThread(function()
    if GetResourceState('ox_target') == 'started' then
        targetType = 'ox'
        print('[mobz-dependencies] ✅ ox_target detected and loaded')

    elseif GetResourceState('qb-target') == 'started' then
        targetType = 'qb'
        print('[mobz-dependencies] ✅ qb-target detected and loaded')

    else
        targetType = 'fallback'
        print('[mobz-dependencies] ⚠️ No target system found, using 3D text fallback')
    end
end)

-------------------------------------------------
-- 🔹 Add Target Entity
-------------------------------------------------
function TargetModule.AddTargetEntity(entity, options)
    if not entity or not options then return end

    if targetType == 'ox' then
        exports.ox_target:addLocalEntity(entity, options)

    elseif targetType == 'qb' then
        exports['qb-target']:AddTargetEntity(entity, {
            options = options,
            distance = options.distance or 2.5
        })

    else
        -- Fallback to simple 3D text
        local coords = GetEntityCoords(entity)
        TargetModule.AddFallbackZone("entity_"..entity, coords, options.distance or 2.5, options)
    end
end

-------------------------------------------------
-- 🔹 Add Target Zone
-------------------------------------------------
function TargetModule.AddTargetZone(name, coords, radius, options)
    if not name or not coords or not options then return end

    if targetType == 'ox' then
        exports.ox_target:addSphereZone({
            name = name,
            coords = coords,
            radius = radius or 2.0,
            options = options
        })

    elseif targetType == 'qb' then
        exports['qb-target']:AddCircleZone(name, coords, radius or 2.0, {
            name = name,
            useZ = true
        }, {
            options = options,
            distance = radius or 2.0
        })

    else
        TargetModule.AddFallbackZone(name, coords, radius or 2.0, options)
    end
end

-------------------------------------------------
-- 🔹 Remove Zone
-------------------------------------------------
function TargetModule.RemoveZone(name)
    if not name then return end

    if targetType == 'ox' then
        exports.ox_target:removeZone(name)

    elseif targetType == 'qb' then
        exports['qb-target']:RemoveZone(name)

    elseif fallbackZones[name] then
        fallbackZones[name] = nil
        print(("[mobz-dependencies] 🗑️ Removed fallback zone: %s"):format(name))
    end
end

-------------------------------------------------
-- 🔹 Fallback 3D Text System
-------------------------------------------------
function TargetModule.AddFallbackZone(name, coords, radius, options)
    fallbackZones[name] = {
        coords = coords,
        radius = radius,
        options = options
    }

    if not showing3DText then
        showing3DText = true
        CreateThread(TargetModule._FallbackDrawLoop)
    end

    print(("[mobz-dependencies] 🟢 Added fallback 3D text zone: %s"):format(name))
end

function TargetModule._FallbackDrawLoop()
    while showing3DText do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for name, data in pairs(fallbackZones) do
            local dist = #(playerCoords - data.coords)
            if dist < data.radius + 2.0 then
                sleep = 0
                Draw3DText(data.coords.x, data.coords.y, data.coords.z + 0.15, data.options[1].label or "Interact [E]")
                if IsControlJustPressed(0, 38) then -- [E]
                    local cb = data.options[1].onSelect
                    if cb and type(cb) == "function" then cb() end
                end
            end
        end

        Wait(sleep)
    end
end

function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 100)
    end
end

-------------------------------------------------
-- 🔹 Event Handlers (for TriggerEvent calls)
-------------------------------------------------

RegisterNetEvent('framework:addTargetEntity', function(entity, options)
    TargetModule.AddTargetEntity(entity, options)
end)

RegisterNetEvent('framework:addTargetZone', function(name, coords, radius, options)
    TargetModule.AddTargetZone(name, coords, radius, options)
end)

RegisterNetEvent('framework:removeTargetZone', function(name)
    TargetModule.RemoveZone(name)
end)


-------------------------------------------------
-- 🔹 Register Module + Exports
-------------------------------------------------
RegisterModule("Target", TargetModule)
Modules["Target"] = TargetModule

exports('AddTargetEntity', TargetModule.AddTargetEntity)
exports('AddTargetZone', TargetModule.AddTargetZone)
exports('RemoveZone', TargetModule.RemoveZone)

if Config.Debug then
    print("[mobz-dependencies] (Client) Target module fully initialized")
end


--[[



-- Example: Add target zone near player
CreateThread(function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local coords = playerCoords + vector3(0, 2.0, 0)
    
    local options = {
        {
            icon = "fa-solid fa-horse",
            label = "Open Stable Menu",
            onSelect = function()
                exports['mobz-dependencies']:Notify("Stable menu opened!", "info", 3000)
            end
        }
    }

    exports['mobz-dependencies']:AddTargetZone("StableMenuZone", coords, 2.5, options)
end)


--]]