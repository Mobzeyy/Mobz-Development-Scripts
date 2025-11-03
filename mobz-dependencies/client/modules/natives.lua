-- Mobz Client Natives
MobzNatives = {}


--Error parsing script @mobz-dependencies/client/modules/natives.lua in resource mobz-dependencies: @mobz-dependencies/client/modules/natives.lua:224: '(' expected near '='
--Failed to load script client/modules/natives.lua.

------------------------------------------------------------
-- Player Control
------------------------------------------------------------
function MobzNatives.FreezePlayer(state)
    FreezeEntityPosition(PlayerPedId(), state)
end

function MobzNatives.SetInvincible(state)
    SetEntityInvincible(PlayerPedId(), state)
end

function MobzNatives.SetVisible(state)
    SetEntityVisible(PlayerPedId(), state)
end

function MobzNatives.SetPlayerSpeed(multiplier)
    SetRunSprintMultiplierForPlayer(PlayerId(), multiplier)
end

------------------------------------------------------------
-- Animations
------------------------------------------------------------
-- Play a single animation
function MobzNatives.PlayAnim(ped, dict, anim, duration, flag)
    flag = flag or 1
    duration = duration or -1
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(10) end
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, duration, flag, 0, false, false, false)
end

-- Play a scenario for a duration
function MobzNatives.PlayScenario(ped, scenario, duration)
    TaskStartScenarioInPlace(ped, scenario, 0, true)
    if duration and duration > 0 then
        Citizen.SetTimeout(duration, function()
            ClearPedTasks(ped)
        end)
    end
end

-- Play a sequence of animations with timers
function MobzNatives.PlayAnimSequence(ped, anims)
    Citizen.CreateThread(function()
        for _, data in ipairs(anims) do
            MobzNatives.PlayAnim(ped, data.dict, data.anim, data.duration, data.flag)
            Citizen.Wait(data.duration or 1000)
        end
    end)
end


------------------------------------------------------------
-- Effects at coords
------------------------------------------------------------
-- Play particle effect at coords
function MobzNatives.PlayPtfxAtCoords(name, coords, scale, duration)
    scale = scale or 1.0
    duration = duration or 5000
    UseParticleFxAssetNextCall(name)
    local handle = StartParticleFxLoopedAtCoord(name, coords.x, coords.y, coords.z, 0, 0, 0, scale, false, false, false, false)
    if duration > 0 then
        Citizen.SetTimeout(duration, function() StopParticleFxLooped(handle, 0) end)
    end
    return handle
end

------------------------------------------------------------
-- 3D Text & Help
------------------------------------------------------------
function MobzNatives.ShowHelpText(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

-- Draw text in 3D with optional color and font
function MobzNatives.DrawText3D(coords, text, scale, r, g, b, a)
    scale = scale or 0.35
    r, g, b, a = r or 255, g or 255, b or 255, a or 215
    local x, y, z = table.unpack(coords)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(r, g, b, a)
        SetTextCentre(1)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


------------------------------------------------------------
-- Cameras
------------------------------------------------------------
function MobzNatives.CreateCam(coords, rot, fov)
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, coords.x, coords.y, coords.z)
    SetCamRot(cam, rot.x, rot.y, rot.z, 2)
    SetCamFov(cam, fov or 60.0)
    RenderScriptCams(true, false, 0, true, true)
    return cam
end

function MobzNatives.DestroyCam(cam)
    if cam then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cam, false)
    end
end

------------------------------------------------------------
-- Audio
------------------------------------------------------------
function MobzNatives.PlaySound(sound, volume)
    PlaySoundFrontend(-1, sound, "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    SetFrontendRadioActive(false)
end

------------------------------------------------------------
-- Animations with timer
------------------------------------------------------------
function MobzNatives.PlayAnim(ped, dict, anim, duration, flag)
    flag = flag or 1
    duration = duration or -1
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Citizen.Wait(10) end
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, duration, flag, 0, false, false, false)
end

------------------------------------------------------------
-- Enumerators
------------------------------------------------------------
function MobzNatives.EnumeratePeds()
    return coroutine.wrap(function()
        local handle, ped = FindFirstPed()
        if not handle or handle == -1 then return end
        local success
        repeat
            coroutine.yield(ped)
            success, ped = FindNextPed(handle)
        until not success
        EndFindPed(handle)
    end)
end

function MobzNatives.EnumerateVehicles()
    return coroutine.wrap(function()
        local handle, veh = FindFirstVehicle()
        if not handle or handle == -1 then return end
        local success
        repeat
            coroutine.yield(veh)
            success, veh = FindNextVehicle(handle)
        until not success
        EndFindVehicle(handle)
    end)
end

function MobzNatives.EnumerateObjects()
    return coroutine.wrap(function()
        local handle, obj = FindFirstObject()
        if not handle or handle == -1 then return end
        local success
        repeat
            coroutine.yield(obj)
            success, obj = FindNextObject(handle)
        until not success
        EndFindObject(handle)
    end)
end

------------------------------------------------------------
-- Closest Entity
------------------------------------------------------------
function MobzNatives.ClosestEntity(coords, radius, type)
    local closest, minDist = nil, radius or 5.0
    if type == "ped" then
        for ped in MobzNatives.EnumeratePeds() do
            if ped ~= PlayerPedId() and not IsPedAPlayer(ped) then
                local dist = #(coords - GetEntityCoords(ped))
                if dist < minDist then minDist = dist; closest = ped end
            end
        end
    elseif type == "player" then
        for _, playerId in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(playerId)
            if ped ~= PlayerPedId() then
                local dist = #(coords - GetEntityCoords(ped))
                if dist < minDist then minDist = dist; closest = playerId end
            end
        end
    elseif type == "vehicle" then
        for veh in MobzNatives.EnumerateVehicles() do
            local dist = #(coords - GetEntityCoords(veh))
            if dist < minDist then minDist = dist; closest = veh end
        end
    elseif type == "object" then
        for obj in MobzNatives.EnumerateObjects() do
            local dist = #(coords - GetEntityCoords(obj))
            if dist < minDist then minDist = dist; closest = obj end
        end
    end
    return closest, minDist
end

------------------------------------------------------------
-- Debug
------------------------------------------------------------
function MobzNatives.DrawMarker(coords, type, scale, color)
    DrawMarker(type or 1, coords.x, coords.y, coords.z, 0,0,0,0,0,0, scale.x, scale.y, scale.z, color.r, color.g, color.b, color.a, false, false, 2, false, nil, nil, false)
end

------------------------------------------------------------
-- Entities
------------------------------------------------------------
------------------------------------------------------------
-- Entities
------------------------------------------------------------

-- Delete an entity
MobzNatives.DeleteEntity = function(entity)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
        return true
    end
    return false
end

-- Spawn object
MobzNatives.SpawnObject = function(model, coords, heading)
    local hash = type(model) == "string" and GetHashKey(model) or model
    local obj = CreateObject(hash, coords.x, coords.y, coords.z, true, true, true)
    SetEntityHeading(obj, heading or 0.0)
    return obj
end

-- Spawn ped
MobzNatives.SpawnPed = function(model, coords, heading)
    local hash = type(model) == "string" and GetHashKey(model) or model
    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(10) end
    local ped = CreatePed(4, hash, coords.x, coords.y, coords.z, heading or 0.0, true, false)
    SetEntityAsMissionEntity(ped, true, true)
    return ped
end

-- Spawn a vehicle
MobzNatives.SpawnVehicle = function(model, coords, heading)
    if type(model) == "string" then model = GetHashKey(model) end
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading or 0.0, true, false)
    SetVehicleOnGroundProperly(veh)
    SetModelAsNoLongerNeeded(model)
    return veh
end

-- Delete vehicle safely
MobzNatives.DeleteVehicle = function(veh)
    if DoesEntityExist(veh) then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    end
end


------------------------------------------------------------
-- Exports
------------------------------------------------------------
for name, func in pairs(MobzNatives) do
    exports(name, func)
end


-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("Natives", MobzNatives)
if Config.Debug then print("[mobz-dependencies] (Client-Side) Natives module loaded") end


--[[



-- Draw 3D text
local pos = vector3(0,0,72)
exports['mobz_utilities']:DrawText3D(pos, "Hello World!", 0.5)

-- Play animation
local ped = PlayerPedId()
exports['mobz_utilities']:PlayAnim(ped, "amb@world_human_cheering@male@base", "base", 5000)

-- Closest vehicle
local veh, dist = exports['mobz_utilities']:ClosestEntity(GetEntityCoords(PlayerPedId()), 10, "vehicle")

-- Show mugshot
exports['mobz_utilities']:MugshotPreview("https://i.imgur.com/image.png")
Citizen.Wait(3000)
exports['mobz_utilities']:MugshotHide()


--]]