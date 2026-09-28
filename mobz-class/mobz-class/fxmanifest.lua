fx_version 'cerulean'
game 'gta5'
lua54 'on'

author 'mobz'
description 'Advanced Player Prestiged System'
version '1.0.0'

shared_scripts {
	'@ox_lib/init.lua',
    'config.lua'
}


server_scripts {
	'server/main.lua',	
}

client_scripts {
	'client/main.lua',
}

files {
    'stream/class_banner.ytd'
}


  
-----------------------------------
-- Export Core Functions
-----------------------------------

exports {

}


escrow_ignore {
  'config.lua',
}