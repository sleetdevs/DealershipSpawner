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
local authorizedUsers = { "discord:527163965793370125" }  -- List of users authorized to reset the dealership

-- Event listener for adding a vehicle to the dealership
RegisterNetEvent("addDealershipVehicle")
AddEventHandler("addDealershipVehicle", function(model, x, y, z, heading)
    local vehicle = {model = model, x = x, y = y, z = z, heading = heading}
    table.insert(dealershipVehicles, vehicle)
    TriggerClientEvent("spawnDealershipVehicles", -1)  -- Trigger client to spawn vehicles again
end)

-- Event listener for removing a vehicle from the dealership
RegisterNetEvent("removeDealershipVehicle")
AddEventHandler("removeDealershipVehicle", function(vehicleIndex)
    table.remove(dealershipVehicles, vehicleIndex)
    TriggerClientEvent("spawnDealershipVehicles", -1)  -- Trigger client to spawn vehicles again
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)  -- Check every second

        for _, veh in ipairs(spawnedVehicles) do
            if DoesEntityExist(veh) then
                local health = GetEntityHealth(veh)

                -- If the vehicle is not at max health, repair it
                if health < 1000 then  -- 1000 is the default max health for most cars
                    SetVehicleFixed(veh)
                    SetVehicleDirtLevel(veh, 0.0)
                    SetVehicleEngineHealth(veh, 1000.0)
                    SetVehicleBodyHealth(veh, 1000.0)
                    SetEntityHealth(veh, 1000)
                end
            end
        end
    end
end)


-- Event listener for resetting all dealership vehicles with Discord ID check
RegisterNetEvent("resetDealershipVehicles")
AddEventHandler("resetDealershipVehicles", function()
    local player = source  -- Get player ID
    
    -- Get the player's Discord ID
    local identifiers = GetPlayerIdentifiers(player)
    local discordID = nil
    for _, id in ipairs(identifiers) do
        if string.find(id, "discord:") then
            discordID = id
            break
        end
    end
    
    if not discordID then
        print("Error: No Discord ID found for player " .. player)
        TriggerClientEvent("chat:addMessage", player, {
            args = { "System", " Unable to retrieve your Discord ID. Please try again later." }
        })
        return
    end

    -- Check if the player's Discord ID is in the authorized list
    local authorized = false
    for _, id in ipairs(authorizedUsers) do
        if discordID == id then
            authorized = true
            break
        end
    end

    if not authorized then
        -- If not authorized, send a message to the player
        TriggerClientEvent("chat:addMessage", player, {
            args = { "System", " You are not authorized to reset the dealership vehicles." }
        })
        return
    end

    -- If authorized, reset the vehicles
    dealershipVehicles = {}  -- Clear all vehicles
    TriggerClientEvent("spawnDealershipVehicles", -1)  -- Trigger client to spawn vehicles again

    -- Send a confirmation message to the player
    TriggerClientEvent("chat:addMessage", player, {
        args = { 
            "[Luxury PA] You have reset the Luxury PA Dealership cars." 
        }
    })
end)

-- Command to add an admin to the authorized list
RegisterCommand("adddealershipadmin", function(source, args, rawCommand)
    -- Check if the player is authorized
    local player = source
    local identifiers = GetPlayerIdentifiers(player)
    local discordID = "discord:527163965793370125"
    local authorized = false

    -- Check if the player is authorized to add admins
    for _, id in ipairs(identifiers) do
        if string.find(id, "discord:") then
            if id == discordID then
                authorized = true
                break
            end
        end
    end

    -- If not authorized, send a message to the player
    if not authorized then
        TriggerClientEvent("chat:addMessage", player, {
            args = { "System", " You are not authorized to add dealership admins." }
        })
        return
    end

    -- Check if the correct arguments were provided (Discord user ID)
    if #args < 1 then
        TriggerClientEvent("chat:addMessage", player, {
            args = { "System", " Please provide a valid Discord user ID." }
        })
        return
    end

    local newDiscordID = "discord:" .. args[1]
    -- Add the user to the authorized list
    table.insert(authorizedUsers, newDiscordID)

    -- Debugging output to confirm the list update


    -- Send a confirmation message to the player
    TriggerClientEvent("chat:addMessage", player, {
        args = { "System", " You have successfully added " .. args[1] .. " as an authorized user to reset the dealership." }
    })
end, false)
