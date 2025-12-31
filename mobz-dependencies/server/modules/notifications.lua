local NotificationModule = {}

function NotificationModule.NotifyPlayer(src, message, notifType, duration)
    TriggerClientEvent('framework:clientNotify', src, message, notifType, duration)
end

function NotificationModule.NotifyAll(message, notifType, duration)
    for _, playerId in ipairs(GetPlayers()) do
        TriggerClientEvent('framework:clientNotify', playerId, message, notifType, duration)
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


--[[

4️⃣ Corrected example usage
Server-side:
-- Notify a single player
local src = 1
exports["mobz-dependencies"]:NotifyPlayer(src, "Hello Cowboy!", "success", 5000)

-- Notify all players
exports["mobz-dependencies"]:NotifyAll("Server-wide info!", "info", 5000)


Client-side:
-- Notify yourself via server
TriggerServerEvent('framework:serverNotifyPlayer', "Hi, you got a notification!", "success", 5000)
-- Notify everyone via server
TriggerServerEvent('framework:serverNotifyAll', "Hello everyone!", "info", 5000)


2️⃣ Using Export (client-side only)
-- Anywhere on the client
exports['mobz-dependencies']:Notify("Hello from Export!", "info", 5000)

-- Anywhere on the client
TriggerEvent('framework:clientNotify', "Hello from TriggerEvent!", "success", 5000)


--]]


-- Exports
exports('NotifyPlayer', NotificationModule.NotifyPlayer)
exports('NotifyAll', NotificationModule.NotifyAll)

-- Register module
RegisterModule("Notification", NotificationModule)
if Config.Debug then
    print("[mobz-dependencies] (Server-side) Notification module loaded")
end


Modules["Notification"] = NotificationModule


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

-- so like this?
-- Inside mobz-dependencies/modules/progressbar/client.lua
--local notify = Modules["NotificationModule"]
--notify:Send("Progress started!")


--[[




-- Client-side usage
local notify = Modules["Notification"]

-- Send to the local player
notify.NotifyPlayer(PlayerId(), "Progress started!", "info", 5000)

-- Send to everyone
notify.NotifyAll("The server says hi!", "info", 5000)
4️⃣ Optional: Make it a bit cleaner with a local wrapper
lua
Copy code
local Notify = Modules["Notification"]

-- Now you can call easily
Notify.NotifyPlayer(PlayerId(), "Hello!", "success", 3000)
Notify.NotifyAll("Global alert!", "warning", 5000)





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