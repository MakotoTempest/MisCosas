shared_scripts { '@FiniAC/fini_events.js', '@FiniAC/fini_events.lua' }

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Kakarot'
description 'Player inventory system providing a variety of features for storing and managing items'
version '2.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/es.lua',
    'config/*.lua',
}

client_scripts {
    'client/main.lua',
    'client/drops.lua',
    'client/vehicles.lua',
    'client/hud.lua',
    'client/actionbar.lua',
    'client/clothing.lua',
    'client/vehicle.lua',
    'client/carry.lua',
    'client/rockstar.lua',
    'client/dev.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/decay.lua',
    'server/functions.lua',
    'server/stash.lua',
    'server/commands.lua',
    'server/old_functions.lua',
    'server/carry.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/app.js',
    'html/images/*.png',
    'html/fonts/*.*',
    'html/assets/*.png',
    'html/sounds/*.*'
}

escrow_ignore {
    'client/actionbar.lua',
    'client/drops.lua',
    'client/main.lua',
    'server/*.lua',
}

dependency 'qb-weapons'
