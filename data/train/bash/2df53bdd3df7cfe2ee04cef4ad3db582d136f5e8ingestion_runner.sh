#!/bin/bash
set -x #echo on

# Runner script for ingesting files of different files and sizes for different
# READ_CHUNK_SIZE.

if [ "$#" -ne 1 ]; then
  echo "usage: ingestion_runner [BinaryBackend|HDF5Backend|TileDBBackend]"
  exit
fi

BACKEND=$1
EMAIL="joshblum@mit.edu"
HOSTNAME=$(hostname)
EXP_NAME="ingestion experiment"

WORK_DIR=".."
cd $WORK_DIR

MRN="005"
RESULTS_FILE="experiments/ingestion_results.txt-"$BACKEND
mv $RESULTS_FILE $RESULTS_FILE-bak-$(date +%s)

#READ_CHUNK_SIZES="64 128 256 512" # MB
READ_CHUNK_SIZES="256" # MB
FILE_SIZES="1 2 4 8 16 32 64 128" # GB

# setup symlinks for file names
for file_size in $FILE_SIZES; do
  ln -s ~/eeg-data/eeg-data/${MRN}.edf ~/eeg-data/eeg-data/${MRN}-${file_size}gb.edf
done;

for file_size in $FILE_SIZES; do
  for read_chunk in $READ_CHUNK_SIZES; do
    make clean
    make edf_converter READ_CHUNK=$read_chunk BACKEND=$BACKEND -j4

    # clear file systems caches
    sync && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'

    # edf_converter <mrn> <desired_size>
    ./edf_converter ${MRN}-${file_size}gb $file_size |& tee -a $RESULTS_FILE
  done;
done;

PAYLOAD="${HOSTNAME} completed ${EXP_NAME} for ${BACKEND} $(date)"
./experiments/send_mail.sh "$EMAIL" "$PAYLOAD"

