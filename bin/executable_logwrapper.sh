#!/bin/sh

# shift
echo $*
logfile=/tmp/`basename $1`.log
echo "$(date --rfc-3339=seconds) starting $1" >> $logfile
$* >> $logfile 2>&1
echo "$(date --rfc-3339=seconds) completed $1" >> $logfile  
