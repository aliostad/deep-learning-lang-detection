#!/usr/bin/env bash

# stop immediately if any process returns non-zero exit code
set -e

# sanity check:
# this script deletes files left and right
# make sure that it's deleting the right ones
if [ "$0" != "./scripts/chunkWiki.sh" ]; then
  echo "Build failed: Wrong cwd"
  echo "Executed from wrong cwd, you need to be in the obsidian root to call this script"
  exit 1
fi

# run build script
chmod +x ./scripts/build.sh && ./scripts/build.sh

# remove existing logs
if [ -d /var/log/obsidian/chunkAllWiki ]; then
  echo "Removing existing logs..."
  rm -r /var/log/obsidian/chunkAllWiki
fi

mkdir -p /var/log/obsidian/chunkAllWiki

# avoid memory leaks by exiting after 25 files of 20MB each :)
node ./bin/index.js --type=wikiChunker --path=./data/wiki_all/ >/var/log/obsidian/chunkAllWiki/stdout.log 2>/var/log/obsidian/chunkAllWiki/stderr.log &

sleep 1
tail -F -n 1000 /var/log/obsidian/chunkAllWiki/*
