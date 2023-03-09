function SetPlayerModel(model)
	local modelhashed = GetHashKey(model)
	RequestModel(modelhashed)
	while not HasModelLoaded(modelhashed) do 
		RequestModel(modelhashed)
		Citizen.Wait(0)
	end
	SetPlayerModel(PlayerId(), modelhashed)
	SetModelAsNoLongerNeeded(modelhashed)
end

function SpawnVehicle(model, x, y, z, h, TeamID)
    local vehiclehash = GetHashKey(model)
	Citizen.Trace(" | " .. model .. " | " .. vehiclehash .. " | ")
	if not IsModelInCdimage(vehiclehash) then --or not IsModelAVehicle(vehiclehash) 
		BeginTextCommandThefeedPost("~r~Invalid Model (CD Image).")
    end
    RequestModel(vehiclehash)
        while not HasModelLoaded(vehiclehash) do
            Citizen.Wait(500)
        end
        	local sv = CreateVehicle(vehiclehash, x, y, z, h, 1, 0)
			if not TeamID == nil then
				DecorSetInt(sv, "TeamID", TeamID)
				
			else
				error("NO TEAM SELECTED FOR THIS PLAYER.")
			end
			SetObjectForceVehiclesToAvoid(sv, true)
		model = nil
		vehiclehash = nil
end

function SpawnBodyguard()

end

function RenderCamera(x,y,z)
    local curCam = GetRenderingCam()
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z + 100, 0.0, 0.0, 0.0, 90.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, 1, 1000, 1, 1);
    SetCamActiveWithInterp(curCam, cam, 1, 1000, 1);
	return cam
end

function DrawHelpText(str)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(str)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function SpawnObject(model, x, y, z)
	local spawnCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.0)
	local obj = CreateObject(model, x, y, z, 1, 1, 1)
	local netid = NetworkGetNetworkIdFromEntity(obj)
	SetNetworkIdExistsOnAllMachines(netid, true)
	SetNetworkIdCanMigrate(netid, false)
	SetEntityHeading(obj, GetEntityHeading(GetPlayerPed(-1)))
	PlaceObjectOnGroundProperly(obj)
	SetEntityInvincible(obj, true)
	SetEntityHasGravity(obj, true)
	Citizen.Wait(500)
	FreezeEntityPosition(obj, true)
end