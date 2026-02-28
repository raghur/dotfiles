#! /bin/sh
if [ "$1" = '-ocr' ]; then
    QT_QPA_PLATFORM=xcb flameshot gui --raw \
    | convert -resize 400% png:- png:- \
    | tesseract stdin stdout -l eng --psm 6 \
    | tee \
    | xclip -in -selection clipboard; notify-send -e -a "Flameshot" "OCR Text copied"
else
    QT_QPA_PLATFORM=xcb flameshot gui
fi


