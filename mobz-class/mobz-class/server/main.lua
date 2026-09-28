local QBCore
local ESX

-- =========================================================
-- FRAMEWORK DETECTION
-- =========================================================

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
end

local Framework = nil

if QBCore then
    Framework = 'qbcore'
elseif ESX then
    Framework = 'esx'
end

print(('[mobz-jobselector] Framework detected: %s'):format(
    Framework or 'NONE'
))


-- =========================================================
-- JOB COOLDOWN
-- =========================================================

local JobCooldowns = {}


-- =========================================================
-- SET JOB
-- =========================================================

RegisterNetEvent('mobz-jobselector:setJob', function(job)

    local src = source

    if not job or job == '' then
        return
    end

    -- Make sure a supported framework exists
    if not Framework then
        print('[mobz-jobselector] ERROR: No supported framework detected.')
        return
    end


    -- =====================================================
    -- COOLDOWN
    -- =====================================================

    local currentTime = os.time()
    local lastUsed = JobCooldowns[src]

    if lastUsed then

        local elapsed = currentTime - lastUsed
        local remaining = Config.JobCooldown - elapsed

        if remaining > 0 then

            if Framework == 'qbcore' then

                TriggerClientEvent(
                    'QBCore:Notify',
                    src,
                    ('You must wait %d seconds before changing your job again.'):format(
                        remaining
                    ),
                    'error'
                )

            elseif Framework == 'esx' then

                TriggerClientEvent(
                    'esx:showNotification',
                    src,
                    ('You must wait %d seconds before changing your job again.'):format(
                        remaining
                    )
                )

            end

            return
        end
    end


    -- =====================================================
    -- QBCORE
    -- =====================================================

    if Framework == 'qbcore' then

        local Player = QBCore.Functions.GetPlayer(src)

        if not Player then
            return
        end

        Player.Functions.SetJob(job, 0)

        -- Only start cooldown after successful job change
        JobCooldowns[src] = currentTime

        TriggerClientEvent(
            'QBCore:Notify',
            src,
            ('Your job has been changed to %s. You can change jobs again in %d seconds.'):format(
                job,
                Config.JobCooldown
            ),
            'success'
        )


    -- =====================================================
    -- ESX
    -- =====================================================

    elseif Framework == 'esx' then

        local xPlayer = ESX.GetPlayerFromId(src)

        if not xPlayer then
            return
        end

        xPlayer.setJob(job, 0)

        -- Only start cooldown after successful job change
        JobCooldowns[src] = currentTime

        TriggerClientEvent(
            'esx:showNotification',
            src,
            ('Your job has been changed to %s. You can change jobs again in %d seconds.'):format(
                job,
                Config.JobCooldown
            )
        )

    end
end)


-- =========================================================
-- CLEANUP
-- =========================================================

AddEventHandler('playerDropped', function()
    JobCooldowns[source] = nil
end)