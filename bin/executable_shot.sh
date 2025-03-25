#! /bin/sh
flameshot gui --raw -p /tmp/last-screenshot.png \
    | convert -resize 400% png:- png:- \
    | tesseract stdin stdout -l eng --psm 6 \
    | xclip -in -selection clipboard

