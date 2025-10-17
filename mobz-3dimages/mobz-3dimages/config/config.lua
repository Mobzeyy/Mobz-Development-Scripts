Config = {}

-- Debug (show ID + distance)
Config.Debug = false

-- Billboard entries
Config.Billboards = {
    {
        id     = "airport_banner",
        url    = "https://i.postimg.cc/qMcmzC1Z/newa.png", -- must be direct image link
        coords = vec3(-1039.09, -2716.44, 13.78),
        width  = 1.6,  -- world meters
        height = 1.6,  -- leave nil to auto-scale by aspect
        drawDistance = 50.0,
		bounce = nil,
        --bounce = { enabled = true, amplitude = 0.25, speed = 1.0, axis = 'z' }
    },
    {
        id     = "del_perro_promo",
        url    = "https://i.imgur.com/j0Z8G5n.png",
        coords = vec3(-1450.0, -460.0, 35.0),
        width  = 1.6,  -- world meters
        height = 1.6,  -- leave nil to auto-scale by aspect
        drawDistance = 100.0,
		bounce = nil,
    }
}