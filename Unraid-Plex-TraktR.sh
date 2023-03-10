#!/bin/bash

# Trakt.tv Scrobbler Original Installer by Liara#9557 and Xan#7777.

plugindir=/mnt/cache/appdata/PlexMediaServer/Library/Application\ Support/Plex\ Media\ Server/Plug-ins/

if [ ! -d "/mnt/cache/appdata/PlexMediaServer" ];
then
    echo "Plex is not installed. Exiting..."
    exit
else
    echo "Installing Trakt.tv Scrobbler..."
    cd "/mnt/user0/Temp" || exit
    git clone --depth 1 https://github.com/rg9400/Plex-Trakt-Scrobbler.git
    cd Plex-Trakt-Scrobbler || exit
    cp -a Trakttv.bundle "$plugindir"
    cd /mnt/user0/Temp || exit
    rm -rf Plex-Trakt-Scrobbler
    echo "Restart Plex docker manually!"
    sleep 15
    echo "Trakt.tv Scrobbler installed!"
    exit
fi
