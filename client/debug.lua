ENABLED = true

function DrawFrontVisuals(entity)
    if not DoesEntityExist(entity) then return end

    -- Get the entity's position and rotation
    local pos = GetEntityCoords(entity)
    local rot = GetEntityRotation(entity, 2)

    -- Calculate the direction vector using the entity's rotation
    local direction = vector3(0, 0, 1)
    direction = RotateVectorByEulerAngle(direction, rot)

    -- Add an offset to the position to place the line in front of the entity
    local lineStart = pos + (direction * 3)

    -- Draw a semi-transparent line from the entity to the line start position
    DrawLine(pos.x, pos.y, pos.z, lineStart.x, lineStart.y, lineStart.z, 100, 100, 255, 125)

    -- Set the entity as a mission entity and make it slightly transparent
    SetEntityAsMissionEntity(entity, true, true)
    SetEntityAlpha(entity, 200, true)
end

function DrawDebugOverlay()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerHealth = GetEntityHealth(playerPed)
    local playerArmour = GetPedArmour(playerPed)
    local heading = GetEntityHeading(playerPed)

    -- Draw text on screen
    SetTextFont(0)
    SetTextScale(0.0, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(string.format("Health: %d\nArmor: %d\n X: %f\nY: %f\nZ: %f\nH: %d", playerHealth, playerArmour, playerCoords.x, playerCoords.y, playerCoords.z, heading))
    EndTextCommandDisplayText(0.5, 0.1)
end

function RotateVectorByEulerAngle(vector, euler)
    local x = vector.x
    local y = vector.y
    local z = vector.z

    local pitch = math.rad(euler.x)
    local yaw = math.rad(euler.y)
    local roll = math.rad(euler.z)

    local sinPitch = math.sin(pitch)
    local cosPitch = math.cos(pitch)
    local sinYaw = math.sin(yaw)
    local cosYaw = math.cos(yaw)
    local sinRoll = math.sin(roll)
    local cosRoll = math.cos(roll)

    local x2 = (cosYaw * cosRoll) * x + (cosYaw * sinRoll) * y + (-sinYaw) * z
    local y2 = ((sinPitch * sinYaw * cosRoll) - (cosPitch * sinRoll)) * x + ((sinPitch * sinYaw * sinRoll) + (cosPitch * cosRoll)) * y + (sinPitch * cosYaw) * z
    local z2 = ((cosPitch * sinYaw * cosRoll) + (sinPitch * sinRoll)) * x + ((cosPitch * sinYaw * sinRoll) - (sinPitch * cosRoll)) * y + (cosPitch * cosYaw) * z

    return vector3(x2, y2, z2)
end

if ENABLED then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			DrawDebugOverlay()
		end
	end)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local bool,ent = GetEntityPlayerIsFreeAimingAt(GetPlayerPed(-1))
			if DoesEntityExist(ent) then
				DrawFrontVisuals(ent)
			end
		end
	end)
else

end

