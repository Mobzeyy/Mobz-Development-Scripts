-- mobz-dependencies/client/modules/callbacks.lua
local CallbackModule = {}
local ClientCallbacks = {}
local PendingRequests = {}
local RequestId = 0

local function NewRequestId()
    RequestId += 1
    return RequestId
end

-----------------------------------------
-- Trigger server callback (client → server)
-----------------------------------------
function CallbackModule.TriggerServerCallback(name, cb, ...)
    local requestId = NewRequestId()
    PendingRequests[requestId] = cb
    TriggerServerEvent("mobz:serverCallback", name, requestId, ...)
end

RegisterNetEvent("mobz:serverCallbackResponse", function(requestId, result)
    local cb = PendingRequests[requestId]
    if cb then
        cb(result)
        PendingRequests[requestId] = nil
    end
end)

-----------------------------------------
-- Await-style callback (client waits for server)
-----------------------------------------
function CallbackModule.TriggerServerCallbackAwait(name, ...)
    local p = promise.new()
    CallbackModule.TriggerServerCallback(name, function(result)
        p:resolve(result)
    end, ...)
    return Citizen.Await(p)
end

-----------------------------------------
-- Register client callback (for server calls)
-----------------------------------------
function CallbackModule.RegisterClientCallback(name, fn)
    ClientCallbacks[name] = fn
    print(("[mobz-callbacks] Registered client callback: %s"):format(name))
end

RegisterNetEvent("mobz:clientCallback", function(name, requestId, ...)
    local callback = ClientCallbacks[name]
    if not callback then
        print(("[mobz-callbacks] Warning: Missing client callback '%s'"):format(name))
        TriggerServerEvent("mobz:clientCallbackResponse", requestId, nil)
        return
    end

    callback(function(result)
        TriggerServerEvent("mobz:clientCallbackResponse", requestId, result)
    end, ...)
end)



-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("callbacks", CallbackModule)
if Config.Debug then print("[mobz-dependencies] (Client-Side) Callback module loaded") end


exports("TriggerServerCallback", function(name, cb, ...)
    CallbackModule.TriggerServerCallback(name, cb, ...)
end)

exports("TriggerServerCallbackAwait", function(name, ...)
    return CallbackModule.TriggerServerCallbackAwait(name, ...)
end)

exports("RegisterClientCallback", function(name, fn)
    CallbackModule.RegisterClientCallback(name, fn)
end)


--[[



🧪 Usage Examples
🔹 Client → Server Callback (normal)
exports['mobz-dependencies']:TriggerServerCallback('GetMoney', function(money)
    print('You have $' .. money)
end)

🔹 Client → Server Callback (await)
local money = exports['mobz-dependencies']:TriggerServerCallbackAwait('GetMoney')
print('You have $' .. money)


--]]