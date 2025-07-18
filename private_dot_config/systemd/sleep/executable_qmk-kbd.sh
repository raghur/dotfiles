#!/bin/bash
PAT="QMK RP2040"
case "$1" in
    pre)
        grep . /sys/class/input/*/name| \
            grep -i "$PAT"| head -n1 | \
            awk -F":" '{print $1}' | \
            xargs dirname | xargs -i cat '{}/phys' | \
            grep -Po '[[:xdigit:]]{4}:[[:xdigit:]]{2}:[[:xdigit:]]{2}\.[[:xdigit:]]' \
            > /tmp/qmk-kbds

        # grep . /sys/bus/usb/devices/*/idVendor |grep $rp2040kbdVendorId | grep -Po "\d-\d" > /tmp/qmk-kbds
        for i in $(< /tmp/qmk-kbds); do
            echo "$i" > /sys/bus/pci/drivers/xhci_hcd/unbind
        done
        #
        ;;
    post)
        for i in $(< /tmp/qmk-kbds); do
            echo "$i" > /sys/bus/pci/drivers/xhci_hcd/bind
        done
        ;;
esac
