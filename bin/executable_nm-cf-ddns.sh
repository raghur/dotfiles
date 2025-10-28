#!/bin/bash

SCRIPT="/home/raghu/bin/cf-ddns.sh"
# Arguments passed by NetworkManager: $1 = interface, $2 = event
INTERFACE="$1"
EVENT="$2"

if [ "$INTERFACE" == "enp2s0" ] && [ "$EVENT" == "up" ]; then
	$SCRIPT  -a $(hostname)
fi 
