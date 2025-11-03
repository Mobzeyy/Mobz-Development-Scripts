local NotificationModule = {}

function NotificationModule.NotifyPlayer(src, message, notifType, duration)
    TriggerClientEvent('framework:serverNotify', src, message, notifType, duration)
end

function NotificationModule.NotifyAll(message, notifType, duration)
    for _, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('framework:serverNotify', playerId, message, notifType, duration)
    end
end

-- Client events
RegisterNetEvent("framework:serverNotifyAll", function(message, notifType, duration)
    NotificationModule.NotifyAll(message, notifType, duration)
end)

RegisterNetEvent("framework:serverNotifyPlayer", function(message, notifType, duration)
    local src = source
    NotificationModule.NotifyPlayer(src, message, notifType, duration)
end)

-- Exports
exports('NotifyPlayer', NotificationModule.NotifyPlayer)
exports('NotifyAll', NotificationModule.NotifyAll)

-- Register module
RegisterModule("Notification", NotificationModule)
if Config.Debug then
    print("[mobz-dependencies] (Server-side) Notification module loaded")
end

-- Test command
RegisterCommand("testnotifysss", function(source)
    local testMessages = {
        {msg = "Info notification test!", type = "info"},
        {msg = "Success notification test!", type = "success"},
        {msg = "Warning notification test!", type = "warning"},
        {msg = "Error notification test!", type = "error"}
    }

    for _, v in pairs(testMessages) do
        exports["mobz-dependencies"]:NotifyPlayer(source, v.msg, v.type, 5000)
        Wait(200)
    end 
end, false)



--[[



| Function                 | Usage                                        |
| ------------------------ | -------------------------------------------- |
| `NotifyPlayer(src, msg)` | Sends a notification to a single player      |
| `NotifyAll(msg)`         | Sends the notification to all online players |
| `servernotify` command   | Test command that broadcasts a message       |


-- Somewhere else on server
exports["mobz-dependencies"]:NotifyAll("Event starting in 5 minutes!", "warning", 7000)

-- Notify a specific player (player ID 1)
exports["mobz-dependencies"]:NotifyPlayer(1, "You got a special reward!", "success", 5000)







-- Notify all players from the client
TriggerServerEvent("framework:serverNotifyAll", "Hello everyone!", "success", 5000)

-- Notify only yourself (or a specific player) via server
TriggerServerEvent("framework:serverNotifyPlayer", "Hello you!", "info", 5000)

--]]