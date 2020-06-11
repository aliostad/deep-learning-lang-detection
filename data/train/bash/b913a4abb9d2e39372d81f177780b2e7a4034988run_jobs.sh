export WORKDIR=`pwd`
echo "Working on a machine:" `uname -a`
cd $WORKDIR
g++ turnOnN_1.C -g -o turnOn `root-config --cflags --glibs`
cp /afs/cern.ch/work/n/nchernya/Hbb/preselection_double_n_4.C .
cp /afs/cern.ch/work/n/nchernya/Hbb/preselection_single_n_4.C .


current_sample=0
next_sample=0
samples_num=9
set_type=0  # 0  for double and 1 for single
while [ $current_sample -lt $samples_num ]
#while [ $current_sample -lt 1 ]
do
	cd $WORKDIR
	next_sample=$((current_sample + 1))
	qsub -q all.q batch2.sh $current_sample $next_sample 0 0
	qsub -q all.q batch2.sh $current_sample $next_sample 1 0
	current_sample=$((current_sample + 1))
#	break
done
