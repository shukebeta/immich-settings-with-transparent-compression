#!/bin/bash

# define source and destination dirs
SOURCE_DIR="/path/to/immich/library"
DEST_DIR1="remote1:/backup/path"
DEST_DIR2="remote2:/backup/path"

# do syncing every a few minuts: you'll need a cron task to run this script
rsync -av --exclude='tmp/' "$SOURCE_DIR" "$DEST_DIR1"
rsync -av --exclude='tmp/' "$SOURCE_DIR" "$DEST_DIR2"

