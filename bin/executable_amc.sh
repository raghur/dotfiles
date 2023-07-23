#! /bin/bash
action=move
if [[ $# -eq 3 ]]; then
    action=$1
    shift
fi
echo action=$action
echo label=$1
echo source=$2
if [[ x$1 == "xunsorted" ]]; then
    exit 0
fi
filebot -script fn:amc --output "/home/xbmc" --action $action -non-strict  --log-file amc.log \
    --def \
        excludeList=amc.txt \
        artwork=y \
        movieFormat="/home/xbmc/Movies/set4/{n.space('.')}.{y}/{n.space('.')}{v}.{vf}.{hd}.{vc}.{ac}" \
        seriesFormat="/home/xbmc/TvShows/set3/{n.space('.')}/Season.{s.pad(2)}/{n.space('.')}.{s00e00}.{t.space('.')}{v}.{vf}.{hd}.{vc}.{ac}" \
        ut_label=$1 \
        ut_dir="$2" \
        ut_kind=multi \
        subtitles=en \
        pushover=u2ZHW5XdXfKKnfRmWCSADiwt7H9cy5:a7rShXWiSmzvkED8frUuwTQrktcm2a \
        kodi=xbmc:xbmc@htpc:8080
curl --data-binary '{ "jsonrpc": "2.0", "method": "VideoLibrary.Scan", "id": "mybash"}' \
    -H 'content-type: application/json;' \
    http://xbmc:xbmc@htpc:8080/jsonrpc



