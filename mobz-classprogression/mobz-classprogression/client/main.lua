local QBCore = exports['qb-core']:GetCoreObject()

local npc = nil

CreateThread(function()
    for _, data in pairs(Config.JobCenters) do
		--local data = Config.JobCenters
		local model = data.model

		RequestModel(model)
		while not HasModelLoaded(model) do Wait(0) end

		npc = CreatePed(4, model, data.coords.x, data.coords.y, data.coords.z, data.heading, false, true)

		SetEntityAsMissionEntity(npc, true, true)
		SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
		TaskStartScenarioInPlace(npc, data.scenarios, 7000, true)

		
		SetPedCanRagdoll(npc, false)
		SetPedAlertness(npc, 0)
		SetPedCombatAttributes(npc, 46, true)
		SetPedFleeAttributes(npc, 0, false)
		
		--PlaceObjectOnGroundProperly(npc)
		Wait(200)
		FreezeEntityPosition(npc, true)
		PlaceObjectOnGroundProperly(npc)
		
        if data.blip.enabled then
            local blip = AddBlipForCoord(data.coords)
            SetBlipSprite(blip, data.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, data.blip.scale)
            SetBlipColour(blip, data.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(data.blip.label)
            EndTextCommandSetBlipName(blip)
        end
		
		PlaceObjectOnGroundProperly(npc)
    end
end)


local function deleteNPC()
    if DoesEntityExist(npc) then
        DeleteEntity(npc)
        npc = nil
    end
end

AddEventHandler('mobz:onresourcerestart', function()
	deleteNPC()
end)

CreateThread(function()
    while true do
        local sleep = 1500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, data in pairs(Config.JobCenters) do
            local dist = #(coords - data.coords)
            if dist < Config.TextDistance then
                sleep = 0
                DrawText3D(data.coords, Config.TextUI)
                if dist < 2.0 and IsControlJustPressed(0, Config.InteractKey) then
                    OpenJobMenu(data)
                end
            end
        end
        Wait(sleep)
    end
end)

function OpenJobMenu(center)
    local options = {}
    for _, job in ipairs(center.jobs) do
        options[#options+1] = {
            title = job.label,
            description = job.description,
            icon = job.icon,
            iconColor = job.iconColor,
            image = center.image,
            onSelect = function()
                TriggerServerEvent('mobz:setJob', job.job)
                lib.notify({
                    title = 'Job Selected',
                    description = job.dialogue,
                    type = 'success'
                })
            end
        }
    end

    lib.registerContext({
        id = 'job_selector',
        title = center.title,
        description = center.description,
        options = options,
        image = center.image
    })

    lib.showContext('job_selector')
end

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)
        SetTextColour(255, 255, 255, 215)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

