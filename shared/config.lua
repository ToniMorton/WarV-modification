WarV = {
	OPTIONS = {
		DEBUGMODE  = true,
		ROUNDTIME = 60000 * 30, -- This is 1 minute. X 30 so 30 minutes In Milisec
		LOBBYMODE = "ShipLobby", -- options are LobbyMenu, ShipLobby, ZancudoLobby
		
	},
	GAMESTATES = {
		"IDLE", -- wait for a player on each team
		"LOBBY", -- each team has at least 1 player we can ask them to pick classes now, once picked assign the respective class to the ped
		"ROUNDSTARTING", -- round starts in 10
		"GAMESTARTED", -- rounds started we got 30 minutes here
		"ROUNDEND", -- round ended display the winner/loosers
		"RESTARTROUND" -- cleanup spawned vehicles, cleararea, and Kill all the players. respawn them, hide the playermodels and go back to the lobby mode
	},
	LOCATIONS = {
		LOBBYSPAWN = vector4(3064.555, -4706.073, 15.26151, 248.8089),
		HYDRAOPFOR = vector4(3101.8398, -4734.60351, 15.802714, 95.823570),
	},
	TEAMS = {
		BLUFOR = {
			TICKETS = 150,
			TEAMID = 1,
			CLASSES = {
				RIFLEMAN = {
					CLASSNAME = "Rifleman",
					MODEL = GetHashKey("mp_m_freemode_01"),
					HEALTH = 200,
					ARMOR = 150,
					PEDCOMPONENTS = "0,0,1;46,0,1;0,0,1;16,0,1;125,5,1;0,0,1;97,0,1;133,0,1;15,0,1;15,1,1;0,0,1;53,3,1;hat,150,1", -- these are encoded using encodePlayerClothing otherwise they are MASSIVE.
					SPAWNPOS = vector4(0,0,0,0),
					LOADOUT = {
						PRIMARY = {
							{GetHashKey("WEAPON_CARBINERIFLE_MK2"), 250}
						},
						SECONDARY = {
							{GetHashKey("WEAPON_COMBATPISTOL"), 80}
						},
						EXPLOSIVES = {
							{GetHashKey("WEAPON_GRENADE"), 2},
							{GetHashKey("WEAPON_FLARE"), 2}
						},
						MELEE = {
							{GetHashKey("weapon_knife")}
						},
					}
				}
			}
		},
		OPFOR = {
			TICKETS = 150,
			TEAMID = 2,
			CLASSES = {
				RIFLEMAN = {
					CLASSNAME = "Rifleman",
					MODEL = GetHashKey("mp_m_freemode_01"),
					HEALTH = 200,
					ARMOR = 150,
					PEDCOMPONENTS = "",
					SPAWNPOS = vector4(3085.716, -4703.726, 15.2451, 98.47266),
					LOADOUT = {
							PRIMARY = {
									{GetHashKey("weapon_assaultrifle_mk2"), 250}
							},
							SECONDARY = {
									{GetHashKey("weapon_snspistol_mk2"), 80}
								},
							EXPLOSIVES = {
								{GetHashKey("WEAPON_GRENADE"), 2},
								{GetHashKey("WEAPON_FLARE"), 2}
							},	
							MELEE = {
								{GetHashKey("weapon_knife")}
							},
					},
				},
			}
		},
		INSURGENCY = {
			TICKETS = -1,
			TEAMID = 0,
			CLASSES = {
				INSURGENT = {
					CLASSNAME = "INSURGENT",
					MODEL = GetHashKey("mp_m_freemode_01"),
					HEALTH = 250,
					ARMOR = 250,
					PEDCOMPONENTS = {
					},
					SPAWNPOS = vector4(0,0,0,0),
					LOADOUT = {
						PRIMARY = {
							{}
						},
						SECONDARY = {
							{}
						},
						EXPLOSIVES = {
							{}
						},
						MELEE = {
							{}
						},
					},
				}
			}
		}
	
	}
}


--FiveM Lua environment 