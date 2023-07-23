#!/bin/bash

# getopt arg parsing magic
# SO - entirely from http://stackoverflow.com/a/29754866/287085

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

SHORT=hdt:u:v
LONG=help,debug,title:,url:,verbose
PARSED=`getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
eval set -- "$PARSED"

while true; do
    case "$1" in
        -h|--help)
            cat <<EOF
usage: push.sh [options] message

-d, --debug     : debug - just print the curl url command
-v, --verbose   : print args
-u, --url       : url - will be clickable in the delivered push
-t, --title     : title of the push
message         : all remaining positional args are concatenated as a single message
EOF
            exit
            ;;
        -d|--debug)
            d=y
            shift
            ;;
        -v|--verbose)
            v=y
            shift
            ;;
        -t|--title)
            title="$2"
            shift 2
            ;;
        -u|--url)
            url="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

if [[ ! -z "$v" ]]; then
echo "verbose: $v, debug: $d,  url: $url, title:$title remaining: $*"
fi

userToken=u2ZHW5XdXfKKnfRmWCSADiwt7H9cy5
appToken=a7rShXWiSmzvkED8frUuwTQrktcm2a
curlopts="--data-urlencode 'message=$(hostname): $*'"
if [ ! -z "$title" ]
then
    curlopts="$curlopts --data-urlencode 'title=$title'"
fi

if [ ! -z "$url" ]
then
    curlopts="$curlopts --data-urlencode 'url=$url'"
fi

cmd="curl -XPOST https://api.pushover.net/1/messages.json \
    -d user=$userToken \
    -d token=$appToken $curlopts"

if [ ! -z "$v" ]
then
    echo $cmd
fi

if [ ! -v d ]
then
    # we do this since just $cmd wouldn't cut it - the quoted args will be stripped
    sh -c "$cmd"
fi
exit 0
