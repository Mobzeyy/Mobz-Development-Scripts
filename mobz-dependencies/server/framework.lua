
-- mobz-dependencies/server/framework.lua
local frameworkModule = {}
local QBCore, ESX
-- Global registry for modules
Modules = {}

-- Helper function to register a module
function RegisterModule(name, module)
    Modules[name] = module
    print(("[mobz-dependencies] (Server-Side-FrameWork) Module registered: %s"):format(name))
end

frameworkModule.Type = 'none'

CreateThread(function()
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        frameworkModule.Type = 'qb'
        frameworkModule.GetPlayer = function(src)
            return QBCore.Functions.GetPlayer(src)
        end
        print('[Framework] ✅ Using QB-Core')
        return
    end

    if GetResourceState('es_extended') == 'started' then
        -- Check for Legacy ESX export first
        local status, obj = pcall(function()
            return exports['es_extended']:getSharedObject()
        end)

        if status and obj then
            ESX = obj
        else
            -- fallback for older ESX versions
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
        end

        frameworkModule.Type = 'esx'
        frameworkModule.GetPlayer = function(src)
            if ESX then return ESX.GetPlayerFromId(src) end
        end
        print('[Framework] ✅ Using ESX (Legacy or Classic)')
        return
    end

    -- if neither is running
    frameworkModule.Type = 'none'
    print('[Framework] ⚠️ No supported framework detected!')
end)


function frameworkModule.GetPlayer(playerId)
    if frameworkModule.Type == 'qb' then return QBCore.Functions.GetPlayer(playerId)
    elseif frameworkModule.Type == 'esx' then return ESX.GetPlayerFromId(playerId) end
end

function frameworkModule.GetPlayers()
    if frameworkModule.Type == 'qb' then return QBCore.Functions.GetPlayers()
    elseif frameworkModule.Type == 'esx' then return ESX.GetPlayers() end
    return {}
end

Modules["framework"] = frameworkModule

-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("frameworkModule", frameworkModule)
if Config.Debug then print("[mobz-dependencies] (Client-Framework) frameworkServer module loaded") end


-- Exportable functions
exports('GetPlayer', function(playerId) return frameworkModule.GetPlayer(playerId) end)
exports('GetPlayers', function() return frameworkModule.GetPlayers() end)


return frameworkModule