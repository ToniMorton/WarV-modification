version '1.0.0'
author 'ToniMorton'
description 'WarV Multiplayer Gamemode for FiveM'
repository 'https://github.com/tonimorton/warv'

client_script 'config.lua'
client_script 'exports.lua'
client_script 'client.lua'
client_script 'admin.lua'
client_script 'gameplay.lua'
client_script 'buildables.lua'

server_script 'server.lua'

fx_version 'cerulean'
games { 'gta5' }

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/index.js',
	'html/index.css'
}

exports {
    'RenderCamera',
    'SetPlayerModel',
    'SpawnObject',
    'SpawnVehicle',
    'SpawnBodyguard'
}