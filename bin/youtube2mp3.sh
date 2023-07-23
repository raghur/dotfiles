#/bin/bash
VLC="/cygdrive/e/utils/VLC/vlc.exe"

title=$(curl -s "$1"|grep -o '<meta property="og:title".*'|grep -o '"[^"]*"'|tac|head -n 1|sed -e 's/"//g').mp3

echo $title
$VLC -I dummy -v $1 --no-sout-video --sout="#transcode{acodec=mp3,aenc=ffmpeg,channels=2,threads=4,ab=128}:std{access=file,dst='$title'}" vlc://quit
