#!/bin/bash

# define source and destination dirs
SOURCE_DIR="/home/shukebeta/Projects/immich-app/library"
DEST_DIR1="xps:/backup/photos"
DEST_DIR2="arm:~/backups/photos"

# do syncing every a few minuts: you'll need a cron task to run this script
rsync -av --exclude='tmp/' "$SOURCE_DIR" "$DEST_DIR1"
rsync -av --exclude='tmp/' "$SOURCE_DIR" "$DEST_DIR2"

