#!/bin/bash

EXPECTED_ARGS=4
if [ $# -ne $EXPECTED_ARGS ]
then
    echo "usage: {path to log1} {path to log2} {destination_hashes folder} {destination_figures folder}"
    exit 0
fi

echo ""
currenttime=$(date +"%D %I %M %P")
CHUNK_SIZE=1000
echo "[$currenttime] Trying chunk_size = $CHUNK_SIZE"
/home/syed/Workspace/Samples/Comparison/hasher.py $1 $2 $CHUNK_SIZE $3/
(diff "$3/hash1-$CHUNK_SIZE.log" "$3/hash2-$CHUNK_SIZE.log" -y --side-by-side --minimal --text) > "$3/diff-$CHUNK_SIZE.log" 
/home/syed/Workspace/Samples/Comparison/diff_plotter.py "$3/diff-$CHUNK_SIZE.log"  "$4/$CHUNK_SIZE.pdf"

echo ""
currenttime=$(date +"%D %I %M %P")
CHUNK_SIZE=100
echo "[$currenttime] Trying chunk_size = $CHUNK_SIZE"
/home/syed/Workspace/Samples/Comparison/hasher.py $1 $2 $CHUNK_SIZE $3/
(diff "$3/hash1-$CHUNK_SIZE.log" "$3/hash2-$CHUNK_SIZE.log" -y --side-by-side --minimal --text) > "$3/diff-$CHUNK_SIZE.log" 
/home/syed/Workspace/Samples/Comparison/diff_plotter.py "$3/diff-$CHUNK_SIZE.log"  "$4/$CHUNK_SIZE.pdf"

echo ""
currenttime=$(date +"%D %I %M %P")
CHUNK_SIZE=1000
echo "[$currenttime] Trying chunk_size = $CHUNK_SIZE"
/home/syed/Workspace/Samples/Comparison/hasher.py $1 $2 $CHUNK_SIZE $3/
(diff "$3/hash1-$CHUNK_SIZE.log" "$3/hash2-$CHUNK_SIZE.log" -y --side-by-side --minimal --text) > "$3/diff-$CHUNK_SIZE.log" 
/home/syed/Workspace/Samples/Comparison/diff_plotter.py "$3/diff-$CHUNK_SIZE.log"  "$4/$CHUNK_SIZE.pdf"

echo ""
currenttime=$(date +"%D %I %M %P")
CHUNK_SIZE=100000
echo "[$currenttime] Trying chunk_size = $CHUNK_SIZE"
/home/syed/Workspace/Samples/Comparison/hasher.py $1 $2 $CHUNK_SIZE $3/
(diff "$3/hash1-$CHUNK_SIZE.log" "$3/hash2-$CHUNK_SIZE.log" -y --side-by-side --minimal --text) > "$3/diff-$CHUNK_SIZE.log" 
/home/syed/Workspace/Samples/Comparison/diff_plotter.py "$3/diff-$CHUNK_SIZE.log"  "$4/$CHUNK_SIZE.pdf"


echo ""
currenttime=$(date +"%D %I %M %P")
CHUNK_SIZE=5000
echo "[$currenttime] Trying chunk_size = $CHUNK_SIZE"
/home/syed/Workspace/Samples/Comparison/hasher.py $1 $2 $CHUNK_SIZE $3/
(diff "$3/hash1-$CHUNK_SIZE.log" "$3/hash2-$CHUNK_SIZE.log" -y --side-by-side --minimal --text) > "$3/diff-$CHUNK_SIZE.log" 
/home/syed/Workspace/Samples/Comparison/diff_plotter.py "$3/diff-$CHUNK_SIZE.log"  "$4/$CHUNK_SIZE.pdf"

echo "[$currenttime] Done."