local display = false
local Spectating = false
DecorRegister('BLUFOR', 2)
DecorRegister('OPFOR', 2)
DecorRegister('SPECTATOR', 2)
DecorRegister("TeamID", 3)
SetVehicleModelIsSuppressed(GetHashKey("police"), true)
SetVehicleModelIsSuppressed(GetHashKey("policeb"), true)
SetVehicleModelIsSuppressed(GetHashKey("police2"), true)
SetVehicleModelIsSuppressed(GetHashKey("police3"), true)
SetVehicleModelIsSuppressed(GetHashKey("police4"), true)
SetVehicleModelIsSuppressed(GetHashKey("sheriff"), true)
SetVehicleModelIsSuppressed(GetHashKey("sheriff2"), true)
SetVehicleModelIsSuppressed(GetHashKey("fbi"), true)
SetVehicleModelIsSuppressed(GetHashKey("fbi2"), true)
SetVehicleModelIsSuppressed(GetHashKey("pgranger"), true)
SetVehicleModelIsSuppressed(GetHashKey("policeold1"), true)
SetVehicleModelIsSuppressed(GetHashKey("policeold2"), true)
SetVehicleModelIsSuppressed(GetHashKey("maverick"), true)
SetVehicleModelIsSuppressed(GetHashKey("frogger"), true)
SetVehicleModelIsSuppressed(GetHashKey("blimp"), true)
SetVehicleModelIsSuppressed(GetHashKey("crusader"), true)
SetVehicleModelIsSuppressed(GetHashKey("polmav"), true)
SetVehicleModelIsSuppressed(GetHashKey("riot"), true)
SetVehicleModelIsSuppressed(GetHashKey("riot2"), true)
SetVehicleModelIsSuppressed(GetHashKey("policeb"), true)
SetWeaponsNoAutoreload(true)
SetWeaponsNoAutoswap(true)

RegisterNetEvent("WarV:SpawnSetup")
RegisterNetEvent("WarV:PlayerInit")

RegisterCommand("failsafe", function()
	local ServerID = GetPlayerServerId(PlayerId())
	local coords = GetEntityCoords(GetPlayerPed(-1))
	local heading = GetEntityHeading(GetPlayerPed(-1))
	local model = GetEntityModel(GetPlayerPed(-1))
	TriggerServerEvent("WarV:PlayerInit", ServerID, coords, heading, model)
end,false)

AddEventHandler("PlayerSpawned", function(spawn)
	local ServerID = spawn.idx
	local coords = vector3(spawn.x, spawn.y, spawn.z)
	local heading = spawn.heading
	local model = spawn.model
	TriggerServerEvent("WarV:PlayerInit", ServerID, coords, heading, model)
end)
	
function SetDisplay(bool)
	display = not display
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "teammenu",
        show = bool
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

RegisterNUICallback('blufor', function(data, cb)
	GiveLoadout("BLUFOR", "rifleman")
    SetCamActive(Cam, false)
    DestroyCam(Cam, true)
    RenderScriptCams(false, 1, 1000, 1, 1);
    Cam = nil
	DecorSetInt(GetPlayerPed(-1), "TeamID", 1)
	SetEntityCoordsNoOffset(GetPlayerPed(-1),-2207.1274, 3306.7363, 32.9705, true, false, false)
	SetEntityHeading(GetPlayerPed(-1), 108.169)
end)

RegisterNUICallback('opfor', function(data, cb)
	GiveLoadout("OPFOR")
    SetCamActive(Cam, false)
    DestroyCam(Cam, true)
    RenderScriptCams(false, 1, 1000, 1, 1);
    Cam = nil
	DecorSetInt(GetPlayerPed(-1), "TeamID", 2)
	SetEntityCoordsNoOffset(GetPlayerPed(-1), 3074.398193359375,-4695.779296875,15.26231575012207, true, false, false)
	SetEntityHeading(GetPlayerPed(-1), 108.169)
end)

RegisterNUICallback('spectator', function(data, cb)
	GiveLoadout("SPECTATOR")
    SetCamActive(Cam, false)
    DestroyCam(Cam, true)
    RenderScriptCams(false, 1, 1000, 1, 1);
	DecorSetInt(GetPlayerPed(-1), "TeamID", 3)

	Spectating = not Spectating
end)

function StartTeamSelection()
	SetDisplay(true)
end

function CloseUI()
	SetDisplay(false)
end

RegisterCommand("toggleui", function(src,args,full)
	SetDisplay(not display)
end,false)


function GiveLoadout(TeamID, LoadoutID)
	local playerPed = GetPlayerPed(-1)
	if TeamID == "BLUFOR" then
		DecorSetBool(playerPed, "BLUFOR", true)
        if LoadoutID == "rifleman" then
            GiveWeaponToPed(playerPed, GetHashKey("weapon_carbinerifle_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 80, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 4, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "medic" then
		    GiveWeaponToPed(playerPed, GetHashKey("weapon_assaultrifle"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 80, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 4, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "machinegunner" then
			GiveWeaponToPed(playerPed, GetHashKey("weapon_combatmg_mk2"), 500, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 80, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 4, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "demolitions" then
		    GiveWeaponToPed(playerPed, GetHashKey("weapon_assaultrifle"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 1, false, true)
			GiveWeaponToPed(playerPed, GetHashKey("weapon_proxmine"), 4, false, true)
			GiveWeaponToPed(playerPed, GetHashKey("weapon_stickybomb"), 4, false, true)
			GiveWeaponToPed(playerPed, GetHashKey("weapon_rpg"), 2, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "pilot" then
		    GiveWeaponToPed(playerPed, GetHashKey("weapon_smg_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 2, false, true)
            SetEntityHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "tankcrew" then
			GiveWeaponToPed(playerPed, GetHashKey("weapon_smg_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 2, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
		else
			error("Unknown Loadout ID")
        end
		SetEntityCoords(playerPed, -1865.9771, 3229.9316, 32.8456,true,true,true,false)
		SetEntityHeading(playerPed, 146.4781)

	elseif TeamID == "OPFOR" then

		if LoadoutID == "Rifleman" then
            GiveWeaponToPed(playerPed, GetHashKey("weapon_carbinerifle_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 80, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 4, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "Medic" then
		    GiveWeaponToPed(playerPed, GetHashKey("weapon_assaultrifle"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 80, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 4, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "Machinegunner" then
			GiveWeaponToPed(playerPed, GetHashKey("weapon_combatmg_mk2"), 500, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 80, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 4, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "Demolitions" then
		    GiveWeaponToPed(playerPed, GetHashKey("weapon_assaultrifle"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 1, false, true)
			GiveWeaponToPed(playerPed, GetHashKey("weapon_proxmine"), 4, false, true)
			GiveWeaponToPed(playerPed, GetHashKey("weapon_stickybomb"), 4, false, true)
			GiveWeaponToPed(playerPed, GetHashKey("weapon_rpg"), 2, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "Pilot" then
		    GiveWeaponToPed(playerPed, GetHashKey("weapon_smg_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 2, false, true)
            SetEntityHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
        elseif LoadoutID == "Tank Crew" then
			GiveWeaponToPed(playerPed, GetHashKey("weapon_smg_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_pistol_mk2"), 150, false, true)
            GiveWeaponToPed(playerPed, GetHashKey("weapon_grenade"), 2, false, true)
            SetEntityHealth(playerPed, 200)
			SetEntityMaxHealth(playerPed, 200)
            SetPedArmour(playerPed, 200)
		else
			error("Unknown Loadout ID")
        end
		SetEntityCoords(playerPed, -1865.9771, 3229.9316, 32.8456,true,true,true,false)
		SetEntityHeading(playerPed, 146.4781)
	else
		error("Unknown Team ID")
	end
end

AddEventHandler("WarV:SpawnSetup", function()
	local ped = PlayerPedId()
	SetCanAttackFriendly(ped, true, true)
	NetworkSetFriendlyFireOption(true)
	SetAutoGiveScubaGearWhenExitVehicle(GetPlayerPed(-1),true)
	SetAutoGiveParachuteWhenEnterPlane(GetPlayerPed(-1),true)
	SetWeaponsNoAutoreload(true)
	SetWeaponsNoAutoswap(true)
	SetMaxWantedLevel(0)
	SetFlashLightFadeDistance(200)
	SetFlashLightKeepOnWhileMoving(true)
	SetAudioFlag("DisableFlightMusic", true)
	DecorSetBool(GetPlayerPed(-1), 'BLUFOR', false)
	DecorSetBool(GetPlayerPed(-1), 'OPFOR', false)
	DecorSetBool(GetPlayerPed(-1), 'SPECTATOR', false)
	exports.WarV:RenderCamera(150.0, 150.0, 1600.0)
	Citizen.Trace("POINT - 1")
	StartTeamSelection()
end)

Citizen.CreateThread(function()
	while true do
		DisablePlayerVehicleRewards(PlayerId())
		-- RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_SNIPERRIFLE'))
		-- RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_CARBINERIFLE'))
		-- RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PISTOL'))
		-- RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_PUMPSHOTGUN'))
		-- RemoveAllPickupsOfType(GetHashKey('PICKUP_WEAPON_ADVANCEDRIFLE'))
		Citizen.Wait(0)
	end
end)


Citizen.CreateThread(function()
	while true do
		SetAmbientPedRangeMultiplierThisFrame(0.0)
		SetVehicleDensityMultiplierThisFrame(0.0)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
		local playerCount = #GetActivePlayers()
		Citizen.Wait(20*1000) -- checks every 5 seconds (to limit resource usage)
		SetDiscordAppId(1033372389830041712) -- client id (int)
		SetRichPresence(string.format("%s Players", playerCount)) -- main text (string)
		SetDiscordRichPresenceAsset("millogolg") -- large logo key (string)
		SetDiscordRichPresenceAssetText("tonisdevstudio.ml") -- Large logo "hover" text (string)
		SetDiscordRichPresenceAssetSmall("millogo") -- small logo key (string)
		SetDiscordRichPresenceAssetSmallText("tonisdevstudio.ml") -- small logo "hover" text (string)
	end
end)

RegisterCommand('suicide', function(source, args, rawCommand)
	local playerPed = GetPlayerPed(-1)
	if args[1] == 'confirm' then
		SetEntityHealth(GetPlayerPed(-1), 0)
		exports.WarV:ShowNotification("You have Commited ~r~Suicide~w~.")
	else
		exports.WarV:ShowNotification("~r~WARNING:~w~ This command will kill you. do '/suicide confirm' to continue..")
	end
end, false)

Citizen.CreateThread(function()
	while true do
		if IsPedSwimming(GetPlayerPed(-1)) then
			if IsPedSwimmingUnderWater(GetPlayerPed(-1)) then
				SetEnableScuba(GetPlayerPed(-1), true)
			end
		else
			SetEnableScuba(GetPlayerPed(-1), false)
		end
		Citizen.Wait(0)
	end
end)