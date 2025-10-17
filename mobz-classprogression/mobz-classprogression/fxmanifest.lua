fx_version 'cerulean'
game 'gta5'

author 'mobz'
description 'Job selection'
version '1.0.0'
lua54 'yes'

client_scripts {
  'client/*.lua',
}

server_scripts {
  'server/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua', 
    'config.lua'
}

dependency {
	'qb-core',
	'ox_lib',
}