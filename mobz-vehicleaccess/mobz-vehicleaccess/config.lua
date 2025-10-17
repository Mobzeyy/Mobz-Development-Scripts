Config = {}

-- Framework: 'ESX' or 'QBCore'
Config.Framework = 'QBCore'

-- Time interval (in milliseconds) to check vehicle access
Config.CheckInterval = 1000

-- Message displayed when access is denied
Config.DenyMessage = "You are not authorized to drive this vehicle."

-- Jobs and their allowed vehicles
Config.AllowedJobs = {
    police = { vehicles = { 'police', 'police2' } },
    ambulance = { vehicles = { 'ambulance' } },
    driver = { vehicles = { 'flatbed' } },
}

-- Gangs and their allowed vehicles
Config.AllowedGangs = {
    ballas = { vehicles = { 'baller', 'chino' } },
    vagos = { vehicles = { 'manchez', 'bmx' } },
}


-- Enable or disable debug mode
Config.Debug = false

-- Allow passengers to enter restricted vehicles
Config.AllowPassenger = true

-- Enable or disable gang checks
Config.EnableGangCheck = true

-- Enable or disable job checks
Config.EnableJobCheck = true