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
	
	-- Zones
	"CreateCircle", 
	"CreateBox", 
	"CreatePoly", 
	"Save",
	"Load",
	
	-- Notificatioons
	'NotifyPlayer',
	'NotifyAll',
	
	-- Callbacks
	"CreateCallback",
	"TriggerClientCallback", 
	"TriggerClientCallbackAwait",
	
	-- Mobz-prestiged
	'PrestigeMultiplierAPI',
	
	-- Rewards
	'GiveMoney', 
	'GiveItem', 
	'GiveReward',
	'HasItem'
	'RemoveItem'

	-- CLIENT SIDE
	
	-- Framework
	'GetPlayer_cl', 
	'Notify', 

	-- Buttom mash
	'Start',
	
	-- Callbacks
	"TriggerServerCallback", 
	"TriggerServerCallbackAwait",
	"RegisterClientCallback",
	
	-- Gender
	'GetGender',
	
	-- Inventory
	'HasItem',
	
	-- Prestiged
	"PrestigeMultiplier",
	
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