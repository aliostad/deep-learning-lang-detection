#!/bin/bash


BIN=./bin/mpi-ms
LOGFILE=./log

# num of nodes
#NODES=8
HOSTS=1


# init sizes
# VOLUME == FACTOR^n * CHUNK
VOLUME=$((100 * 1000 * 1000))
INITCHUNK=1000
FACTOR=10


for NODES in `seq 8 -2 2 `
do

# reset chunk size
CHUNK=$INITCHUNK


while [ ${CHUNK} -lt ${VOLUME} ]
do
    echo "Berechne: $NODES $CHUNK $VOLUME"

    # logging
    LOGSTRING=`hostname | tr -d "\n" ; echo -n " - "; date | tr -d "\n"`

   mpirun -n $NODES $BIN -c $CHUNK -v $VOLUME >>"data/$HOSTS-$NODES-$VOLUME-$CHUNK.log"

    # logging
   echo "$LOGSTRING: $HOSTS-$NODES-$VOLUME-$CHUNK">>$LOGFILE

    CHUNK=$((CHUNK*FACTOR))
# end of while chunk size
done

# end of for NODES
done
