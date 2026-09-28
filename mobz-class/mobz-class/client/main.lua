
-- Spawn NPCs
CreateThread(function()
    for _, data in pairs(Config.NPCs) do

        -- Load model
        RequestModel(data.model)

        while not HasModelLoaded(data.model) do
            Wait(0)
        end

        -- Spawn NPC
        local ped = CreatePed(
            0,
            data.model,
            data.coords.x,
            data.coords.y,
            data.coords.z,
            data.coords.w,
            false,
            false
        )

        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        -- Disable unwanted ambient behaviour
        SetPedCanRagdoll(ped, false)
        SetPedFleeAttributes(ped, 0, false)
        SetPedCombatAttributes(ped, 46, true)

        -- Play configured animation
        if data.animation then

            RequestAnimDict(data.animation.dict)

            while not HasAnimDictLoaded(data.animation.dict) do
                Wait(0)
            end

            TaskPlayAnim(
                ped,
                data.animation.dict,
                data.animation.anim,
                8.0,
                -8.0,
                -1,
                1,
                0.0,
                false,
                false,
                false
            )

        end


        -- =====================================================
        -- TARGET
        -- =====================================================

        local targetOptions = {
            {
                icon = "fas fa-briefcase",
                label = "Apply for " .. data.job,

                action = function()
                    ConfirmJob(data.job)
                end
            }
        }


        -- =====================================================
        -- AUTO DETECT
        -- =====================================================

        if Config.Target == 'auto' then

            if GetResourceState('ox_target') == 'started' then
                Config.Target = 'ox_target'

            elseif GetResourceState('qb-target') == 'started' then
                Config.Target = 'qb-target'

            else
                print('[mobz-jobselector] ERROR: No target system found.')

            end
        end


        -- =====================================================
        -- OX TARGET
        -- =====================================================

        if Config.Target == 'ox_target' then

            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'mobz_jobselector_' .. data.job,
                    icon = 'fas fa-briefcase',
                    label = 'Apply for ' .. data.job,

                    distance = 2.0,

                    onSelect = function()
                        ConfirmJob(data.job)
                    end
                }
            })


        -- =====================================================
        -- QB TARGET
        -- =====================================================

        elseif Config.Target == 'qb-target' then

            exports['qb-target']:AddTargetEntity(ped, {
                options = targetOptions,
                distance = 2.0
            })

        end
    end
end)

-- Draw floor markers + lights for NPCs
CreateThread(function()
    while true do
        Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, data in pairs(Config.NPCs) do

            local coords = data.coords

            local markerCoords = vector3(
                coords.x,
                coords.y,
                coords.z
            )

            -- Don't render from far away
            local distance = #(playerCoords - markerCoords)

            if distance <= 15.0 then

                -- ==========================================
                -- FLOOR MARKER
                -- ==========================================

                if data.marker and data.marker.enabled then

                    local color = data.marker.color
                    local size = data.marker.size or 1.5

                    DrawMarker(
                        1,
                        markerCoords.x,
                        markerCoords.y,
                        markerCoords.z + 0.02,

                        0.0,
                        0.0,
                        0.0,

                        0.0,
                        0.0,
                        0.0,

                        size,
                        size,
                        0.08,

                        color.r,
                        color.g,
                        color.b,
                        color.a,

                        false,
                        false,
                        2,
                        false,
                        nil,
                        nil,
                        false
                    )
                end


                -- ==========================================
                -- NPC LIGHT
                -- ==========================================

                if data.spotlight and data.spotlight.enabled then

                    local lightColor = data.spotlight.color

                    DrawLightWithRangeAndShadow(
                        coords.x,
                        coords.y,
                        coords.z + (data.spotlight.height or 2.0),

                        lightColor.r,
                        lightColor.g,
                        lightColor.b,

                        data.spotlight.range or 8.0,
                        data.spotlight.intensity or 10.0,

                        data.spotlight.shadow ~= false
                    )
                end
            end
        end
    end
end)

local textureDict = Config.TextureFile

CreateThread(function()
    RequestStreamedTextureDict(textureDict, true)

    while not HasStreamedTextureDictLoaded(textureDict) do
        Wait(100)
    end
end)

CreateThread(function()
    while true do
        Wait(0)

        for _, data in pairs(Config.NPCs) do
            local coords = data.coords
			
            local bannerX = coords.x
            local bannerY = coords.y
            local bannerZ = coords.z + Config.ImageHeight
			
			
            -- Make sure the world position is in front of the camera
            local camCoords = GetGameplayCamCoord()

            local distance = #(vector3(bannerX, bannerY, bannerZ) - camCoords)

            if distance < 15.0 then

                SetDrawOrigin(
                    bannerX,
                    bannerY,
                    bannerZ,
                    0
                )

                DrawSprite(
                    textureDict,
                    data.texture,
                    0.0,
                    0.0,
                    Config.ImageSize.x,
                    Config.ImageSize.y,
                    0.0,
                    255,
                    255,
                    255,
                    255
                )

                ClearDrawOrigin()
            end
        end

        -- Make absolutely sure no draw origin leaks into the next frame
        ClearDrawOrigin()
    end
end)


function ConfirmJob(job)
    local alert = lib.alertDialog({
        header = 'Job Application',
        content = 'Do you want to become a ' .. job .. '?',
        centered = true,
        cancel = true
    })

    if alert == 'confirm' then
        TriggerServerEvent('mobz-jobselector:setJob', job)
        lib.notify({
            title = 'Job Accepted',
            description = 'You are now a ' .. job,
            type = 'success'
        })
    end
end