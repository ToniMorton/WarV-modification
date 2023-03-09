WarV.Nui_IDS = {
    TEAMSELECT = {
        name = "Team Selection",
        url = "html/team_select/index.html",
        visible = false
    },
    CLASSSELECT = {
        name = "Class Selection",
        url = "html/class_select.html",
        visible = false
    },
    LOBBY = {
        name = "Lobby",
        url = "html/lobby.html",
        visible = false
    },
    PAUSE = {
        name = "Pause Menu",
        url = "html/pause_menu.html",
        visible = false
    },
    OBJECTSPAWNER = {
        name = "Object Spawner",
        url = "html/object_spawner.html",
        visible = false
    },
    VEHICLESPAWNER = {
        name = "Vehicle Spawner",
        url = "html/vehicle_spawner.html",
        visible = false
    },
    ERROR = {
        name = "Error Message",
        url = "html/error.html",
        visible = false
    },
    ENDROUND = {
        name = "End of Round",
        url = "html/end_of_round.html",
        visible = false
    },
    WINLOOSE = {
        name = "Win/Lose Screen",
        url = "html/win_lose.html",
        visible = false
    }
}



----------------------------------------------------------
--
--TEAM SELECTION LOGIC
--
--
----------------------------------------------------------
-- Open Team Selection NUI
function OpenTeamSelect()
    SendNUIMessage({
      type = "open_team_select",
      players = GetPlayers()
    })
    SetNuiFocus(true, true)
    WarV.Nuis["TEAMSELECT"].visible = true
  end
  
  -- Close Team Selection NUI
  function CloseTeamSelect()
    SendNUIMessage({
      type = "close_team_select"
    })
    SetNuiFocus(false, false)
    WarV.Nuis["TEAMSELECT"].visible = false
  end
  
  -- Toggle Team Selection NUI
  function ToggleTeamSelect()
    if WarV.Nuis["TEAMSELECT"].visible then
      CloseTeamSelect()
    else
      OpenTeamSelect()
    end
  end
  
  -- Callback for Team Selection NUI
  RegisterNUICallback("select_team", function(data, cb)
    -- Handle selected team
    cb("ok")
  end)
  