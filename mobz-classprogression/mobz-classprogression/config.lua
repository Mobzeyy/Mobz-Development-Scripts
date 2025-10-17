Config = {}


-- ONLY IF YOU HAVE xperience [https://github.com/Mobius1/xperience/releases/tag/0.3.2]
-- FOR AUTOMATIC GRADE PROGRESSION


--	ADD TO xperience/common/ranks.lua 
--  Trigger this Event when you like grade promotions 

--TriggerServerEvent("mobz:playerRankedUp", newLevel, oldLevel)


--EXAMPLE AT LEVEL 2 / 800 XP POINTS
--[[
	[2] = {
        XP = 800, -- The XP required to reach this rank
        Action = function(rankUp, player)
            TriggerServerEvent("mobz:playerRankedUp", newLevel, oldLevel)

            print(rankUp, player)
        end
    },
--]]

-- add xp
--exports.xperience:AddXP(10) -- will add 10

-- XP-based job promotion from xperience/common/ranks.lua 
Config.JobPromotions = {
    [5] = { job = "mechanic","driver","scavenger", grade = 1 }, -- level 5xp jobs will get grade1
	[10] = { job = "mechanic","driver","scavenger", grade = 2 },
	[15] = { job = "mechanic","driver","scavenger", grade = 3 },
	[20] = { job = "mechanic","driver","scavenger", grade = 4 },
	[25] = { job = "mechanic","driver","scavenger", grade = 5 },
	[30] = { job = "mechanic","driver","scavenger", grade = 6 },
	[35] = { job = "mechanic","driver","scavenger", grade = 7 },

}

Config.EnableDiscordLog = true
Config.DiscordWebhook = "https://discord.com/api/webhooks/1391480866655436820/RpWgV10XeE25-XQXR3R5TYQtqo2fNCLL2rjiC8yIg6Ld7CLyQNDk4WFDw8Xuju_aBFsm"

-- General Settings
Config.TextDistance = 10.0
Config.InteractKey = 38 -- [E]
Config.TextUI = '[E] - Open Job Center'
Config.Webhook = 'https://discord.com/api/webhooks/1391480866655436820/RpWgV10XeE25-XQXR3R5TYQtqo2fNCLL2rjiC8yIg6Ld7CLyQNDk4WFDw8Xuju_aBFsm'


-- Job Selection Points
Config.JobCenters = {
    {
		model = 'a_m_m_hasjew_01',
        coords = vector3(-2336.4, 275.08, 169.46-1), -- PUT -1 AFTER 3RD VECTOR IF NPC IS NOT ON THE GROUND
		heading = 134.90,
		
		animation = {
            dict = "anim@amb@nightclub@djs@dixon@",
            name = "sol_dance_l_sol"
        },
		scenarios = 'WORLD_HUMAN_CLIPBOARD',
		
        blip = {
            enabled = true,
            sprite = 351,
            color = 3,
            scale = 0.7,
            label = 'Job Selector',
        },
        image = 'https://i.postimg.cc/RZrBFgCH/ZOMBIEWAR.png', -- ADD IMAGE LINK
        title = 'Downtown Job Center',
        description = 'Select a job that suits you best!',
        jobs = {
            {
                job = 'medic',
                label = 'Medic Class',
                description = 'ADD INFORMATION',
                icon = 'car',
                iconColor = '#f1c40f',
                dialogue = 'Lights, camera, action!'
            },
            {
                job = 'scavenger',
                label = 'Scavenger Class',
                description = 'ADD INFORMATION',
                icon = 'newspaper',
                iconColor = '#e67e22',
                dialogue = 'Lights, camera, action!'
            },
            {
                job = 'driver',
                label = 'Driver Class',
                description = 'ADD INFORMATION',
                icon = 'dumpster',
                iconColor = '#2ecc71',
                dialogue = 'Lights, camera, action!'
            }
        }
    }
}