fx_version 'cerulean'
game 'gta5'

description 'Sistema de llamadas 911 y SAME con NUI, blip en el suelo y aceptación mediante teclas (K y L)'

client_scripts {
    'client.lua'
}

server_scripts {
    '@es_extended/imports.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
