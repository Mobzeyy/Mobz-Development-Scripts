-- mobz-dependencies/server/modules/callbacks.lua
local CallbackModule = {}
local ServerCallbacks = {}
local PendingRequests = {}
local RequestId = 0

local function NewRequestId()
    RequestId += 1
    return RequestId
end

-----------------------------------------
-- Register a server callback
-----------------------------------------
function CallbackModule.CreateCallback(name, fn)
    ServerCallbacks[name] = fn
    print(("[mobz-callbacks] Registered server callback: %s"):format(name))
end

-----------------------------------------
-- Handle client → server callback requests
-----------------------------------------
RegisterNetEvent("mobz:serverCallback", function(name, requestId, ...)
    local src = source
    local callback = ServerCallbacks[name]

    if not callback then
        print(("[mobz-callbacks] Warning: Missing server callback '%s'"):format(name))
        TriggerClientEvent("mobz:serverCallbackResponse", src, requestId, nil)
        return
    end

    callback(src, function(result)
        TriggerClientEvent("mobz:serverCallbackResponse", src, requestId, result)
    end, ...)
end)

-----------------------------------------
-- Trigger a client callback (server → client)
-----------------------------------------
function CallbackModule.TriggerClientCallback(target, name, cb, ...)
    local requestId = NewRequestId()
    PendingRequests[requestId] = cb
    TriggerClientEvent("mobz:clientCallback", target, name, requestId, ...)
end

RegisterNetEvent("mobz:clientCallbackResponse", function(requestId, result)
    local cb = PendingRequests[requestId]
    if cb then
        cb(result, source)
        PendingRequests[requestId] = nil
    end
end)

-----------------------------------------
-- Await-style client callback (blocking)
-----------------------------------------
function CallbackModule.TriggerClientCallbackAwait(target, name, ...)
    local p = promise.new()
    CallbackModule.TriggerClientCallback(target, name, function(result)
        p:resolve(result)
    end, ...)
    return Citizen.Await(p)
end



-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("Callbacks", CallbackModule)
if Config.Debug then print("[mobz-dependencies] (Server-side) Callbacks module loaded") end



exports("CreateCallback", function(name, fn)
    CallbackModule.CreateCallback(name, fn)
end)

exports("TriggerClientCallback", function(target, name, cb, ...)
    CallbackModule.TriggerClientCallback(target, name, cb, ...)
end)

exports("TriggerClientCallbackAwait", function(target, name, ...)
    return CallbackModule.TriggerClientCallbackAwait(target, name, ...)
end)



--[[


🔹 Server → Client Callback (normal)
exports['mobz-dependencies']:TriggerClientCallback(1, 'GetCoords', function(coords)
    print(json.encode(coords))
end)

🔹 Server → Client Callback (await)
local coords = exports['mobz-dependencies']:TriggerClientCallbackAwait(1, 'GetCoords')
print(json.encode(coords))



-- server/modules/example.lua
exports['mobz-dependencies']:CreateCallback('GetMoney', function(source, cb)
    local xPlayer = exports['mobz-dependencies']:GetPlayer(source)
    cb(xPlayer and xPlayer.getMoney and xPlayer:getMoney() or 0)
end)

-- client/modules/example.lua
exports['mobz-dependencies']:RegisterClientCallback('GetCoords', function(cb)
    local coords = GetEntityCoords(PlayerPedId())
    cb({ x = coords.x, y = coords.y, z = coords.z })
end)



| Function                                        | Side   | Description                             |
| ----------------------------------------------- | ------ | --------------------------------------- |
| `CreateCallback(name, fn)`                      | Server | Register a server callback              |
| `TriggerServerCallback(name, cb, ...)`          | Client | Trigger a server callback (async)       |
| `TriggerServerCallbackAwait(name, ...)`         | Client | Trigger a server callback (await style) |
| `RegisterClientCallback(name, fn)`              | Client | Register a client callback              |
| `TriggerClientCallback(target, name, cb, ...)`  | Server | Trigger client callback (async)         |
| `TriggerClientCallbackAwait(target, name, ...)` | Server | Trigger client callback (await style)   |

--]]