local ProgressBarModule = {}

function ProgressBarModule.ProgressBar(text, duration, disableControls)
    duration = duration or 5000
    disableControls = disableControls or false

    local fw = Modules["frameworkClient"]
    if not fw then
        print("[ProgressBar] ⚠ frameworkClient module not loaded!")
        Wait(duration)
        TriggerEvent("progressbar:finished")
        return
    end

    -- Wait until the framework is detected
    local timeout = 5000
    local start = GetGameTimer()
    while fw.Type == "none" and GetGameTimer() - start < timeout do
        Wait(10)
    end

    -- QB-Core
    if fw.Type == "qb" and Config.ProgressBar == "qb" then
        local QBCoreObj = exports['qb-core']:GetCoreObject()
        if QBCoreObj and QBCoreObj.Functions.Progressbar then
            QBCoreObj.Functions.Progressbar(
                "mobz_action",
                text,
                duration,
                false,
                disableControls,
                {}, {}, {}, {},
                function()
                    TriggerEvent("progressbar:finished")
                end
            )
            return
        end

		-- ESX
    elseif fw.Type == "esx" and Config.ProgressBar == "esx" then
        local ESXObj = fw.GetPlayer_cl()
        if ESXObj and ESXObj.Progressbar then
            ESXObj.Progressbar(text, duration, {}, function()
                TriggerEvent("progressbar:finished")
            end)
            return
        end


		-- ox_lib
    elseif Config.ProgressBar == "ox_lib" then
        if GetResourceState('ox_lib') == 'started' then
            exports.ox_lib:progressBar({
                duration = duration,
                label = text,
                --disable = disableControls
            })
            return
        else
            print("[ProgressBar] ⚠ ox_lib not started yet!")
        end
	
    elseif Config.ProgressBar == "standalone" then
		CreateThread(function()
			local startTime = GetGameTimer()
			local endTime = startTime + duration
			local alpha = 220
			local fadeDuration = 500

			local width = 0.32
			local height = 0.04
			local x = 0.5
			local y = 0.92
			local radius = 0.01

			-- Easing function (ease-out cubic)
			local function EaseOutCubic(t)
				return 1 - math.pow(1 - t, 3)
			end

			-- Draw rounded rectangle helper
			local function DrawRoundedRect(centerX, centerY, w, h, r, color)
				local rC,gC,bC,aC = table.unpack(color)
				DrawRect(centerX, centerY, w - r*2, h, rC,gC,bC,aC)
				DrawRect(centerX, centerY, w, h - r*2, rC,gC,bC,aC)
				DrawRect(centerX - w/2 + r/2, centerY - h/2 + r/2, r, r, rC,gC,bC,aC)
				DrawRect(centerX + w/2 - r/2, centerY - h/2 + r/2, r, r, rC,gC,bC,aC)
				DrawRect(centerX - w/2 + r/2, centerY + h/2 - r/2, r, r, rC,gC,bC,aC)
				DrawRect(centerX + w/2 - r/2, centerY + h/2 - r/2, r, r, rC,gC,bC,aC)
			end

			-- Progress bar animation
			while GetGameTimer() < endTime do
				local now = GetGameTimer()
				local t = math.min(1.0, (now - startTime) / duration)
				local progress = EaseOutCubic(t)

				-- Background
				DrawRoundedRect(x, y, width, height, radius, {0,0,0,200})
				-- Green fill
				DrawRoundedRect(x - width/2 + progress*width/2, y, width*progress, height, radius, {0,200,0,alpha})
				-- Text
				SetTextFont(4)
				SetTextScale(0.35, 0.35)
				SetTextCentre(true)
				SetTextColour(255,255,255,alpha)
				BeginTextCommandDisplayText("STRING")
				AddTextComponentString(string.format("%s - %d%%", text, math.floor(progress*100)))
				EndTextCommandDisplayText(x, y - 0.03)

				Wait(0)
			end

			-- Fade-out
			local fadeStart = GetGameTimer()
			while alpha > 0 do
				local now = GetGameTimer()
				local elapsed = now - fadeStart
				alpha = math.max(0, 220 - (220 * (elapsed / fadeDuration)))

				-- Background
				DrawRoundedRect(x, y, width, height, radius, {0,0,0,200})
				-- Fill (full)
				DrawRoundedRect(x, y, width, height, radius, {0,200,0,alpha})
				-- Text
				SetTextFont(4)
				SetTextScale(0.35,0.35)
				SetTextCentre(true)
				SetTextColour(255,255,255,alpha)
				BeginTextCommandDisplayText("STRING")
				AddTextComponentString(text)
				EndTextCommandDisplayText(x, y - 0.03)

				Wait(0)
			end

			TriggerEvent("progressbar:finished")
		end)
    else
        -- Minimal fallback (print only)
        print(string.format("[ProgressBar] %s (%dms)", text, duration))
        Wait(duration)
        TriggerEvent("progressbar:finished")
    end
end


exports("ProgressBar", function(text, duration, disableControls)
    return ProgressBarModule.ProgressBar(text, duration, disableControls)
end)

-------------------------------------------------
-- 🔹 Register Module
-------------------------------------------------
RegisterModule("ProgressBar", ProgressBarModule)
if Config.Debug then print("[mobz-dependencies] (Client-Side) ProgressBar module loaded") end



--✅ Usage Examples

--From any script using the export:

-- Simple test command
RegisterCommand("testbar", function()
    exports['mobz-dependencies']:ProgressBar("Working...", 5000, true)
end)


--From internal modules:

--local pb = Modules["ProgressBar"]
--pb.ProgressBar("Crafting item...", 4000, true)




--✅ Example 1: Simple action command
-- client/test_progress.lua
RegisterCommand("repair", function()
    -- Call via export
    exports['mobz-dependencies']:ProgressBar("Repairing vehicle...", 5000, true)

    
end)

-- Listen for finish event
    AddEventHandler("progressbar:finished", function()
        --exports['notifications']:Notify("Vehicle repaired!", "success", 3000)
		print('CKECK FINISH')
    end)
--What happens:

--Progress bar shows for 5 seconds using your configured framework.

--When finished, a notification appears.

--disableControls is passed to the framework (true in QB-Core or ox_lib will freeze the player if supported).

--✅ Example 2: Crafting system
RegisterCommand("craftpotion", function()
    -- Using Modules table
    local pb = Modules["ProgressBar"]
    pb.ProgressBar("Crafting potion...", 7000, true)

    AddEventHandler("progressbar:finished", function()
        exports['notifications']:Send("Potion crafted!", "success", 3000)
    end)
end)


--Notes:

--Works entirely through your module.

--Other scripts just need to reference Modules["ProgressBar"] if in the same resource.

--✅ Example 3: Mining with conditional result
RegisterCommand("mine", function()
    exports['mobz-dependencies']:ProgressBar("Mining rock...", 6000, true)

    AddEventHandler("progressbar:finished", function()
        local rare = math.random(1, 10) > 7
        if rare then
            exports['notifications']:Send("You found a rare gem!", "success", 3000)
        else
            exports['notifications']:Send("Just some ore.", "info", 3000)
        end
    end)
end)


--This shows how to hook game logic after the progress bar finishes.

--Fully decoupled from the module itself.

--✅ Example 4: Washing a car (another resource)
RegisterCommand("washcar", function()
    exports['mobz-dependencies']:ProgressBar("Washing car...", 4000, true)

    AddEventHandler("progressbar:finished", function()
        exports['notifications']:Send("Car washed!", "success", 2500)
    end)
end)


--Any other resource can call the exported function; doesn’t need to access Modules directly.

--✅ Example 5: Checking if a progress bar is running (optional)
RegisterCommand("checkprogress", function()
    local pb = Modules["ProgressBar"]
    if pb then
        print("Progress bar is available and ready to use!")
    else
        print("Progress bar module not loaded.")
    end
end)


















	--✅ Example 1: Freeze player for “hard” actions
	
-- Heavy action like repairing or mining
RegisterCommand("mineore", function()
    -- Pass disableControls = true
    exports['mobz-dependencies']:ProgressBar("Mining rock...", 7000, true)

    AddEventHandler("progressbar:finished", function()
        exports['notifications']:Send("You mined some ore!", "success", 3000)
    end)
end)


--	Player movement is frozen because disableControls = true.

--	Ideal for single-player focused actions.

--	✅ Example 2: Soft action like zone capturing (no freeze)
	-- Action that should not block the player
RegisterCommand("capturezone", function()
    -- Pass disableControls = false
    exports['mobz-dependencies']:ProgressBar("Capturing zone...", 5000, false)

    AddEventHandler("progressbar:finished", function()
        exports['notifications']:Send("Zone captured!", "success", 3000)
    end)
end)


--	Player can still move, shoot, interact.

--	Works dynamically depending on the script’s logic.

--	✅ Example 3: Conditional freeze based on context

RegisterCommand("dynamicaction", function()
    local freeze = math.random(0,1) == 1 -- Example: randomize freeze
    exports['mobz-dependencies']:ProgressBar("Doing dynamic action...", 6000, freeze)

    AddEventHandler("progressbar:finished", function()
        if freeze then
            exports['notifications']:Send("Action done while frozen!", "success", 3000)
        else
            exports['notifications']:Send("Action done while moving freely!", "info", 3000)
        end
    end)
end)

--[[

	This shows dynamic control per call.

	No changes are needed inside your module — the disableControls argument controls everything.

	✅ Key Points

	disableControls is passed per call — scripts can decide if the player should be frozen.
	No module modification needed; the API stays clean and modular.
	You can combine it with any type of action (crafting, zone capturing, mining, etc.).
	Events (progressbar:finished) allow scripts to trigger logic when the action completes.
	
--]]