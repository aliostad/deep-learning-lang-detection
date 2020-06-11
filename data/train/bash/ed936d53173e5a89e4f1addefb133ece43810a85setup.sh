#!/bin/sh

export repo=$1
# DIR is a path to project
export DIR=/home/janisz/workspace/mgr
# DATA_DIR is a path to directory where data
export DATA_DIR=$DIR/data
# REPO_DIR is a path to directory where repo is cloned
export REPO_DIR=/run/media/janisz/A276F14776F11CAB/mgr/repos/$repo
# REPO_DATA_DIR is directory where data for specific $repo are stored
export REPO_DATA_DIR=$DATA_DIR/repos/$repo
# CODE_MAAT is command to run code-maat
export CODE_MAAT="java -jar $DIR/bin/code-maat-0.9.2-SNAPSHOT-standalone.jar"
