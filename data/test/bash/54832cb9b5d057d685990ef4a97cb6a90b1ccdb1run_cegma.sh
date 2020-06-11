#PBS -l nodes=1:ppn=8,mem=24gb -q js -N cegma -j oe 

module load cegma
module load hmmer
module load wise
module load geneid
module load stajichlab
module load snap
module load augustus
module load ncbi-blast/2.2.25+
hostname

if [ ! $PBS_NP ]; then
 PBS_NP=1
fi

JOB=$PBS_ARRAYID

if [ ! $JOB ]; then
 JOB=1
fi

FILE=`ls ../*.fasta | head -n $JOB | tail -n 1`
BASE=`basename $FILE .fasta`
if [ ! -d $BASE ]; then
 mkdir -p $BASE
 cd $BASE
 cegma -g ../$FILE -T $PBS_NP --max_intron 2000
else
 echo "CEGMA already run for $BASE ($FILE)"
fi

