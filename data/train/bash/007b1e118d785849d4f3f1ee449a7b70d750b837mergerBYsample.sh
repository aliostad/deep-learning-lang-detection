#! /bin/bash

source config.sh
if [ $# -eq 0 ];
then
        echo "uso:
    mergerBYsample.sh <DIR>
donde:
          <DIR>: direccion del directorio donde se encuentran 
                 los directorios de muestras a combinar
ejemplo:
    ./mergerBYsample.sh /home/user/proyecto/datosIntermedios"
        exit
fi

WORKdir=$1

cd $WORKdir
if [ -d bySAMPLE ];
then
	echo ya existe bySAMPLE
else
	mkdir bySAMPLE
fi
for h in $(ls | grep -v bySAMPLE | cut -d '_' -f2 | uniq); do
	if [ -d $WORKdir/bySAMPLE/Sample_$h ];
	then
		echo ya existe $WORKdir/bySAMPLE/Sample_$h
	else
		echo mkdir $WORKdir/bySAMPLE/Sample_$h
		mkdir $WORKdir/bySAMPLE/Sample_$h
	fi
	if [ -f $WORKdir/bySAMPLE/Sample_$h/aln_final_picard.bam ];
	then
		echo ya se ha procesado
	else
		orden="java -jar $PICARDdir/MergeSamFiles.jar"
		for i in $(ls | grep $h"_"); do
			orden="$orden INPUT=$WORKdir/$i/aln_final_picard.bam "
		done
		orden="$orden OUTPUT=$WORKdir/bySAMPLE/Sample_$h/aln_final_picard.bam"
		$orden
	fi
done 
