#!/bin/bash

SCRIPT=/home/raghu/bin/cf-ddns.sh
# Arguments passed by NetworkManager: $1 = interface, $2 = event
INTERFACE="$1"
EVENT="$2"

if [ "$INTERFACE" == "eth0" ] && [ "$EVENT" == "up" ]; then
    $SCRIPT 
fi 
