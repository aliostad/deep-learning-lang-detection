#!/bin/bash
set -x #echo on

# Runner script for precomputing files of different files and sizes for
# different WRITE_CHUNK_SIZEs.

if [ "$#" -ne 1 ]; then
  echo "usage: precompute_runner [BinaryBackend|HDF5Backend|TileDBBackend]"
  exit
fi

BACKEND=$1
EMAIL="joshblum@mit.edu"
HOSTNAME=$(hostname)
EXP_NAME="precompute experiment"

WORK_DIR=".."
cd $WORK_DIR

MRN="005"
RESULTS_FILE="experiments/precompute_results.txt-"$BACKEND
mv $RESULTS_FILE $RESULTS_FILE-bak-$(date +%s)

#WRITE_CHUNK_SIZES="64 128 256 512" #MB
WRITE_CHUNK_SIZES="256" #MB
FILE_SIZES="1 2 4 8 16 32 64 128" # GB

for file_size in $FILE_SIZES; do
  for write_chunk in $WRITE_CHUNK_SIZES; do
  make clean
  make precompute_spectrogram WRITE_CHUNK=$write_chunk BACKEND=$BACKEND -j4

  # clear file systems caches
  sync && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'

  # precompute_spectrogram <mrn>
  ./precompute_spectrogram ${MRN}-${file_size}gb |& tee -a $RESULTS_FILE
  done;
done;

PAYLOAD="${HOSTNAME} completed ${EXP_NAME} for ${BACKEND} $(date)"
./experiments/send_mail.sh "$EMAIL" "$PAYLOAD"

