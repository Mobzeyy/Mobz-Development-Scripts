fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Mobz'
description 'Mobz Dependencies Script'
version '1.0.0'

shared_scripts {
	'@ox_lib/init.lua',  -- ox_lib init
    'config.lua'
}

server_scripts {
    'server/framework.lua',
    'server/modules/*.lua'
}

client_scripts {
    'client/framework.lua',
    'client/modules/*.lua'
}

-- Single HTML page (acts as UI loader)
ui_page 'data/main.html'

-- Include all UI files dynamically
files {
    'data/**'
}


-----------------------------------------
-- EXPORTS FOR OTHER SCRIPTS
-----------------------------------------
exports {
	--SERVER SIDE
	
	--framework
	'GetPlayer', 
	'GetPlayers',
	
	-- Missions
    'GetLeaderboard', 
	'ResetTimedMissions',
	'ResetMission',
	'onComplete',
	'onProgress',
	'RegisterMission',
	'AssignMission',
	'AddProgress', 
	'GetProgress',
	'RemoveMission', 
	'RegisterHook', 
	'TrackStatForMissions',
	
	-- Zones
	"CreateCircle", 
	"CreateBox", 
	"CreatePoly", 
	"Save",
	"Load",
	
	-- Props
	'AddProp',
	'RemoveProp', 
	'GetProps',
	
	-- Npcs
	'AddNPC', 
	'RemoveNPC', 
	'GetNPCs',
	
	-- Notificatioons
	'NotifyPlayer',
	'NotifyAll',
	
	-- Markers
	'AddMarker',
	'RemoveMarker', 
	'GetMarkers', 
	
	-- Discord
	'Send', 
	'SendJSON',
	
	-- Debug
	'ListModules',
	'ListFunctions', 
	'TestFunction',

	-- Callbacks
	"CreateCallback",
	"TriggerClientCallback", 
	"TriggerClientCallbackAwait",

	-- Blips
	'AddBlip',
	'RemoveBlip', 
	'GetBlips',
	
	-- Prestiged
	-- STATS
	'RegisterStat', 
	'RemoveDynamicStat', 
	'AddStat',
	'SetStat',
	'GetStat',

	-- PLAYER MANAGEMENT
	'EnsurePlayer',
	'GetAllPlayers',

	-- HOOK REGISTRATION
	'RegisterStatHook',
	'RegisterAchievementHook', 

	-- CLIENT SIDE
	
	-- Framework
	'GetPlayer_cl', 
	'HasItem', 
	'Notify', 

	-- Buttom mash
	'Start',
	
	-- Callbacks
	"TriggerServerCallback", 
	"TriggerServerCallbackAwait",
	"RegisterClientCallback",
	
	-- Client Update
	"GetStats", 
	"OnStatsUpdate",
	"ForceUpdateStats", 

	-- Debug
	'ListModulesclient', 
	'ListFunctionsclient', 
	'TestFunctionclient', 
	
	-- Gender
	'GetGender',
	
	-- Inventory
	'HasItem',
	
	-- Npcs
	'GetNPCs', 
	'SpawnAll', 
	'DeleteNPC',
	
	-- Bar
	'ProgressBar',
	
	-- Props
	'GetProps',
	'SpawnAll', 
	'DeleteProp', 
	
	-- Zones
	'IsPlayerInZone', 
	'SetDebug',
	'SetDebugColors',
	
}