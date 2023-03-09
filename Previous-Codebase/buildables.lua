CFG = {
    Objs = {
        {Name = "Generator Worklight", Hash = GetHashKey("prop_generator_03b")},
        {Name = "Concrete Barrier", Hash = GetHashKey("prop_barier_conc_05a")},
        {Name = "Wooden Road Barrier", Hash = GetHashKey("prop_barrier_work06a")},
        {Name = "Heavy Plastic Barrier", Hash = GetHashKey("prop_plas_barier_01a")},
        {Name = "Hesco Building", Hash = GetHashKey("prop_mb_hesco_06")},
        {Name = "H Barrier Block", Hash = GetHashKey("prop_mb_sandblock_01")},
        {Name = "H Barrier Wall", Hash = GetHashKey("prop_mb_sandblock_03_cr")},
        {Name = "Striped Concrete Barrier", Hash = GetHashKey("prop_mp_conc_barrier_01")},
        {Name = "Thermite Device", Hash = GetHashKey("hei_prop_heist_thermite_flash")},
    },
}
PlayerOffset = vector3(0.0, 0.0, 0.0)
ObjPool = {}
Player = GetPlayerPed(-1)
PlacingObject = false
CurObjHandle = nil
Offset = 0.0

function DrawText3DBG(x, y, z, text)
	local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local factor = (string.len(text)) / 370
    
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0,0,0,0,55)
		SetTextOutline()
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandDisplayText(_x,_y)
        DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.02, 0, 0, 0, 150)
	end
end

function DrawText3D(x, y, z, text)
	local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local factor = (string.len(text)) / 370
    
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextColour(255, 255, 255, 255)
		SetTextOutline()
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandDisplayText(_x,_y)
	end
end

function ObjSpawn(hash, x, y, z, heading)
    RequestModel(hash)
        while not HasModelLoaded do
        RequestModel(hash)
        Citizen.Wait(0)
    end
    local Obj = CreateObject(hash, x,y,z, true, true, true)
    PlaceObjectOnGroundProperly(Obj)
    SetEntityHeading(Obj, GetEntityHeading(Player))
    SetEntityCollision(Obj, true, true)
    --SetEntityAlpha(Obj, 255, true)
    SetEntityAsMissionEntity(Obj, true, true)
    --SetModelAsNoLongerNeeded(hash)
    table.insert(ObjPool, Obj)
    PlacingObject = true
    return Obj
end

RegisterCommand("objspwn", function(src, args, full)
            Citizen.Trace(CFG.Objs[1].Hash)
            CurObjHandle = ObjSpawn(CFG.Objs[7].Hash, PlayerOffset.x, PlayerOffset.y, PlayerOffset.z, GetEntityHeading(Player))
end, false)

Citizen.CreateThread(function()
    while true do
        while PlacingObject do
            HudWeaponWheelIgnoreSelection()
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
            Citizen.Wait(0)
        end
    Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do       
        while not PlacingObject do
            for i=1, #ObjPool do
                if DoesEntityExist(ObjPool[i]) then
                    local PlayerCoords = GetEntityCoords(Player)
                    local ObjCoords = GetEntityCoords(ObjPool[i])
                    local ObjHeading = GetEntityHeading(ObjPool[i])
                    if Vdist(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, ObjCoords.x, ObjCoords.y, ObjCoords.z) <= 3.0 then
                        DrawText3DBG(ObjCoords.x, ObjCoords.y, ObjCoords.z + 1.0, "~y~Press [~g~E~y~] to remove object")
                        if IsControlJustPressed(0, 51) then
                            NetworkRequestControlOfEntity(ObjPool[i])
                            SetModelAsNoLongerNeeded(GetEntityModel(ObjPool[i]))
                            SetEntityAsNoLongerNeeded(ObjPool[i])
                            SetEntityAsMissionEntity(ObjPool[i], true, true)
                            DeleteObject(ObjPool[i])
                        end
                    end
                else
                    table.remove(ObjPool, i)
                end
            end
            Citizen.Wait(0)
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local PlayerCoords = GetEntityCoords(Player)
        local PlayerHeading = GetEntityHeading(Player)

        while PlacingObject do
            while DoesEntityExist(CurObjHandle) do
                local ObjCoords = GetEntityCoords(CurObjHandle)
                local ObjHeading = GetEntityHeading(CurObjHandle)
                PlayerOffset = GetOffsetFromEntityInWorldCoords(Player, 0.0, 4.0, 0.0)

                if IsDisabledControlJustPressed(0, 22) then
                    PlacingObject = false
                    FreezeEntityPosition(CurObjHandle, true)
                    CurObjHandle = nil
                end
                if IsDisabledControlPressed(0, 108) then
                    SetEntityHeading(CurObjHandle, ObjHeading + 1.0)
                end
                if IsDisabledControlPressed(0, 109) then
                    SetEntityHeading(CurObjHandle, ObjHeading - 1.0)
                end
                if IsControlJustPressed(0, 111) then
                    Offset = Offset + 1.0
                end
                if IsControlJustPressed(0, 112) then
                    Offset = Offset + -1.0
                end

                DrawText3DBG(ObjCoords.x, ObjCoords.y, ObjCoords.z + 0.8 , "~y~[Object Placement Controls]~w~")
                DrawLine(ObjCoords.x, ObjCoords.y, ObjCoords.z, PlayerOffset.x, PlayerOffset.y, PlayerOffset.z + 0.8 + Offset, 255, 255, 255, 255)    
                DrawText3DBG(ObjCoords.x, ObjCoords.y, ObjCoords.z + 0.6, " NUM4 and NUM6 - Rotate Object ")
                DrawLine(ObjCoords.x, ObjCoords.y, ObjCoords.z, PlayerOffset.x, PlayerOffset.y, PlayerOffset.z + 0.6 + Offset, 255, 255, 255, 255)
                DrawText3DBG(ObjCoords.x, ObjCoords.y, ObjCoords.z + 0.4, " NUM8 and NUM5 - Move up and down ")
                DrawLine(ObjCoords.x, ObjCoords.y, ObjCoords.z, PlayerOffset.x, PlayerOffset.y, PlayerOffset.z + 0.4 + Offset, 255, 255, 255, 255)
                DrawText3DBG(ObjCoords.x, ObjCoords.y, ObjCoords.z + 0.2, " SPACE - place object ")
                DrawLine(ObjCoords.x, ObjCoords.y, ObjCoords.z, PlayerOffset.x, PlayerOffset.y, PlayerOffset.z + 0.2 + Offset, 255, 255, 255, 255)
                SetEntityCoordsNoOffset(CurObjHandle, PlayerOffset.x, PlayerOffset.y, PlayerOffset.z + Offset, false, false, false)

                Citizen.Wait(0)
            end
            Citizen.Wait(0)
        end
        Citizen.Wait(0)
    end
end)