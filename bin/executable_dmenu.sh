#! /bin/bash
CACHE_FILE=/tmp/dmenu.cache
if [ ! -f  $CACHE_FILE ];
then
    find `echo ${PATH//:/ }` -maxdepth 1  \( -type f -o -type l \) -executable -printf "%f\n" > $CACHE_FILE
fi;
exe=$(cat $CACHE_FILE|dmenu -fn "-*-*-*-*-*-*-40-*-*-*-*-*-*-*" -i)
exec $exe
 
