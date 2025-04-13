local dealershipVehicles = {
    {model = "a90sh", x = 2736.19, y = 3469.45, z = 56.09, heading = 337.08},
    {model = "nm_m5e60", x = 2732.66, y = 3465.27, z = 55.46, heading = 68.11},
    {model = "merse63", x = 2738.68, y = 3487.98, z = 55.76, heading = 158.25},
    {model = "911turbos", x = 2750.25, y = 3508.03, z = 55.31, heading = 67.09},
    {model = "dawnonyx", x = 2749.58, y = 3501.62, z = 55.22, heading = 157.41},
    {model = "mz_mx5", x = 2737.69, y = 3479.12, z = 59.15, heading = 67.12},
    {model = "16charger", x = 2709.73, y = 3455.83, z = 59.53, heading = 246.43},
    {model = "gt2rs", x = 2715.19, y = 3461.34, z = 59.42, heading = 157.07},
    {model = "nm_hellbeast", x = 2736.41, y = 3475.65, z = 59.32, heading = 66.83},
    {model = "nm_drkchgr", x = 2740.61, y = 3496.62, z = 59.01, heading = 156.65},
}

local spawnedVehicles = {}

-- Spawn the dealership vehicles
function SpawnDealershipVehicles()
    for _, v in pairs(dealershipVehicles) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(10)
        end

        local vehicle = CreateVehicle(GetHashKey(v.model), v.x, v.y, v.z, v.heading, false, false)
        SetEntityInvincible(vehicle, true)
        SetVehicleDoorsLocked(vehicle, 2)
        FreezeEntityPosition(vehicle, true)
        SetVehicleNumberPlateText(vehicle, "LuxuryPA")
        SetVehicleDirtLevel(vehicle, 0.0)
        SetVehicleFixed(vehicle)
        table.insert(spawnedVehicles, vehicle)
    end
end

-- Event to handle spawning vehicles (triggered by server)
RegisterNetEvent("spawnDealershipVehicles")
AddEventHandler("spawnDealershipVehicles", function()
    -- Remove existing vehicles
    for _, veh in ipairs(spawnedVehicles) do
        if DoesEntityExist(veh) then
            DeleteEntity(veh)
        end
    end
    spawnedVehicles = {}

    -- Spawn the dealership vehicles again
    SpawnDealershipVehicles()
end)

-- Command to reset vehicles (for client use)
RegisterCommand("resetdealership", function()
    TriggerServerEvent("resetDealershipVehicles")  -- Trigger the event on the server to reset the vehicles
end, false)
