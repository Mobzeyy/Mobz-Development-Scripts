fx_version 'adamant'
games { 'gta5' }
author 'mobz'
lua54 'on'
description 'Mobz Squads'

client_scripts {
  'client/*.lua',
}

dependency 'ox_lib'


shared_scripts {
    '@ox_lib/init.lua', 
    'config.lua'
}