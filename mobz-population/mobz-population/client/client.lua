local lastCleanup = GetGameTimer()


local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, {__gc = function(e)
            if e.destructor and e.handle then
                e.destructor(e.handle)
            end
        end})

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
        disposeFunc(iter)
    end)
end

local function EnumeratePeds() return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed) end
local function EnumerateVehicles() return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle) end

-- Cleanup Logic
local function DeleteEntitySafe(entity)
    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
    end
end

local function PerformCleanup()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if Config.Cleanup.RemovePeds then
        for ped in EnumeratePeds() do
            if not IsPedAPlayer(ped) and #(coords - GetEntityCoords(ped)) < Config.Cleanup.Radius then
                DeleteEntitySafe(ped)
            end
        end
    end

    if Config.Cleanup.RemoveVehicles then
        for vehicle in EnumerateVehicles() do
            if #(coords - GetEntityCoords(vehicle)) < Config.Cleanup.Radius then
                local driver = GetPedInVehicleSeat(vehicle, -1)
                if not IsPedAPlayer(driver) then
                    DeleteEntitySafe(vehicle)
                end
            end
        end
    end
end


CreateThread(function()
    while true do
        Wait(0)
        if not Config.SystemActive then return end


        if Config.PopulationControl.DisableAllAmbientSpawns then
            SetVehicleDensityMultiplierThisFrame(Config.PopulationControl.VehicleDensity)
            SetPedDensityMultiplierThisFrame(Config.PopulationControl.PedDensity)
            SetRandomVehicleDensityMultiplierThisFrame(Config.PopulationControl.RandomVehicleDensity)
            SetParkedVehicleDensityMultiplierThisFrame(Config.PopulationControl.ParkedDensity)
            SetScenarioPedDensityMultiplierThisFrame(Config.PopulationControl.ScenarioPedDensity, Config.PopulationControl.ScenarioPedDensity)
        end


        if Config.VehicleSuppression.Enabled then
            for _, model in ipairs(Config.VehicleSuppression.Models) do
                SetVehicleModelIsSuppressed(model, true)
            end
        end


        if Config.ScenarioSuppression.Enabled then
            for _, scenario in ipairs(Config.ScenarioSuppression.Types) do
                SetScenarioTypeEnabled(scenario, false)
            end
        end


        if Config.Cleanup.Enabled and GetGameTimer() - lastCleanup >= Config.Cleanup.Interval then
            PerformCleanup()
            lastCleanup = GetGameTimer()
        end
    end
end)
