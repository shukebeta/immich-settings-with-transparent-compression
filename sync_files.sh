#!/bin/bash

# 定义源和目标目录
SOURCE_DIR="/home/shukebeta/Projects/immich-app/library"
DEST_DIR1="xps:/backup/photos"
DEST_DIR2="arm:~/backups/photos"

# 执行 rsync 命令
rsync -av --exclude='tmp/' "$SOURCE_DIR" "$DEST_DIR1"
rsync -av --exclude='tmp/' "$SOURCE_DIR" "$DEST_DIR2"

