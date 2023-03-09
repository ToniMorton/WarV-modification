local Main = {
    Players = {

    },
    BLUFOR = {

    },
    OPFOR = {

    },
    SPECTATOR = {

    },
}

RegisterNetEvent("WarV:PlayerInit")
RegisterNetEvent("WarV:SpawnSetup")
RegisterNetEvent("WarV:SelectPlayerTeam")
--RegisterNetEvent("")

AddEventHandler("WarV:PlayerInit", function(id, coords, heading, model)
    --local playerIdx = GetPlayerFromIndex(id)
    --local ped = GetPlayerPed(playerIdx)
    TriggerClientEvent("WarV:SpawnSetup", id)
    table.insert(Main.Players, id)
    Citizen.Trace("Players count: " .. #Main.Players .. "\n")
    for i=1, #Main.Players do
        Citizen.Trace("ID: " .. Main.Players[i])
    end
end)

AddEventHandler("WarV:SelectPlayerTeam", function(id, SelectedTeam)
    
    if SelectedTeam == "BLUFOR" then
        table.insert(Main.BLUFOR, id)
    elseif SelectedTeam == "OPFOR" then
        table.insert(Main.OPFOR, id)
    elseif SelectedTeam == "SPECTATOR" then
        table.insert(Main.SPECTATOR, id)
    else
        error("WarV: Invalid Team ID In Team Selection Function.")
    end
end)

AddEventHandler('onPlayerKilled', function(KillerID, Data)
    local Killer = KillerID
    local Coords = Data.deathCoords
    local KillerInVeh = Data.KillerInVeh
    local KillersWeapon = Data.weaponHash
    Citizen.Trace("------[ WarV Message Begin] ------\n")
    Citizen.Trace("Player Killed!\n")
    Citizen.Trace("Killer ID?: " .. Killer .. "\n")
    Citizen.Trace("Killers Weapon?: " .. KillersWeapon .. "\n")
    Citizen.Trace("Was Killer In Veh?: " .. KillerInVeh .. "\n")
    Citizen.Trace("Location Vector3: (" .. Coords.x .. "," .. Coords.y .. "," .. Coords.z .. ")\n")
    Citizen.Trace("------[ WarV End Message ] ------\n")
end)

AddEventHandler('playerDropped', function(source, reason)
    local pid = GetPlayerFromServerId(source)
    local ped = GetPlayerPed(pid)
    for i=1, #Main.Players do
        if Main.Players[i] == ped then
            table.remove(i)
        end
    end
    for i=1, #Main.BLUFOR do
        if Main.BLUFOR[i] == pid then
            table.remove(i)
        end
    end
    for i=1, #Main.OPFOR do
        if Main.OPFOR[i] == pid then
            table.remove(i)
        end
    end
    for i=1, #Main.SPECTATOR do
        if Main.SPECTATOR[i] == pid then
            table.remove(i)
        end
    end
  end)

-- function SetPlrTeam(TeamID)
--     DecorSetInt(ped, "TeamID", TeamID)
-- end

--AddEventHandler("", function()  
--end)