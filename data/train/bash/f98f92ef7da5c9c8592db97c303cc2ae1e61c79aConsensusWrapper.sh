#!/bin/bash

### Refer to the README for info on this wrapper and associated Consensus.sh script

modelModelA=$1
modelModelB=$2
consensusModel=$3
NUMREPS=$4

for ((i=0;i<=$NUMREPS;++i))
do
    myModelA=${modelModelA}_${i}.asc
    echo "$myModelA"
    myModelB=${modelModelB}_${i}.asc
    echo "$myModelB"
    myConsensus=${consensusModel}_${i}.asc
    sed 's/gridA_/'`echo "$myModelA"`'/;s/gridB_/'`echo "$myModelB"`'/;s/CON_gridAB_/'`echo "$myConsensus"`'/' Consensus.sh > consensus_temp.sh
    chmod u+x consensus_temp.sh
    ./consensus_temp.sh
done && rm consensus_temp.sh
