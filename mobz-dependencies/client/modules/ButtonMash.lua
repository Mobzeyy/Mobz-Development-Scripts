local buttonMashModule = {}
buttonMashModule.active = false
buttonMashModule.progress = 0
buttonMashModule.maxProgress = 100
buttonMashModule.key = 38
buttonMashModule.speed = 5
buttonMashModule.timeLimit = nil
buttonMashModule.startTime = nil
buttonMashModule.onComplete = nil
buttonMashModule.onFail = nil

-- UI config
buttonMashModule.ui = {
    x = 0.5,
    y = 0.85,
    width = 0.3,
    height = 0.03,
    shake = 0
}

-- Reset state
function buttonMashModule.Reset()
    buttonMashModule.active = false
    buttonMashModule.progress = 0
    buttonMashModule.maxProgress = 100
    buttonMashModule.key = 38
    buttonMashModule.speed = 5
    buttonMashModule.timeLimit = nil
    buttonMashModule.startTime = nil
    buttonMashModule.onComplete = nil
    buttonMashModule.onFail = nil
    buttonMashModule.ui.shake = 0
end

-- Start the mini-game
function buttonMashModule.Start(key, maxProgress, speed, timeLimit, onComplete, onFail)
    if buttonMashModule.active then return end
    buttonMashModule.Reset()
    buttonMashModule.active = true
    buttonMashModule.key = key or 38
    buttonMashModule.maxProgress = maxProgress or 100
    buttonMashModule.speed = speed or 5
    buttonMashModule.timeLimit = timeLimit or nil
    buttonMashModule.startTime = timeLimit and GetGameTimer() or nil
    buttonMashModule.onComplete = onComplete
    buttonMashModule.onFail = onFail
end

-- Draw the progress bar + animated shake
local function DrawBar()
    local ui = buttonMashModule.ui
    local pct = math.min(buttonMashModule.progress / buttonMashModule.maxProgress, 1.0)

    -- Animate shake (decays)
    if ui.shake > 0 then
        ui.shake = ui.shake - 0.5
    end

    local xOffset = (math.random() - 0.5) * ui.shake * 0.01

    -- Background
    DrawRect(ui.x + xOffset, ui.y, ui.width, ui.height, 0, 0, 0, 180)
    -- Foreground
    local w = ui.width * pct
    DrawRect(ui.x - (ui.width/2) + (w/2) + xOffset, ui.y, w, ui.height, 0, 200, 0, 220)

    -- Text above the bar
    SetTextFont(4)
    SetTextScale(0.35,0.35)
    SetTextCentre(true)
    SetTextColour(255,255,255,255)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName("Press E rapidly!")
    EndTextCommandDisplayText(ui.x + xOffset, ui.y - 0.05)
end

-- Thread: Draw loop (only active)
Citizen.CreateThread(function()
    while true do
        if buttonMashModule.active then
            Citizen.Wait(0)
            DrawBar()

            if buttonMashModule.timeLimit then
                local elapsed = (GetGameTimer() - buttonMashModule.startTime)/1000
                if elapsed >= buttonMashModule.timeLimit then
                    local fail = buttonMashModule.onFail
                    buttonMashModule.Reset()
                    if fail then fail() end
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- Thread: Input handling
Citizen.CreateThread(function()
    while true do
        if buttonMashModule.active then
            Citizen.Wait(0)
            if IsControlJustPressed(0, buttonMashModule.key) then
                buttonMashModule.progress = buttonMashModule.progress + buttonMashModule.speed
                buttonMashModule.ui.shake = 3 -- trigger shake effect
                if buttonMashModule.progress >= buttonMashModule.maxProgress then
                    local success = buttonMashModule.onComplete
                    buttonMashModule.Reset()
                    if success then success() end
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- Register module
RegisterModule("ButtonMash", buttonMashModule)
if Config.Debug then print("[mobz-dependencies] (Client-Side) ButtonMash module loaded") end



-- Exports
exports("Start", function(key, maxProgress, speed, timeLimit, onComplete, onFail)
    buttonMashModule.Start(key, maxProgress, speed, timeLimit, onComplete, onFail)
end)


RegisterCommand("test122", function()
    exports['mobz-dependenciesV2']:Start(
        38,    -- key (E)
        100,   -- max progress
        5,     -- per press
        10,    -- seconds
        function() -- success
            TriggerEvent('chat:addMessage', { args = {"[ButtonMash]", "🎉 You won!"} })
        end,
        function() -- fail
            TriggerEvent('chat:addMessage', { args = {"[ButtonMash]", "❌ You failed!"} })
        end
    )
end)


RegisterCommand("test1", function()
    exports['mobz-dependenciesV2']:Start(
        38,    -- key (E)
        100,   -- max progress
        5,     -- per press
        10,    -- seconds
        function() -- success
            TriggerEvent('chat:addMessage', { args = {"[ButtonMash]", "🎉 You won!"} })
        end,
        function() -- fail
            TriggerEvent('chat:addMessage', { args = {"[ButtonMash]", "❌ You failed!"} })
        end
    )
end)
