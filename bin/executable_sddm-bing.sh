#! /bin/bash

# copy picture of the day to breeze theme folder as bing.png
# if it's newer this script must be run as root - 
# so stick it in root's crontab

USER=raghu
cp -u /home/$USER/.cache/plasmashell/plasma_engine_potd/bing \
    /usr/share/sddm/themes/breeze/bing.png
