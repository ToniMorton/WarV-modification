local ActivePlayers = {} -- array to store connected players
local BLUFOR = {}
local OPFOR = {}
local INSURGENCY = {}

DecorRegister("WARV_TEAMID", 2)


AddEventHandler('playerConnecting', function()
    local player = source -- get the player ID
    table.insert(ActivePlayers, player) -- add the player to the array
end)

function GetSmallestTeam()
    local bluforCount = 0
    local opforCount = 0
    local insurgencyCount = 0
    
    -- Loop through the player array and count the number of players in each team
    for _, player in ipairs(ActivePlayers) do
        local team = DecorGetInt(player, "WARV_TEAMID")
        if team == "BLUFOR" then
            bluforCount = bluforCount + 1
        elseif team == "OPFOR" then
            opforCount = opforCount + 1
        elseif team == "INSURGENCY" then
            insurgencyCount = insurgencyCount + 1
        end
    end
    
    -- Find the team with the least number of players
    local smallestCount = math.min(bluforCount, opforCount, insurgencyCount)
    if smallestCount == bluforCount then
        return "BLUFOR"
    elseif smallestCount == opforCount then
        return "OPFOR"
    else
        return "INSURGENCY"
    end
end

function OpenTeamSelection(tgt)
    TriggerClientEvent("WARV_TEAMSELECT", tgt, function(data)
        
    end)
end

function AssignPlayerTeam(player)
    local team = DecorGetInt(player, "WARV_TEAMID") -- Get the player's team ID decor
    if not team then -- If the player doesn't have a team ID decor set
        OpenTeamSelection(player)
        team = GetSmallestTeam() -- Get the team with the least number of players
        DecorSetInt(player, "WARV_TEAMID", team) -- Set the player's team ID decor
        TriggerClientEvent('WarV:PickClass', player) -- Trigger the class picker event for the player
    end
end

function CheckPlayerTeams()
    for _, player in ipairs(ActivePlayers) do
        AssignPlayerTeam(player)
    end
end

function CleanupDisconnectedPlayers()
    for i = #ActivePlayers, 1, -1 do
        local player = ActivePlayers[i]
        if not NetworkIsPlayerActive(player) then
            table.remove(ActivePlayers, i)
        end
    end
end

local tickInterval = 10 -- interval in milliseconds
local tickTimer = Citizen.SetTimeout(tickInterval, function()
    CleanupDisconnectedPlayers()
    CheckPlayerTeams()
end)