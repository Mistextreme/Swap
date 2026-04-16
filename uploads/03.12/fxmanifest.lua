fx_version "adamant"
game "gta5"
lua54 "yes"

name "foltone_barbershop"
description "Foltone Barbershop - Character appearance customization"
author "Foltone"
version "1.0.0"

shared_scripts {
    "config.lua",
    "trad.lua",
    "locales/en.lua",
    "locales/fr.lua",
}

client_scripts {
    "client/client.lua",
    "client/cl_editable.lua",
    "client/cl_miniature.lua"
}

server_scripts {
    "server/server.lua",
    "server/sv_editable.lua",
}

files {
    "client/nui/index.html",
    "client/nui/script.js",
}

ui_page "client/nui/index.html"