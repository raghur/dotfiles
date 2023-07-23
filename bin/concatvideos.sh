#! /bin/bash

# files="concat:"
# for i in $*; do
#     files="$files$i|"
# done;
# ffmpeg -i $files -c copy outfile.mpg

# read last argument 
outfile=${@: -1}
# set arg list to all arguments except last
set -- "${@:1:$(($#-1))}"
# echo "$@"
# echo $outfile
cvlc "$@" -q --sout-keep \
    --sout='#gather:transcode{vcodec=h264,vb=5000,width=1920,height=1080,acodec=mp4a,ab=192,channels=2}:standard{access=file,mux=mp4,dst='$outfile'}' \
    --sout-all vlc://quit
# adjust timestamp
reffile=${@: -1}
touch -r $reffile $outfile
