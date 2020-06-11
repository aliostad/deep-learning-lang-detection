#!/bin/bash

usage(){
    echo $0 "<work size> <chunk size>"
    exit 1
}
if [ -z $1 ]
then
    usage
fi
if [ -z $2 ]
then
    usage
fi

echo $OAR_JOB_ID >> jobs

echo "calcul des paramettres..."
let worker_number="`cat $OAR_FILE_NODES | wc -l`-1"
master=`cat $OAR_FILE_NODES | head -n 1` 
workers=`cat $OAR_FILE_NODES | tail -n $worker_number`
work_size=$1
chunk_size=$2

echo "lancement du maitre..."
oarsh $master "sh master.sh $chunk_size" &
sleep 1

echo "lancement des esclaves..."
for host in $workers; do
    oarsh $host "sh worker.sh $master" &
done
sleep 1

echo "lancement du calcul..."
time java -cp sid.jar sid.integrale.ApplicationImpl $master $work_size
echo -e "nombre de noeuds\t"${worker_number}
echo -e "taille du travail\t"${work_size}
echo -e "taille des morceaux\t"${chunk_size}
