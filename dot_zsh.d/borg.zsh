function setup_borg() {
command -v borg > /dev/null || return
alias mountbackup="borg mount /data/borg-backup ~/Backup"
alias umountbackup="borg umount ~/Backup"
}

setup_borg
