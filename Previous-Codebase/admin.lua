RegisterCommand('pmodel', function(source, args, rawCommand)
	local myPed = GetPlayerPed(-1)
	local model = args[1]
	local modelhashed = GetHashKey(model)
	RequestModel(modelhashed)
	while not HasModelLoaded(modelhashed) do 
		RequestModel(modelhashed)
		Citizen.Wait(0)
	end
		SetPlayerModel(PlayerId(), modelhashed)
		SetModelAsNoLongerNeeded(modelhashed)
end, false)

local distanceToCheck = 5.0
function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z-0.6, 10, GetPlayerPed( -1 ), 0 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    return vehicle
end

RegisterCommand('fix', function(source, args, rawCommand)
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true, false)
		SetVehicleFixed(vehicle)
	else
        local playerPos = GetEntityCoords( playerPed )
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( playerPed, 0.0, distanceToCheck, 0.0 )
        local vehicle = GetVehicleInDirection( playerPos, inFrontOfPlayer )
        if DoesEntityExist(vehicle) then
            SetVehicleEngineHealth(vehicle, 1000)
            SetVehicleEngineOn( vehicle, true, true, false )
            SetVehicleFixed(vehicle)
        end
	end
end, false)


--a command that gives you a weapon you specify by weapon_name matches string if you type just the name of the weapon
function GivePlayerWeapon(weaponName)
    local playerPed = GetPlayerPed(-1)
    if not weaponName then
        BeginTextCommandThefeedPost("~r~Error:~w~ You Must Specify a Weapon.")
        return
    end

    local weaponHash = GetHashKey(weaponName)
    if weaponHash == 0 then
        BeginTextCommandThefeedPost("~r~Error:~w~ Invalid Weapon.")
        return
    end

    local isParachute = weaponName == "parachute" or weaponName == "gadget_parachute"
    if isParachute then
        GiveWeaponToPed(playerPed, GetHashKey("gadget_parachute"),1,false,false)
    else
        local fullWeaponName = "weapon_" .. weaponName
        GiveWeaponToPed(playerPed, GetHashKey(fullWeaponName), 250, false, true)
    end
end

-- example usage:
GivePlayerWeapon("pistol")
