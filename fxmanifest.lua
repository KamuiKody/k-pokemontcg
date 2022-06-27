name "cards"
author "KamuiKody"

ui_page "html/index.html"

fx_version "cerulean"
game "gta5"

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    '@menuv/menuv.lua',
    'client.lua'
}

server_script 'server.lua'

files {
    'html/index.html',
    'html/img/*.png',
    'html/script.js',
    'html/style.css',
}

dependencies {
    'menuv'
}

data_file 'DLC_ITYP_REQUEST' 'stream/booster_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/prop_deckbox_01.ytyp'
