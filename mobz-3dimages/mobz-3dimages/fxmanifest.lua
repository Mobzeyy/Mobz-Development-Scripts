fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Mobz'
version '1.0.0'
description '3D IMAGES'


shared_scripts {
	'@ox_lib/init.lua',
    'config/config.lua'
}

client_scripts {
  'client/main.lua'
}

escrow_ignore {
  'config/config.lua',
}