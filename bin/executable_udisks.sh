# !/bin/bash
label=$1
dev=$(blkid -L $label)
echo $dev $label
mount| grep $dev || udisks --mount $dev
