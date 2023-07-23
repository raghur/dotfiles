#! /bin/bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
        # not root - so elevate and run ourself
        sudo "$0"
else
# ok - we're root
source /root/.config/borgvars

# export BORG_PASSPHRASE=
# USER=xbmc
# BORGREPO=/var/borg-backup
# BORGIGNORE=/home/$USER/.borgignore

cat << EOF
Will now mount your borg backup to ~/Backup
Use your file browser to browse/copy etc. Once done, press CTRL-C to exit
EOF

borg mount -f -o "allow_other,uid=1000,gid=1000" "${BORGREPO}" "/home/${USER}/Backup"
fi


