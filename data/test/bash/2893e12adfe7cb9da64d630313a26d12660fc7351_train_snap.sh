module load perl
module load stajichlab
module load maker/2.31.8
module load snap
module load augustus/2.7

mkdir retrain
ln -s ../MAKER/Mn35.all.functional.gff
mkdir snap
cd snap
#maker2zff  Mn35.all.functional.gff
maker2zff -c 0 -e 0  Mn35.all.functional.gff
fathom -categorize 1000 genome.ann genome.dna
fathom -export 1000 -plus uni.ann uni.dna
forge export.ann export.dna
hmm-assembler.pl Mn35.retrain .  > ../Mn35.retrain.hmm
hmm-assembler.pl -x Mn35.retrain .  > ../Mn35.retrain.length.hmm
