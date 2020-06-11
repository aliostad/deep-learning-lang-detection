#!/bin/bash
# Note: This script is feeling free and will absolutely forever.
#       Interrupt it when you feel done stressing the Python script.  :)

PYTHON_SCRIPT="single_threaded_approach/main.py"
INPUT_FILE="input_data/big_input"

SLEEP_MIN=10
SLEEP_MAX=30
function GEN_SLEEP_TIME()
{
  SLEEP_TIME=$[($RANDOM % SLEEP_MAX) + SLEEP_MIN]
}
GEN_SLEEP_TIME

SAVE_MIN=10000
SAVE_MAX=100000
function GEN_SAVE_INTERVAL()
{
  SAVE_INTERVAL=$[($RANDOM % SAVE_MAX) + SAVE_MIN]
}
GEN_SAVE_INTERVAL

while :
do
  python $PYTHON_SCRIPT -f $INPUT_FILE -s $SAVE_INTERVAL &
  PID=$!
  sleep $SLEEP_TIME
  kill -9 $PID
  GEN_SLEEP_TIME
  GEN_SAVE_INTERVAL
  echo "Restarting with runtime $SLEEP_TIME seconds and $SAVE_INTERVAL write interval..."
done
