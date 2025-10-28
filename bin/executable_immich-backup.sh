#!/bin/sh

# Paths
UPLOAD_LOCATION="/home/raghu/immich/library"
BACKUP_PATH="/mnt/elements/borg"
export BORG_PASSPHRASE=$(cat "/root/.config/borg/immich-borg.passphrase")

BORG_REPO="$BACKUP_PATH/immich-borg"
### Local

# Backup Immich database
docker exec --env-file /opt/stacks/immich/.env immich_postgres pg_dumpall --clean --if-exists --username=postgres > "$UPLOAD_LOCATION"/database-backup/immich-database.sql

### Append to local Borg repository
borg create "$BORG_REPO::{now}" "$UPLOAD_LOCATION" --exclude "$UPLOAD_LOCATION"/thumbs/ --exclude "$UPLOAD_LOCATION"/encoded-video/ --exclude "$UPLOAD_LOCATION"/backups
borg list "$BORG_REPO"
borg prune --keep-weekly=4 --keep-monthly=3 "$BORG_REPO"
borg compact "$BORG_REPO"

rclone sync -v $BORG_REPO immich-az:immich/
