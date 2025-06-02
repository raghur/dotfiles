#! /bin/sh
flameshot gui --raw \
    | convert -resize 400% png:- png:- \
    | tesseract stdin stdout -l eng --psm 6 \
    | tee \
    | xclip -in -selection clipboard; notify-send -e -a "Flameshot" "OCR Text copied"
