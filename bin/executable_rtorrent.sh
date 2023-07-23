#! /bin/bash
if  [ -z "$(pgrep ^rtorrent$)" ];
then 
    echo not running;
    socket=$(grep -Piho "scgi_local.*" ~/.rtorrent.rc|sed -e 's/^.*=//')
    # echo $socket
    rm $socket
    cd ~; rtorrent
else
    echo Already running;
fi
