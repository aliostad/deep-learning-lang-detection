#!/bin/bash
# ==============================================================================
# = Submit LHE->Pool + Pool->Truth Ntuple to lxplus batch queue
# = This should be called from the BMinusLSUSY directort. It will create two
# = directories.
# =   jobs: hold job stearing files for the batch jobs - This can be discarded
# =         once jobs are completed
# =   d3pd: output ntuples will be copied here
# = usage: ./SubmitToBatch.sh <model dir> <model name> <queue>
# ==============================================================================

${DIR_ON_AFS_WORK}=${PWD}
model_dir=$1
model_name=$2
queue=$3

lhe_file="MadGraph5_v1_5_13/${model_name}/Events/unweighted_events.lhe"

echo "LHE file: $lhe_file"
echo "model dir: $model_dir"
echo "model name: $model_name"
echo "queue: $queue"

mkdir jobs
mkdir d3pd

echo "#!/bin/bash" > jobs/jo_$model_name.sh
echo "" >> jobs/jo_$model_name.sh

echo "source ~/.bash_profile" >> jobs/jo_$model_name.sh
echo "" >> jobs/jo_$model_name.sh

echo "echo \"Copying files to worker node\"" >> jobs/jo_$model_name.sh
# echo "cp -r $TestArea ." >> jobs/jo_$model_name.sh
# echo "cd $(echo ${TestArea} | sed 's#.*/\(.*\)$#\1#g')" >> jobs/jo_$model_name.sh
echo "cp -rf $PWD ." >> jobs/jo_$model_name.sh
echo "cd $(echo ${PWD} | sed 's#.*/\(.*\)$#\1#g')" >> jobs/jo_$model_name.sh
echo "" >> jobs/jo_$model_name.sh

echo "echo \"Setting up Athena :-(\"" >> jobs/jo_$model_name.sh
echo "source SetupAthena" >> jobs/jo_$model_name.sh
echo "echo \"Done setting up Athena :-)\"" >> jobs/jo_$model_name.sh
echo "" >> jobs/jo_$model_name.sh

echo "echo \"Converting LHE file(${lhe_file}) to pool file\"" >> jobs/jo_$model_name.sh
echo "ls ${lhe_file}" >> jobs/jo_$model_name.sh
echo "./${model_dir}/LheToPool.sh ${lhe_file} ${model_name}" >> jobs/jo_$model_name.sh echo "ls" >> jobs/jo_$model_name.sh
echo "" >> jobs/jo_$model_name.sh

echo "echo \"Converting Pool file to truth ntuple\"" >> jobs/jo_$model_name.sh
echo "./${model_dir}/PoolToTruthNtup.sh ${model_name}" >> jobs/jo_$model_name.sh
echo "ls" >> jobs/jo_$model_name.sh
echo "" >> jobs/jo_$model_name.sh

echo "echo \"copying root files to work space\"" >> jobs/jo_$model_name.sh
echo "cp *root ${PWD}/d3pd" >> jobs/jo_$model_name.sh
echo "" >> jobs/jo_$model_name.sh

chmod +x jobs/jo_${model_name}.sh

echo "command"
cat jobs/jo_${model_name}.sh

bsub -q $queue ${PWD}/jobs/jo_${model_name}.sh
