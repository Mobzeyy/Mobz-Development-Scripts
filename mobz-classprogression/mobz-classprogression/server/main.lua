local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('mobz:setJob', function(job)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    Player.Functions.SetJob(job, 0)

    if Config.Webhook then
        SendJobLogToDiscord(Player.PlayerData.name, job, Player.PlayerData.citizenid)
    end
end)

function SendJobLogToDiscord(playerName, job, citizenId)
    if not Config.Webhook or Config.Webhook == '' then return end

    local embed = {{
        ["color"] = 3447003,
        ["title"] = "🧾 Job Selected",
        ["description"] = ("**Player:** %s\n**CID:** `%s`\n**Job:** `%s`\n**Time:** <t:%d:F>"):format(
            playerName, citizenId, job, os.time()
        ),
        ["footer"] = { ["text"] = "Job Selector Logs • QB-Core" }
    }}

    PerformHttpRequest(Config.Webhook, function(err) end, 'POST', json.encode({
        username = "Job Selector Logs",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("mobz:playerRankedUp", function(newLevel, oldLevel)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local promotion = Config.JobPromotions[newLevel]
    if not promotion then return end

    local currentJob = Player.PlayerData.job.name
    local currentGrade = Player.PlayerData.job.grade.level

    if currentJob == promotion.job and currentGrade >= promotion.grade then return end

    Player.Functions.SetJob(promotion.job, promotion.grade)

    if Config.EnableDiscordLog then
        sendDiscordLog(Player.PlayerData.name, promotion.job, promotion.grade, newLevel)
    end
end)

function sendDiscordLog(playerName, job, grade, level)
    local msg = {
        username = "XP Promotion Logger",
        embeds = {{
            title = "🎉 Job Promotion",
            description = string.format("**%s** has been promoted to **%s** (Grade %s) at XP level **%s**.",
                playerName, job, grade, level),
            color = 65352
        }}
    }

    PerformHttpRequest(Config.DiscordWebhook, function() end, "POST",
        json.encode(msg),
        { ["Content-Type"] = "application/json" })
end


AddEventHandler('onResourceStart', function(resourceName)
	local src = source
	TriggerClientEvent("mobz:onresourcerestart", src)
end)

--TriggerServerEvent("xp:playerRankedUp", newLevel, oldLevel)
