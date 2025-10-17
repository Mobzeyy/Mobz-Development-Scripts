Config = {}

-- MASTER TOGGLE
Config.SystemActive = true -- Enable or disable the entire script logic

-- POPULATION SETTINGS
Config.PopulationControl = {
    DisableAllAmbientSpawns = true,
    VehicleDensity = 0.1,
    PedDensity = 0.1,
    ParkedDensity = 0.1,
    RandomVehicleDensity = 0.0,
    ScenarioPedDensity = 0.0
}

-- VEHICLE SUPPRESSION
Config.VehicleSuppression = {
    Enabled = true,
    Models = {
        RHINO, LAZER, HYDRA, TITAN, CARGOPLANE, JET, POLICE, POLICE2, POLICE3,
        POLICE4, POLICEB, FBI, FBI2, SHERIFF, SHERIFF2, RIOT, CRUSADER,
        FROGGER, ANNIHILATOR, MAVERICK, SKYLIFT, BUZZARD, HELI, CARGOBOB
    }
}

-- SCENARIO SUPPRESSION
Config.ScenarioSuppression = {
    Enabled = true,
    Types = {
        "WORLD_VEHICLE_POLICE_CAR",
        "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
        "WORLD_VEHICLE_POLICE",
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG"
    }
}

-- CLEANUP SETTINGS
Config.Cleanup = {
    Enabled = false,
    Interval = 60000, -- in milliseconds
    Radius = 100.0,
    RemovePeds = true,
    RemoveVehicles = true
}