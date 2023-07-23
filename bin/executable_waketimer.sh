#! /bin/bash
sh -c "echo 0 >  /sys/class/rtc/rtc0/wakealarm"
sh -c "echo `date '+%s' -d "$*"` > /sys/class/rtc/rtc0/wakealarm"


