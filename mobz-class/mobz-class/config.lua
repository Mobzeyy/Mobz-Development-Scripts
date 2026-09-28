Config = {}

Config.Framework = 'auto'
-- 'auto'
-- 'qbcore'
-- 'esx'


Config.Target = 'auto'
-- 'auto'
-- 'qb-target'
-- 'ox_target'

Config.JobCooldown = 60


Config.TextureFile = 'class_banner'
Config.ImageHeight = 2.5
Config.ImageSize = {
    x = 0.15,
    y = 0.15
}

-- NPC + image setup
Config.NPCs = {
    {
        model = 's_m_m_paramedic_01',
        coords = vector4(-409.97, 1090.82, 327.68-1, 57.57),
        job = 'ambulance',
        texture = 'medic',
		
		animation = {
            dict = 'amb@world_human_stand_mobile@male@text@base',
            anim = 'base'
        },
		
		spotlight = {
			enabled = true,
			color = {
				r = 50,
				g = 150,
				b = 255
			},
			range = 2.0,
			intensity = 10.0,
			height = 1.0
		},
		
        marker = {
            enabled = true,
            color = { r = 50, g = 150, b = 255, a = 180 },
            size = 1.5
        }
    },

    {
        model = 's_m_y_garbage',
        coords = vector4(-415.25, 1092.06, 327.68-1, 337.73),
        job = 'scavenger',
        texture = 'scavenger',
		
		animation = {
            dict = 'amb@world_human_smoking@male@male_a@base',
            anim = 'base'
        },
		
		spotlight = {
			enabled = true,
			color = {
				r = 120,
				g = 120,
				b = 129
			},
			range = 2.0,
			intensity = 10.0,
			height = 1.0
		},
		
        marker = {
            enabled = true,
            color = { r = 120, g = 120, b = 120, a = 180 },
            size = 1.5
        }
    },

    {
        model = 's_m_y_xmech_02',
        coords = vector4(-420.06, 1093.25, 327.68-1, 341.63),
        job = 'mechanic',
        texture = 'engineer',
		
		animation = {
            dict = 'amb@world_human_clipboard@male@base',
            anim = 'base'
        },
		
		spotlight = {
			enabled = true,
			color = {
				r = 255,
				g = 170,
				b = 40
			},
			range = 2.0,
			intensity = 10.0,
			height = 1.0
		},
		
        marker = {
            enabled = true,
            color = { r = 255, g = 170, b = 40, a = 180 },
            size = 1.5
        }
    }
}