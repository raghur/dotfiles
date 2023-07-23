#! /bin/bash

dirname=$1
socket=$2
filelist=$(grep -l 'magnet.*' ${dirname%/}/* |sed -e '/\.loaded/d')
if [ "x" != "x$filelist" ];
then
    grep -Phio 'magnet.*' $filelist | xargs -i ~/bin/xmlrpc2scgi.py $socket load_start_verbose {}
    for i in $filelist; 
    do
        mv $i $i.loaded
    done
fi
